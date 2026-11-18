#!/bin/bash
# install-menubar-apps.sh — build and install baldwinsung's macOS menu bar apps.
#
#   curl -fsSL https://raw.githubusercontent.com/baldwinsung/homebrew-tap/main/install-menubar-apps.sh | bash
#   ... | bash -s -- toner dns        # only these
#
# Apps: proxy (MacProxyMenuBar), toner (MacTonerMenuBar). claude, dns and
# whois are archived and no longer installed (uninstall-menubar-apps.sh still
# removes them).
#
# Clones each repo into a temporary folder and runs its own install script,
# which builds from source and copies the app into /Applications (asking for
# sudo when it needs it). Needs the Xcode command-line tools; proxy needs full
# Xcode and is skipped without it. Undo with uninstall-menubar-apps.sh.
set -euo pipefail

WANT=()
for a in "$@"; do
  case $a in
    -h|--help) sed -n '2,15p' "$0" 2>/dev/null | sed 's/^# \{0,1\}//'; exit 0 ;;
    proxy|toner) WANT+=("$a") ;;
    claude|dns|whois) echo "$a-menubar is archived and no longer installed" >&2; exit 2 ;;
    *) echo "unknown argument: $a (proxy toner)" >&2; exit 2 ;;
  esac
done
[ ${#WANT[@]} -eq 0 ] && WANT=(proxy toner)

[ "$(uname -s)" = Darwin ] || { echo "macOS only" >&2; exit 1; }
command -v git >/dev/null && command -v swift >/dev/null || {
  echo "Xcode command-line tools are missing. Run: xcode-select --install" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
ok=() failed=() skipped=()

for k in "${WANT[@]}"; do
  case $k in
    proxy|toner) script=build.sh ;;
  esac
  if [ "$k" = proxy ] && ! xcodebuild -version >/dev/null 2>&1; then
    echo "== proxy-menubar: skipped (needs full Xcode, not just the command-line tools)"
    skipped+=(proxy); continue
  fi
  echo "== $k-menubar"
  if git clone -q --depth 1 "https://github.com/baldwinsung/$k-menubar.git" "$work/$k" &&
     (cd "$work/$k" && bash "$script" </dev/tty); then
    ok+=("$k")
  else
    echo "!! $k-menubar failed (see output above)" >&2
    failed+=("$k")
  fi
done

echo
# ${a[@]+...}: macOS bash 3.2 treats an empty array as unset under set -u
echo "Installed: ${ok[@]+${ok[*]}}"
[ ${#skipped[@]} -gt 0 ] && echo "Skipped:   ${skipped[*]}"
[ ${#failed[@]} -gt 0 ] && { echo "Failed:    ${failed[*]}"; exit 1; }
for k in ${ok[@]+"${ok[@]}"}; do
  case $k in
    proxy) open -a MacProxyMenuBar ;; toner) open -a MacTonerMenuBar ;;
  esac 2>/dev/null || true
done
echo "Launched. Look for the icons in the menu bar."
