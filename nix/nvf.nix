{ pkgs, lib, ...}:

{
  vim = {
    theme = {
      enable = true;
      name = "tokyonight";
      style = "storm";
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
  };
}
