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

## Installing all the menu bar apps

```bash
curl -fsSL https://raw.githubusercontent.com/baldwinsung/homebrew-tap/main/install-menubar-apps.sh | bash
```

Builds each app from source with its repo's own install script and launches
it. Needs the Xcode command-line tools (`xcode-select --install`); proxy needs
full Xcode and is skipped without it. Pick apps with `| bash -s -- toner dns`.

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
