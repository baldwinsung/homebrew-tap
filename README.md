# baldwinsung/homebrew-tap

Homebrew tap for my apps.

## SimpleClaudeMenuBar (deprecated)

Archived 2026-11-18: Claude Code's status line shows the same session and
weekly usage. Setup steps are in the
[claude-menubar README](https://github.com/baldwinsung/claude-menubar#instead-claude-code-status-line).
The cask stays for existing installs; remove it with
`brew uninstall --cask --zap simpleclaudemenubar`.

Built with [Claude Code](https://claude.com/claude-code) (Opus).

## Installing all the menu bar apps

```bash
curl -fsSL https://raw.githubusercontent.com/baldwinsung/homebrew-tap/main/install-menubar-apps.sh | bash
```

Installs the two active apps, proxy-menubar and toner-menubar (claude, dns
and whois are archived). Builds each from source with its repo's own install
script and launches it. Needs the Xcode command-line tools (`xcode-select --install`); proxy needs
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
