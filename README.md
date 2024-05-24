# Jnvim

## Table Of Contents

1. [About](#about)
    1. [Requirements](#requirements)
    2. [Structure](#structure)
    3. [Plugins](#plugins)
2. [User API](#api)
    1. [`types`](#types)
    2. [`cpts`](#opts)
    3. [`check`](#check)
    4. [`maps`](#maps)
    5. [`highlight`](#highlight)

---

## About

This is a [Nvim](https://github.com/neovim/neovim) configuration, configured in a _modular_, **_obsessively documented_**
**portable** and **platform-independant** way. Type checking is supported and documentation is included as far as possible.

This configuration uses [Lazy](https://github.com/folke/lazy.nvim) as plugin manager. Please read the [Plugins](#plugins)
section to get an understanding of how this works.

This configuration has its core entirely dependant on the [`user`](/lua/user) module, which provides a customized
**_API_** which includes **_module checking_**, **_type checking_**, **_highlighting functions_**, **_option settings_**,
**_keymap functions_**, **_annotations_**, etc. For more info make sure to check the [User API](#api) section.

### Requirements

This config relies on essential plugins that improve the readability and understanding of how it works.
For these to work, the following executables must be installed and in your `$PATH`:

* `git`
* [`lua-language-server`](https://github.com/LuaLS/lua-language-server)
* [`vscode-json-languageserver`](https://www.npmjs.com/package/vscode-json-languageserver)
* [`ripgreg`](https://github.com/BurntSushi/ripgrep)
* [`fd`](https://github.com/sharkdp/fd)
* **(Optional)** [`fzf`](https://github.com/junegunn/fzf)

### Structure

```
/lua
├── lazy_cfg/  <== Folder containing all Lua plugin configurations.
│   ├── init.lua  <== Lazy Plugins are installed from here.
│   ├── plugin1/
│   │   ├── init.lua
│   │   └── ...
│   ├── plugin2/
│   │   └── init.lua
│   └── ...
└── user  <== User API module
    ├── check/  <== Checker Functions
    │   └── init.lua
    ├── highlight.lua  <== Highlight Functions
    ├── init.lua  <== API `init`
    ├── maps.lua  <== Mapping Functions
    ├── opts.lua  <== Vim Options
    └── types/  <== Lua Type Annotations and Documentation
        ├── user/  <== User API Documentation
        ├── module_1.lua
        ├── module_2.lua
        └── ...
```
