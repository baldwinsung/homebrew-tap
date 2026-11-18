# baldwinsung/homebrew-tap

Homebrew tap for my apps.

## SimpleClaudeMenuBar

A macOS menu bar app showing your Claude Code session usage and reset time.

```sh
brew install --cask baldwinsung/tap/simpleclaudemenubar
```

Not notarized yet, so on first launch macOS may say it "cannot be opened."
Either right-click the app in `/Applications` ▸ **Open** ▸ confirm, or run:

```sh
xattr -dr com.apple.quarantine "/Applications/SimpleClaudeMenuBar.app"
```

Each release is ad-hoc signed with a fresh identity, so this isn't one-time —
`brew upgrade` re-quarantines the app on every new release too.

Source: https://github.com/baldwinsung/claude-menubar

Built with [Claude Code](https://claude.com/claude-code) (Opus).

## Uninstalling the menu bar apps

`uninstall-menubar-apps.sh` removes any of the menu bar apps (claude, dns,
proxy, toner, whois), whether installed by this tap or by a repo's own install
script: the app, its login item, preferences, caches, and for the DNS app its
root helper daemon.

```bash
curl -fsSLO https://raw.githubusercontent.com/baldwinsung/homebrew-tap/main/uninstall-menubar-apps.sh
bash uninstall-menubar-apps.sh -n        # dry run
bash uninstall-menubar-apps.sh           # all five
bash uninstall-menubar-apps.sh toner dns # only these
```
