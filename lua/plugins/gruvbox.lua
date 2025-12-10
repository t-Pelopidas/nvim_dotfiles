return{

    "https://github.com/morhetz/gruvbox/",
    lazy = false,
    name = "gruvbox",
    config = function()
        vim.g.gruvbox_contrast_dark = "hard"
        vim.cmd.colorscheme "gruvbox"
    end
}

