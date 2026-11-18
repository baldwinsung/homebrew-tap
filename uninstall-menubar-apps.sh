#!/bin/bash
# uninstall-menubar-apps.sh — remove baldwinsung's macOS menu bar apps.
#
#   ./uninstall-menubar-apps.sh              # remove all five
#   ./uninstall-menubar-apps.sh toner dns    # remove only these
#   ./uninstall-menubar-apps.sh -n           # dry run: show what would go
#
# Apps: claude (SimpleClaudeMenuBar), dns (SimpleDNSMenuBar + its root helper
# daemon), proxy (MacProxyMenuBar, formerly SimpleProxyMenuBar), toner
# (MacTonerMenuBar, formerly SimpleTonerBar), whois (SimpleWhoisGeo).
#
# For each app it quits it, uninstalls the Homebrew cask if there is one,
# removes the app from /Applications and ~/Applications, its login item and
# its preferences, caches and saved state. Asks for sudo only when a file
# needs it (apps installed with `sudo ditto`, the DNS helper daemon).
#
# The DNS app's helper sets DNS servers on your network services. Removing it
# leaves whatever servers it last set. To go back to DHCP-provided DNS:
#   networksetup -setdnsservers Wi-Fi Empty
set -euo pipefail

DRY=0
WANT=()
for a in "$@"; do
  case $a in
    -n|--dry-run) DRY=1 ;;
    -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    claude|dns|proxy|toner|whois) WANT+=("$a") ;;
    *) echo "unknown argument: $a (try --help)" >&2; exit 2 ;;
  esac
done
[ ${#WANT[@]} -eq 0 ] && WANT=(claude dns proxy toner whois)

[ "$(uname -s)" = Darwin ] || { echo "macOS only" >&2; exit 1; }

# key  app name  bundle id  brew cask (or -). A key can have several rows
# (current and former app names); every row is removed.
APPS="
claude SimpleClaudeMenuBar com.baldwinsung.SimpleClaudeMenuBar simpleclaudemenubar
dns    SimpleDNSMenuBar    com.baldwinsung.SimpleDNSMenuBar    -
proxy  MacProxyMenuBar     com.user.SimpleProxyMenuBar         -
proxy  SimpleProxyMenuBar  com.user.SimpleProxyMenuBar         -
toner  MacTonerMenuBar     com.baldwinsung.SimpleTonerBar      -
toner  SimpleTonerBar      com.baldwinsung.SimpleTonerBar      -
whois  SimpleWhoisGeo      com.baldwinsung.SimpleWhoisGeo      -
"

run() {
  if [ $DRY = 1 ]; then echo "  would: $*"; else "$@"; fi
}

# rm a path, with sudo if the parent isn't writable.
remove() {
  local p=$1
  [ -e "$p" ] || [ -L "$p" ] || return 0
  echo "  remove $p"
  if [ -w "$(dirname "$p")" ]; then run rm -rf "$p"; else run sudo rm -rf "$p"; fi
}

uninstall() {
  local key=$1 name=$2 id=$3 cask=$4
  echo "== $name"

  if pgrep -xq "$name"; then
    echo "  quit $name"
    run osascript -e "tell application id \"$id\" to quit" >/dev/null 2>&1 || true
    [ $DRY = 1 ] || { sleep 1; pkill -x "$name" 2>/dev/null || true; }
  fi

  if [ "$cask" != - ] && command -v brew >/dev/null && brew list --cask "$cask" >/dev/null 2>&1; then
    echo "  brew uninstall --cask --zap $cask"
    run brew uninstall --cask --zap "$cask"
  fi

  # Login item (System Settings > General > Login Items). Apps that use
  # SMAppService.mainApp drop out of the list once the app is gone.
  if osascript -e "tell application \"System Events\" to get the name of every login item" 2>/dev/null | grep -q "$name"; then
    echo "  remove login item $name"
    run osascript -e "tell application \"System Events\" to delete login item \"$name\"" >/dev/null || true
  fi

  remove "/Applications/$name.app"
  remove "$HOME/Applications/$name.app"

  if [ $DRY = 0 ]; then defaults delete "$id" >/dev/null 2>&1 || true; fi
  for p in \
    "$HOME/Library/Preferences/$id.plist" \
    "$HOME/Library/Caches/$id" \
    "$HOME/Library/HTTPStorages/$id" \
    "$HOME/Library/HTTPStorages/$id.binarycookies" \
    "$HOME/Library/Saved Application State/$id.savedState" \
    "$HOME/Library/Application Support/$name" \
    "$HOME/Library/Containers/$id"; do
    remove "$p"
  done

  if [ "$key" = dns ]; then
    local d=com.baldwinsung.simpledns
    if [ -e "/Library/LaunchDaemons/$d.plist" ] || [ -e "/Library/PrivilegedHelperTools/$d" ]; then
      echo "  stop helper daemon $d"
      run sudo launchctl bootout "system/$d" 2>/dev/null || true
      run sudo rm -f "/Library/LaunchDaemons/$d.plist" "/Library/PrivilegedHelperTools/$d"
    fi
  fi
}

for k in "${WANT[@]}"; do
  # fd 3, so brew/osascript/sudo inside uninstall can't eat the rows
  while read -r line <&3; do
    # shellcheck disable=SC2086
    uninstall $line
  done 3< <(echo "$APPS" | awk -v k="$k" '$1 == k')
done
[ $DRY = 1 ] && echo "(dry run: nothing changed)"
echo "Done."
