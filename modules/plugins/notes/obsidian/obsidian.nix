{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum nullOr;
  inherit (lib.modules) mkRenamedOptionModule mkRemovedOptionModule;
  inherit (lib.nvim.types) mkPluginSetupOption;
in {
  imports = let
    setupPath = ["vim" "notes" "obsidian" "setupOpts"];

    renamedSetupOption = oldPath: newPath:
      mkRenamedOptionModule
      (["vim" "notes" "obsidian"] ++ oldPath)
      (setupPath ++ newPath);

    removedSingleDirInstructions = ''
      `obsidian.nvim` has migrated to the `setupOpts.workspaces` option to support multiple vaults.

      To continue using a single vault, set:

      ```nix
      {
        obsidian.setupOpts.workspaces = [
          {
            name = "any-string";
            path = "~/old/dir/path/value";
          }
        ];
      }
      ```
    '';
  in [
    (mkRemovedOptionModule ["vim" "notes" "obsidian" "dir"] removedSingleDirInstructions)
    (mkRemovedOptionModule (setupPath ++ ["dir"]) removedSingleDirInstructions)
    (mkRemovedOptionModule (setupPath ++ ["mappings"]) ''
      Some individual mappings have separate options.
      Use exposed `Obsidian` commands and the standard keymaps API for others.
    '')
    # TODO: are these useful?
    # (mkRemovedOptionModule (setupPath ++ ["open_app_foreground"]) "Removed upstream.")

    (renamedSetupOption ["daily-notes" "folder"] ["daily_notes" "folder"])
    (renamedSetupOption ["daily-notes" "date-format"] ["daily_notes" "date_format"])
    (renamedSetupOption ["completion"] ["completion"])

    # Some nested options may be renamed/removed as well.
    (mkRenamedOptionModule (setupPath ++ ["note_frontmatter_func"]) (setupPath ++ ["frontmatter" "func"]))
    (mkRenamedOptionModule (setupPath ++ ["image_name_func"]) (setupPath ++ ["attachments" "image_name_func"]))
    (mkRenamedOptionModule (setupPath ++ ["user_advanced_uri"]) (setupPath ++ ["open" "user_advanced_uri"]))
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
        :: This plugin will automatically use [blink-cmp] (preferred) or [nvim-cmp] for completion.
      '';

      # TODO: test the suggested global options

      # TODO: note as breaking change, options renamed, link the source

      # TODO: check option rendering
      # do I need to link plugins?
      # does :: [!note] work?

      # TODO: make sure this actually builds, options work etc.

      setupOpts = mkPluginSetupOption "obsidian.nvim" {
        # TODO: docs say it'll disable itself automatically, check if this is true
        ui.enable = let
          markdownExtensions = config.vim.languages.markdown.extensions;
        in
          mkEnableOption "[obsidian.nvim] UI rendering"
          // {
            default = !(markdownExtensions.render-markdown-nvim.enable || markdownExtensions.markview-nvim.enable);
            defaultText = "false if render-markdown-nvim or markview-nvim are enabled, otherwise true";
          };

        # The plugin doesn't choose or detect these, but it's a good default to use an enabled plugin.
        picker.name = mkOption {
          type = nullOr (enum ["snacks" "mini" "telescope" "fzf_lua"]);
          default =
            if config.vim.utility.snacks-nvim.setupOpts.picker.enable or false
            then "snacks"
            else if config.vim.mini.pick.enable
            then "mini"
            else if config.vim.telescope.enable
            then "telescope"
            else if config.vim.fzf-lua.enable
            then "fzf_lua"
            else null;
          defaultText = ''
            One of "snacks", "mini", "telescope", "fzf_lua", or null based on whether they are enabled and in that order.
          '';
        };
      };
    };
  };
}
