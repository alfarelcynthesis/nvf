{
  pkgs,
  config,
  lib,
  ...
}:
with builtins; let
  inherit (lib) mkOption mkEnableOption types;

  cfg = config.vim.languages.bash;

  defaultServer = "bash-ls";
  servers = {
    bash-ls = {
      package = pkgs.nodePackages.bash-language-server;
      lspConfig = ''
        lspconfig.bashls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = ${
          if isList cfg.lsp.package
          then nvim.lua.expToLua cfg.lsp.package
          else ''{"${cfg.lsp.package}/bin/bash-language-server",  "start"}''
        };
        }
      '';
    };
  };

  defaultFormat = "shfmt";
  formats = {
    shfmt = {
      package = pkgs.shfmt;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.shfmt.with({
            command = "${pkgs.shfmt}/bin/shfmt",
          })
        )
      '';
    };
  };

  defaultDiagnostics = ["shellcheck"];
  diagnostics = {
    shellcheck = {
      package = pkgs.shellcheck;
      nullConfig = pkg: ''
        table.insert(
          ls_sources,
          null_ls.builtins.diagnostics.shellcheck.with({
            command = "${pkg}/bin/shellcheck",
          })
        )
      '';
    };
  };
in {
  options.vim.languages.bash = {
    enable = mkEnableOption "Bash language support";

    treesitter = {
      enable = mkOption {
        description = "Bash treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = lib.nvim.types.mkGrammarOption pkgs "bash";
    };

    lsp = {
      enable = mkEnableOption "Enable Bash LSP support" // {default = config.vim.languages.enableLSP;};

      server = mkOption {
        description = "Bash LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };

      package = mkOption {
        description = "bash-language-server package, or the command to run as a list of strings";
        example = lib.literalExpression ''[lib.getExe pkgs.nodePackages.bash-language-server "start"]'';
        type = with types; either package (listOf str);
        default = pkgs.nodePackages.bash-language-server;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Bash formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Bash formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };

      package = mkOption {
        description = "Bash formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
      };
    };

    extraDiagnostics = {
      enable = mkOption {
        description = "Enable extra Bash diagnostics";
        type = types.bool;
        default = config.vim.languages.enableExtraDiagnostics;
      };
      types = lib.nvim.types.diagnostics {
        langDesc = "Bash";
        inherit diagnostics;
        inherit defaultDiagnostics;
      };
    };
  };
}
