# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS-optimized Neovim configuration repository that implements a VSCode-style development environment with Solarized Light theme. The configuration emphasizes tab-buffer independence (similar to VSCode), Python development support, and Git integration.

## Core Architecture

### Configuration Loading Sequence
1. `init.lua` - Entry point that bootstraps lazy.nvim and loads all modules
2. `lua/settings.lua` - Basic Neovim options (loaded first)
3. `lua/keymaps.lua` - Key mappings (loaded second)
4. `lua/plugins.lua` - Plugin definitions via lazy.nvim spec
5. `lua/lsp.lua` - LSP configurations (loaded as a plugin dependency)

### Plugin Management Strategy
- **lazy.nvim** as plugin manager with lazy loading disabled for simplicity
- Plugins defined in `lua/plugins.lua` with inline configurations
- LSP setup separated in `lua/lsp.lua` as a plugin module to ensure proper loading order

### Key Design Decisions
- **Tab-Buffer Independence**: Uses `barbar.nvim` + `scope.nvim` to replicate VSCode's tab behavior where each tab maintains its own buffer list
- **LSP Architecture**: Mason manages LSP server installations, nvim-lspconfig handles configurations, with formatting delegated to conform.nvim (not native LSP formatting)
- **Python Environment**: Integrated with miniconda, using pyright for LSP and ruff for formatting/linting

## Development Commands

### Installation and Setup
```bash
# Full installation (Homebrew, packages, Python env, symlinks)
./install.sh

# Manual Neovim setup after changes
nvim
:Lazy sync              # Update/install plugins
:Mason                  # Manage LSP servers
:checkhealth           # Verify configuration
```

### Configuration Testing
```bash
# Test Neovim configuration
nvim --headless -c 'checkhealth' -c 'qa'

# Reload configuration without restart
:source %              # In current file
:source $MYVIMRC      # Reload init.lua
```

### Plugin Management
```bash
# In Neovim
:Lazy                  # Open plugin manager UI
:Lazy sync            # Update all plugins
:Lazy clean           # Remove unused plugins
:Lazy profile         # Performance profiling
```

### LSP Operations
```bash
# In Neovim
:Mason                # LSP server manager UI
:MasonInstall pyright # Install specific LSP
:LspInfo             # Current buffer LSP status
:LspRestart          # Restart LSP servers
```

## File Relationships

### Symlink Structure
The installation creates these symlinks:
- `~/.config/nvim/init.lua` → `./init.lua`
- `~/.config/nvim/lua/` → `./lua/`
- `~/.zshrc` → `./zshrc`
- `~/.tmux.conf` → `./tmux.conf`
- `~/mac-nvim/` → Current directory

### Configuration Dependencies
- `init.lua` requires all files in `lua/` directory
- `lua/lsp.lua` depends on Mason and nvim-cmp being loaded first
- `lua/plugins.lua` contains all plugin specifications including LSP module
- Keymaps reference plugin commands, so plugins must load before keymaps are used

## Security Considerations

### Token Management
- GitHub tokens and sensitive data must be stored in `~/.zshrc.local` (not tracked)
- The `zshrc` file sources `~/.zshrc.local` if it exists
- `.gitignore` excludes `.zshrc.local`, `.env`, and other sensitive files
- Never commit files containing patterns like `ghp_`, `sk-`, or other API tokens

### Git History
- Repository has been cleaned with BFG Repo-Cleaner
- Force pushes may be required after security cleanups
- Always verify no sensitive data in commits before pushing

## Common Modifications

### Adding a New Plugin
1. Add plugin spec to `lua/plugins.lua` in the return table
2. Include any required dependencies in the spec
3. Add keymaps to `lua/keymaps.lua` if needed
4. Run `:Lazy sync` to install

### Adding LSP Support for a Language
1. Add server configuration to `lua/lsp.lua` in the lspconfig section
2. Install the LSP server: `:MasonInstall <server-name>`
3. Add formatter/linter configuration if using conform.nvim/nvim-lint
4. Update README.md's language support table

### Modifying Keybindings
1. Edit `lua/keymaps.lua` for general keymaps
2. LSP-specific keymaps are in the LspAttach autocmd in `lua/lsp.lua`
3. Leader key is `,` (comma), defined in `lua/settings.lua`

## Known Configuration Patterns

### VSCode-style Buffer Management
- Buffers are scoped to tabs via scope.nvim
- `bm`/`bn` navigate buffers within current tab only
- `<Leader>gm`/`<Leader>gn` navigate all buffers globally
- New tabs start with empty buffer list

### LSP Formatting Delegation
- ESLint and TypeScript LSP servers have formatting disabled
- conform.nvim handles all formatting via `<space>f`
- This prevents conflicts between multiple formatters

### Python Development Setup
- Requires miniconda installation (handled by install.sh)
- Pyright provides intelligence, ruff handles formatting
- Virtual environments are auto-detected by pyright