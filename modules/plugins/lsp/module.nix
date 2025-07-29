{config, lib, ...}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.nvim.binds) mkMappingOption;
in {
  options.vim.lsp = {
    formatOnSave = mkEnableOption "format on save";

    inlayHints = {
      enable = mkEnableOption "inlay hints";
    };

    mappings = {
      goToDefinition =
        mkMappingOption config.vim.enableNvfKeymaps "Go to definition"
        "<leader>lgd";
      goToDeclaration =
        mkMappingOption config.vim.enableNvfKeymaps "Go to declaration"
        "<leader>lgD";
      goToType =
        mkMappingOption config.vim.enableNvfKeymaps "Go to type"
        "<leader>lgt";
      listImplementations =
        mkMappingOption config.vim.enableNvfKeymaps "List implementations"
        "<leader>lgi";
      listReferences =
        mkMappingOption config.vim.enableNvfKeymaps "List references"
        "<leader>lgr";
      nextDiagnostic =
        mkMappingOption config.vim.enableNvfKeymaps "Go to next diagnostic"
        "<leader>lgn";
      previousDiagnostic =
        mkMappingOption config.vim.enableNvfKeymaps "Go to previous diagnostic"
        "<leader>lgp";
      openDiagnosticFloat =
        mkMappingOption config.vim.enableNvfKeymaps "Open diagnostic float"
        "<leader>le";
      documentHighlight =
        mkMappingOption config.vim.enableNvfKeymaps "Document highlight"
        "<leader>lH";
      listDocumentSymbols =
        mkMappingOption config.vim.enableNvfKeymaps "List document symbols"
        "<leader>lS";
      addWorkspaceFolder =
        mkMappingOption config.vim.enableNvfKeymaps "Add workspace folder"
        "<leader>lwa";
      removeWorkspaceFolder =
        mkMappingOption config.vim.enableNvfKeymaps "Remove workspace folder"
        "<leader>lwr";
      listWorkspaceFolders =
        mkMappingOption config.vim.enableNvfKeymaps "List workspace folders"
        "<leader>lwl";
      listWorkspaceSymbols =
        mkMappingOption config.vim.enableNvfKeymaps "List workspace symbols"
        "<leader>lws";
      hover =
        mkMappingOption config.vim.enableNvfKeymaps "Trigger hover"
        "<leader>lh";
      signatureHelp =
        mkMappingOption config.vim.enableNvfKeymaps "Signature help"
        "<leader>ls";
      renameSymbol =
        mkMappingOption config.vim.enableNvfKeymaps "Rename symbol"
        "<leader>ln";
      codeAction =
        mkMappingOption config.vim.enableNvfKeymaps "Code action"
        "<leader>la";
      format =
        mkMappingOption config.vim.enableNvfKeymaps "Format"
        "<leader>lf";
      toggleFormatOnSave =
        mkMappingOption config.vim.enableNvfKeymaps "Toggle format on save"
        "<leader>ltf";
    };
  };
}
