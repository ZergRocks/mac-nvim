# Mac Nvim Configuration

> Clean and efficient Neovim setup for macOS with Solarized Light theme

## Features

- **Unified Solarized Light Theme**: Consistent light yellow theme across Neovim and Tmux
- **Essential Plugins Only**: Streamlined plugin selection focused on core functionality
- **LSP Integration**: Modern Language Server Protocol support with Mason
- **Git Workflow**: Integrated Git operations with Fugitive and Gitsigns
- **File Navigation**: FZF integration for fast file finding
- **Tmux Integration**: Seamless navigation between Neovim and Tmux panes

## Installation

### Prerequisites
- Neovim >= 0.8
- Git
- Node.js (for LSP servers)
- FZF
- Tmux (optional)

### Quick Setup
```bash
cd ~
git clone https://github.com/tridge-hq/nvim-lua.git mac-nvim
cd mac-nvim
./install.sh
```

### Manual Installation
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Link configuration
ln -s $(pwd) ~/.config/nvim
ln -s $(pwd)/tmux.conf ~/.tmux.conf

# Install plugins (open nvim and plugins will auto-install)
nvim
```

## Directory Structure

```
├── init.lua              # Entry point
├── lua/
│   ├── core.lua         # Core vim settings
│   ├── plugins.lua      # Plugin specifications
│   ├── configs.lua      # Plugin configurations
│   ├── lsp.lua          # LSP and completion setup
│   └── keymaps.lua      # Key mappings
├── tmux.conf            # Tmux configuration
├── zshrc               # Shell configuration
└── install.sh          # Installation script
```

## Key Mappings

### Leader Key
- Leader: `,`

### File Navigation
- `<Leader>f` - Find files
- `<Leader>b` - Switch buffers
- `<Leader>nn` - Toggle file tree
- `<Leader>nt` - Find current file in tree

### Git Operations
- `<Leader>gs` - Git status
- `<Leader>gd` - Git diff
- `<Leader>gg` - Git blame
- `<Leader>gh` - Show diff for current hunk
- `<Leader>p` - Preview hunk inline

### LSP Features
- `gD` - Go to definition
- `gK` - Show documentation
- `gr` - Find references
- `<space>rn` - Rename symbol
- `<space>f` - Format document

### Window Management
- `<C-h/j/k/l>` - Navigate between panes (Neovim + Tmux)
- `bn/bm` - Previous/next buffer
- `bd` - Close buffer

### Utilities
- `<Leader>u` - Toggle undo tree
- `<Leader>y` - Copy to system clipboard
- `<Leader>zz` - Remove trailing whitespace

## Plugin List

### Core Functionality
- **nvim-solarized-lua** - Solarized Light colorscheme
- **which-key.nvim** - Key binding hints
- **Comment.nvim** - Smart commenting
- **vim-surround** - Surround text objects
- **vim-sneak** - Fast 2-character search
- **undotree** - Visual undo history

### File Management
- **nvim-tree.lua** - File explorer
- **fzf** & **fzf.vim** - Fuzzy file finding

### Git Integration
- **gitsigns.nvim** - Git decorations and hunks
- **vim-fugitive** - Git commands integration

### LSP & Development
- **mason.nvim** - LSP server management
- **nvim-lspconfig** - LSP configurations
- **nvim-cmp** - Autocompletion
- **nvim-treesitter** - Syntax highlighting
- **LuaSnip** - Snippet engine

### UI Enhancement
- **lualine.nvim** - Status line
- **bufferline.nvim** - Buffer tabs
- **nvim-web-devicons** - File icons

## Theme Details

### Solarized Light Colors
- **Background**: Light cream (#fdf6e3)
- **Foreground**: Dark gray (#586e75)
- **Accent**: Golden yellow (#b58900)
- **Active elements**: Blue (#268bd2)

### Customization
The theme provides:
- High contrast for readability
- Reduced eye strain in bright environments
- Consistent colors across Neovim and Tmux
- Professional appearance suitable for all contexts

## Maintenance

### Updating Plugins
```bash
# Open Neovim and run
:Lazy update
```

### Updating LSP Servers
```bash
# Open Neovim and run
:Mason
# Then press 'U' to update all installed servers
```

### Adding New Languages
1. Add LSP server to `lua/lsp.lua`
2. Add treesitter parser to `lua/configs.lua`
3. Restart Neovim

## Troubleshooting

### Colors Not Showing Properly
```bash
# Check terminal color support
echo $TERM
# Should show: screen-256color or xterm-256color

# For iTerm2/Terminal.app, ensure true color support is enabled
```

### LSP Not Working
```bash
# Check if LSP server is installed
:Mason
# Install required language servers

# Check LSP status
:LspInfo
```

### Tmux Integration Issues
```bash
# Ensure tmux configuration is loaded
tmux source-file ~/.tmux.conf

# Check if pane navigation works
# Press <C-h> to move left between panes
```

## Performance Tips

1. **Lazy Loading**: Plugins load only when needed
2. **Minimal Plugin Set**: Only essential plugins included
3. **Optimized Settings**: Tuned for fast startup and responsive editing
4. **Clean Configuration**: No unnecessary features or bloat

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - feel free to customize for your needs.

## Acknowledgments

- Based on the original nvim-lua configuration
- Solarized theme by Ethan Schoonover
- Community contributions from various plugin authors