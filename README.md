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

Source: https://github.com/baldwinsung/SimpleClaudeMenuBar

Built with [Claude Code](https://claude.com/claude-code) (Opus).
