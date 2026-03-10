return {
  "3rd/image.nvim",
  opts = {
    processor = "magick_cli", -- This tells it to use the system command
    backend = "kitty",        -- Change to "ueberzug" or "sixel" if not using Kitty
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
    },
  },
}
