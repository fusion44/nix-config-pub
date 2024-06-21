{pkgs}: let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  # Define a local plugin here and add it to the
  # plugin list below
  gen-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "gen-nvim";
    src = ../../../external/gen-nvim;
  };
  # zellijNav = pkgs.vimUtils.buildVimPlugin {
  #   name = "zellij-nav-nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "swaits";
  #     repo = "zellij-nav.nvim";
  #     rev = "25930804397ef540bd2de62f9897bc2db61f9baa";
  #     hash = "sha256-TUhA6UGwpZuYWDU4j430LMnHVD8cggwrAzQ+HlT5ox8=";
  #   };
  # };
  #
  # improvement ideas:
  # https://github.com/gbprod/yanky.nvim/
  # https://github.com/ggandor/leap.nvim
in {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  extraLuaConfig = ''
    ${builtins.readFile ./lua/utils.lua}
    ${builtins.readFile ./lua/keymaps.lua}
    ${builtins.readFile ./lua/options.lua}
  '';

  plugins = with pkgs.vimPlugins; [
    # myPlugin
    plenary-nvim
    nvim-web-devicons
    nui-nvim
    vim-wakatime
    nvim-autopairs

    {
      plugin = lualine-nvim;
      config = toLuaFile ./lua/plugins/lualine.lua;
    }

    # session manager
    # https://github.com/rmagatti/auto-session/
    {
      plugin = auto-session;
      config = toLuaFile ./lua/plugins/auto_session.lua;
    }

    # displays a popup with possible keybindings
    # https://github.com/folke/which-key.nvim/
    which-key-nvim

    # Move lines with Alt+jk
    # https://github.com/matze/vim-move
    vim-move

    # Smooth scrolling for NeoVim
    vim-smoothie

    # Nicer display of chooser dialogs
    # https://github.com/stevearc/dressing.nvim/
    dressing-nvim

    # A fancy, configurable, notification manager for NeoVim
    # https://github.com/rcarriga/nvim-notify/
    nvim-notify

    # 💥 Highly experimental plugin that completely replaces
    # the UI for messages, cmdline and the popupmenu.
    # https://github.com/folke/noice.nvim/
    {
      plugin = noice-nvim;
      config = toLuaFile ./lua/plugins/noice.lua;
    }

    # Seamless navigation between Neovim windows and Zellij panes.
    # https://github.com/swaits/zellij-nav.nvim/commits/main/
    # zellijNav

    # Highlights the word under the cursor
    # https://github.com/RRethy/vim-illuminate/
    vim-illuminate

    # Define your keymaps, commands, and autocommands as simple
    # Lua tables, building a legend at the same time
    sqlite-lua
    {
      plugin = legendary-nvim;
      config = toLuaFile ./lua/plugins/legendary.lua;
    }

    # Debug Adapter Protocol client implementation for Neovim
    # https://github.com/mfussenegger/nvim-dap/
    nvim-dap

    # A UI for nvim-dap
    # https://github.com/rcarriga/nvim-dap-ui/
    {
      plugin = nvim-dap-ui;
      config = toLuaFile ./lua/plugins/dap_ui.lua;
    }
    nvim-dap-python
    nvim-dap-go
    # https://github.com/theHamsta/nvim-dap-virtual-text/
    nvim-dap-virtual-text

    {
      plugin = telescope-nvim;
      config = toLuaFile ./lua/plugins/telescope.lua;
    }

    {
      plugin = nvim-treesitter;
      config = toLuaFile ./lua/plugins/treesitter.lua;
    }

    # Show code context
    # https://github.com/nvim-treesitter/nvim-treesitter-context
    {
      plugin = nvim-treesitter-context;
      config = toLuaFile ./lua/plugins/treesitter_context.lua;
    }

    # pre-install language parsers
    nvim-treesitter-parsers.bash
    nvim-treesitter-parsers.c
    nvim-treesitter-parsers.cpp
    nvim-treesitter-parsers.dart
    nvim-treesitter-parsers.go
    nvim-treesitter-parsers.html
    nvim-treesitter-parsers.lua
    nvim-treesitter-parsers.markdown
    nvim-treesitter-parsers.markdown_inline
    nvim-treesitter-parsers.nix
    nvim-treesitter-parsers.python
    nvim-treesitter-parsers.regex
    nvim-treesitter-parsers.rust
    nvim-treesitter-parsers.vim
    nvim-treesitter-parsers.just
    nvim-treesitter-parsers.typescript

    vim-just

    {
      # Shows git decorations
      plugin = gitsigns-nvim;
      config = toLuaFile ./lua/plugins/gitsigns.lua;
    }

    {
      # https://github.com/numToStr/Comment.nvim
      # Plugin to comment out code
      plugin = comment-nvim;
      config = toLua "require('Comment').setup()";
    }

    {
      # https://github.com/nvim-neo-tree/neo-tree.nvim
      # File browser plugin
      # Toggle with <leader>n
      plugin = neo-tree-nvim;
      config = toLuaFile ./lua/plugins/neotree.lua;
    }

    {
      # https://github.com/folke/tokyonight.nvim/
      # A clean, dark Neovim theme
      plugin = tokyonight-nvim;
      config = toLuaFile ./lua/plugins/tokyonight.lua;
    }

    # Autocompletion
    # Snippet Engine & its associated nvim-cmp source
    luasnip
    cmp_luasnip

    # Adds LSP completion capabilities
    cmp-nvim-lua
    cmp-nvim-lsp
    cmp-path
    cmp-buffer

    # Adds a number of user-friendly snippets
    friendly-snippets

    {
      plugin = gen-nvim;
      config = toLuaFile ./lua/plugins/gen.lua;
    }

    {
      # General framework for context aware hover providers
      # (similar to vim.lsp.buf.hover).
      plugin = hover-nvim;
      config = toLuaFile ./lua/plugins/hover.lua;
    }

    {
      plugin = nvim-cmp;
      config = toLuaFile ./lua/plugins/cmp.lua;
    }

    none-ls-nvim

    {
      plugin = nvim-lspconfig;
      config = toLua ''
        ${builtins.readFile ./lua/lsp/lsp.lua}
        ${builtins.readFile ./lua/lsp/servers/common.lua}
        ${builtins.readFile ./lua/lsp/servers/gopls.lua}
        ${builtins.readFile ./lua/lsp/servers/lua.lua}
        ${builtins.readFile ./lua/lsp/servers/nix.lua}
        ${builtins.readFile ./lua/lsp/servers/nushell.lua}
        ${builtins.readFile ./lua/lsp/servers/python.lua}
        ${builtins.readFile ./lua/lsp/servers/none.lua}
      '';
    }

    {
      plugin = lsp-format-nvim;
      config = toLuaFile ./lua/plugins/lsp_format.lua;
    }

    {
      # Helper package for developing neovim plugins and configs
      # https://github.com/folke/neodev.nvim/
      plugin = neodev-nvim;
      config = toLua ''
        require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
        })
      '';
    }

    {
      # https://github.com/ray-x/go.nvim
      plugin = go-nvim;
      config = toLuaFile ./lua/plugins/go_nvim.lua;
    }

    {
      # https://github.com/akinsho/flutter-tools.nvim
      # Setup Flutter tools
      plugin = flutter-tools-nvim;
      config = toLuaFile ./lua/plugins/flutter_tools.lua;
    }

    rust-vim
    {
      # https://github.com/mrcjkb/rustaceanvim
      plugin = rustaceanvim;
      config = toLuaFile ./lua/plugins/rustaceanvim.lua;
    }

    {
      plugin = typescript-tools-nvim;
      config = toLuaFile ./lua/plugins/typescript-tools.lua;
    }

    FixCursorHold-nvim
    nvim-nio
    {
      # https://github.com/nvim-neotest/neotest/
      plugin = neotest;
      config = toLuaFile ./lua/plugins/neotest.lua;
    }
  ];
}
