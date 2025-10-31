# Release 0.9 {#sec-release-0-9}

## Breaking changes

- [obsidian.nvim] now uses a maintained fork which has removed the `dir`
  setting. Use `workspaces` instead:

  ```nix
  {
    workspaces = [
      {
        name = "any-string";
        path = "~/old/dir/path/value";
      }
    ];
  }
  ```

  Some other settings and commands are now deprecated but are still supported.

- [obsidian.nvim] has removed the `setupOpts.mappings` options. Use the built-in
  Neovim settings (nvf's {option}`vim.keymaps`)

## Changelog {#sec-release-0-9-changelog}

[Ring-A-Ding-Ding-Baby](https://github.com/Ring-A-Ding-Ding-Baby):

- Aligned `codelldb` adapter setup with [rustaceanvim]’s built-in logic.
- Added `languages.rust.dap.backend` option to choose between `codelldb` and
  `lldb-dap` adapters.

[alfarel](https://github.com/alfarelcynthesis):

[obsidian.nvim]: https://github.com/obsidian-nvim/obsidian.nvim
[blink.cmp]: https://cmp.saghen.dev/
[snacks.nvim]: https://github.com/folke/snacks.nvim
[mini.nvim]: https://nvim-mini.org/mini.nvim/
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[fzf-lua]: https://github.com/ibhagwan/fzf-lua
[render-markdown.nvim]: https://github.com/MeanderingProgrammer/render-markdown.nvim
[markview.nvim]: https://github.com/OXY2DEV/markview.nvim
[which-key.nvim]: https://github.com/folke/which-key.nvim

- Upgrade [obsidian.nvim] to use a maintained fork, instead of the unmaintained
  upstream.
  - Various upstream improvements:
    - Support [blink.cmp] and completion plugin autodetection.
    - Support various pickers for prompts, including [snacks.nvim]'s
      `snacks.picker`, [mini.nvim]'s `mini.pick`, [telescope.nvim], and
      [fzf-lua].
    - Merge commands like `ObsidianBacklinks` into `Obisidian backlinks`. The
      old format is still supported by default.
    - Some `setupOpts` options have changed:
      - `disable_frontmatter` -> `frontmatter.enabled` (and inverted), still
        supported.
      - `note_frontmatter_func` -> `frontmatter.func`, still supported.
      - `statusline` module is now deprecated in favour of `footer`, still
        supported.
      - `dir` is no longer supported, use `workspaces`:

        ```nix
        {
          workspaces = [
            {
              name = "any-string";
              path = "~/old/dir/path/value";
            }
          ];
        }
        ```

      - `use_advanced_uri` -> `open.use_advanced_uri`.
      - Mappings are now expected to be set using the built-in Neovim APIs,
        managed by `vim.keymaps` in nvf, instead of `mappings` options.
      - Some option defaults have changed.
    - And more.
  - Automatically configure an enabled picker in the order mentioned above, if
    any are enabled.
  - Add integration with `snacks.image` for rendering workspace/vault assets.
  - Detect if [render-markdown.nvim] or [markview.nvim] are enabled and disable
    the `ui` module if so. It should work without this, but `render-markdown`'s
    {command}`:healthcheck` doesn't know that.
  - Remove [which-key.nvim] `<leader>o` `+Notes` description which did not
    actually correspond to any keybinds.
