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

Source: https://github.com/baldwinsung/SimpleClaudeMenuBar

Built with [Claude Code](https://claude.com/claude-code) (Opus).
