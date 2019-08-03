#' Set default authorship/package DESCRIPTION information in your Rprofile
#'
#' @export
#' @seealso See \code{usethis::\link[usethis]{use_description_defaults}} and
#'   \code{\link{Rprofile}}
#' @importFrom usethis ui_code_block ui_todo ui_value ui_field edit_r_profile
use_nat_description_defaults <- function () {
  ui_todo(c("Include an edited version of this code in {ui_value('.Rprofile')} to set {ui_value('DESCRIPTION')}",
          "defaults for package creation."))
  ui_code_block(copy = TRUE, c(
  'options(',
  '  usethis.full_name = "First Last",',
  '  usethis.protocol  = "ssh",',
  '  usethis.description = list(',
  '    `Authors@R` = \'person("First","Last", email="xxx@gmail.com",',
  '                        role=c("aut", "cre"), comment = c(ORCID = "XXXX-XXXX-XXXX-XXXX"))\',',
  '  License = "GPL-3",',
  '  Encoding = "UTF-8",',
  '  Language = "en-GB"',
  '  )',
  ')'
  ))
  edit_r_profile("user")
}
