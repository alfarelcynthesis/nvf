{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum nullOr;
  inherit (lib.modules) mkRenamedOptionModule mkRemovedOptionModule;
  inherit (lib.nvim.types) mkPluginSetupOption;
in {
  imports = let
    renamedSetupOption = oldPath: newPath:
      mkRenamedOptionModule
      (["vim" "notes" "obsidian"] ++ oldPath)
      (["vim" "notes" "obsidian" "setupOpts"] ++ newPath);
  in [
    (
      mkRemovedOptionModule ["vim" "notes" "obsidian" "dir"]
      ''
        `obsidian.nvim` has migrated to the `setupOpts.workspaces` option to support multiple vaults with a single interface.

        To continue using a single vault, set:

        ```nix
        {
          notes.obsidian.setupOpts.workspaces = [
            {
              name = "any-string";
              path = "~/old/dir/path/value";
            }
          ];
        }
        ```
      ''
    )
    (renamedSetupOption ["daily-notes" "folder"] ["daily_notes" "folder"])
    (renamedSetupOption ["daily-notes" "date-format"] ["daily_notes" "date_format"])
    (renamedSetupOption ["completion"] ["completion"])
  ];
  options.vim.notes = {
    obsidian = {
      enable = mkEnableOption ''
        plugins to compliment the Obsidian markdown editor [obsidian.nvim].

        :: [!tip] Folding
        :: This plugin depends on [vim-markdown] which by default folds headings,
        :: including outside of workspaces/vaults.
        ::
        :: Set `vim.g['vim_markdown_folding_disable'] = 1` to disable automatic folding,
        :: or `vim.g['vim_markdown_folding_level'] = <number>` to set the default folding level.

        :: [!note] Completion
        :: This plugin will automatically use [blink-cmp] (preferred) or [nvim-cmp] for completion
      '';

      # TODO: test the suggested global options

      # TODO: check option rendering
      # do I need to link plugins?
      # does :: [!note] work?

      # TODO: make sure this actually builds, options work etc.

      setupOpts = mkPluginSetupOption "obsidian.nvim" {
        # # TODO: docs say it'll disable itself automatically, check if this is true
        # ui.enable = let
        #   markdownExtensions = config.vim.languages.markdown.extensions;
        # in
        #   mkEnableOption "[obsidian.nvim] UI rendering"
        #   // {
        #     default = !(markdownExtensions.render-markdown-nvim.enable || markdownExtensions.markview-nvim.enable);
        #     defaultText = "false if render-markdown-nvim or markview-nvim are enabled, otherwise true";
        #   };

        # The plugin doesn't choose or detect this.
        picker.name = mkOption {
          # From https://github.com/obsidian-nvim/obsidian.nvim/blob/main/lua/obsidian/config/init.lua
          type = nullOr (enum ["snacks.pick" "mini.pick" "telescope.nvim" "fzf-lua"]);
          default = null;
          defaultText = ''
            One of "snacks", "mini", "telescope", "fzf_lua", or null based on whether they are enabled and in that order.
          '';
        };
      };
    };
  };
}
