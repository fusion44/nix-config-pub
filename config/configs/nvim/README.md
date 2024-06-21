# Nix NeoVim

https://github.com/vimjoyer/nvim-nix-video/tree/main
https://www.youtube.com/watch?v=YZAnJ0rwREA

# Things that need fixing

### Leader key on plugins load

Right now extraLuaConfig is loaded AFTER the plugins are loaded.
This is a problem because the leader key must be set before the
plugins are setup. Otherwise the wrong leader key will be used.
As a workaround, put the leader key assignment on the top of
every plugin setup file the leader key is referenced:

```lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
```

### Lua ls not setup correctly

- lua-ls sees vim as undefined
  - This is likely due to how home manager defines the config. Neodev doesn't find the proper lua files (init.lua, ...) and thus won't initialize the lua ls correctly.
