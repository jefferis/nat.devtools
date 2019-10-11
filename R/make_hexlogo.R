#'Make hexagon logo from any kind of image
#'
#' This code was inspired and adapted from the make hexagon code in https://github.com/greta-dev/greta/blob/master/logos/make_hex.R
#' @param rawimgpath Path to the png file (that contains the actual logo)
#' @param outputimgpath Path to the output png file that is in the form of a hex
#' @param hexbordercolour Colour of the hexagon border
#' @param hexinnercolour Colour to fill inside (usually give the background color of your image)
#' @export
#' @examples
#' \dontrun{
#' nat_makehexlogo(rawimgpath='logos/nat_withouthex.png',outputimgpath ='logos/nat_withhex.png')
#' }
nat_makehexlogo <- function(rawimgpath,outputimgpath, hexbordercolour = 'white',hexinnercolour = 'red') {

  #Step 1: make a hex-shaped mask
  hexd <- data.frame(x = 1 + c(rep(-sqrt(3) / 2, 2), 0, rep(sqrt(3) / 2, 2), 0),
                     y = 1 + c(0.5, -0.5, -1, -0.5, 0.5, 1))

  x_lim <- range(hexd$x)
  y_lim <- range(hexd$y)
  x_dim <- abs(diff(x_lim))
  y_dim <- abs(diff(y_lim))
  ex <- 4

  grDevices::pdf("logos/hex_mask.pdf", width = x_dim * ex, height = y_dim * ex)
  graphics::par(pty = "s", xpd = NA, bg = "black", mar = rep(0, 4), oma = rep(0, 4))
  graphics::plot.new()
  graphics::plot.window(xlim = x_lim, ylim = y_lim)
  graphics::polygon(hexd, col = "white")
  grDevices::dev.off()

  #Step 2: load the hex mask
  mask <- magick::image_read("logos/hex_mask.pdf")
  mask <- magick::image_transparent(mask, "black")
  mask_dim <- as.numeric(magick::image_info(mask)[1, 2:3])
  dim <- mask_dim * 2
  grDevices::png("logos/hex_bg.png",width = dim[1],height = dim[2],pointsize = 30)
  grDevices::dev.off()

  #Step 3: crop and mask the pattern to a hexagon
  bg <- magick::image_read(rawimgpath)

  #Step 4: Now resize the bg according to the mask..
  bg_resize <- magick::image_resize(bg, magick::geometry_size_pixels(width = mask_dim[1], height = mask_dim[2]))

  #Step 5: Apply the mask..
  hex_bg <- magick::image_composite(bg_resize, mask, "CopyOpacity")
  magick::image_write(hex_bg, path = "logos/hex_bg.png")

  graphics::par(pty = "s", xpd = NA, bg = "black", mar = c(5, 4, 4, 2) + 0.1)

  #Step 6: Make a sticker (apply just boundary here)..
  nat_hex <- hexSticker::sticker("logos/hex_bg.png",
                     s_x = 1,
                     s_y = 1,
                     s_width = 1.05,
                     package = "",
                     p_y = 1.1,
                     p_size = 15,
                     h_fill = hexinnercolour,
                     h_color = hexbordercolour,
                     filename = outputimgpath)

  #Step 7: Save the sticker in an uniform way and clear all intermediate files..
  ggplot2::ggsave(nat_hex, width = 43.9, height = 50.8,
         filename = outputimgpath,
         device = "png",
         bg = "transparent",
         units = "mm",
         dpi = 600)

  file.remove("logos/hex_bg.png")
  file.remove("logos/hex_mask.pdf")

}
















