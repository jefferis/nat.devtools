#' @importFrom usethis use_description_defaults ui_todo ui_code
.onAttach <- function(libname, pkgname) {

  udd <- use_description_defaults()
  desc <- udd[["usethis.description"]]
  authors <- desc[["Authors@R"]]
  if(is.null(authors) && interactive())
    packageStartupMessage(
      ui_todo("Please set default package description information  with {ui_code('use_nat_description_defaults()')}")
    )
  invisible()
}
