{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.binds) pushDownDefault;
  inherit (lib.nvim.lua) toLuaObject;

  cfg = config.vim.notes.obsidian;
in {
  config = mkIf cfg.enable {
    vim = {
      startPlugins = [
        "obsidian-nvim"
        "vim-markdown"
        "tabular"
      ];

      binds.whichKey.register = pushDownDefault {
        "<leader>o" = "+Notes";
      };

      pluginRC.obsidian = entryAnywhere ''
        require("obsidian").setup(${toLuaObject cfg.setupOpts})
      '';

      # Resolve markdown image paths in the vault.
      utility.snacks-nvim.setupOpts = mkIf (config.vim.utility.snacks-nvim.setupOpts.image.enabled or false) {
        image.resolve = mkLuaInline ''
          function(path, src)
            if require("obsidian.api").path_is_note(path) then
              return require("obsidian.api").resolve_image_path(src)
            end
          end
        '';
      };
    };
  };
}
