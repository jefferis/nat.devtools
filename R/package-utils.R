resave_all_rds <- function(path='.', version=2, dryrun=FALSE, ...) {
  ff=dir(path=path, recursive = TRUE, pattern='\\.rds$')
  if(length(ff)) {
    for(f in ff) {
      x=readRDS(f)
      message('resaving: ', f)
      if(isFALSE(dryrun))
        saveRDS(x, file = f, version = version, ...)
    }
  }
}


#' Check for files containing old jefferis/lab URLs.
#'
#' @param pattern Files to check (passed to \code{\link{dir}})
#' @param oldusers Which GitHub users need changing to natverse
#' @param replace Whether to replace old URLs with natverse URLs
#' @inheritParams nat_setup_package
#'
#' @return Paths to any bad files
#' @export
nat_check_urls <-
  function(path = ".",
           pattern = c("^(DESCRIPTION|NEWS|.*\\.(R|r|Rmd|md|yml))$"),
           oldusers = c("jefferis", "jefferislab", "flyconnectome"),
           replace=FALSE) {
    pkg = devtools::as.package(path)
    owd <- setwd(path)
    on.exit(setwd(owd))
    pkgname = pkg$package
    newpath <- file.path('natverse', pkgname)
    oldpaths = file.path(oldusers, pkgname)
    oldpaths = c(oldpaths, paste0(oldusers, '.github.io'))

    replacement_vec <- rep(c(newpath, 'natverse.github.io'), rep(length(oldusers), 2))
    names(replacement_vec) <- oldpaths

    ff = dir(path = path,
             recursive = TRUE,
             pattern = pattern)
    matches = list()

    for (f in ff) {
      txt = readLines(f)
      res = sapply(oldpaths, function(x)
        stringr::str_detect(txt, stringr::fixed(x)))
      if (any(res)) {
        message(f)
        any_res=apply(res, 1, any)
        sel_lines=txt[any_res]
        sel_res=tibble::as_tibble(res[any_res,,drop=FALSE])
        matches[[f]] = tibble::add_column(sel_res, sel_lines, before=TRUE)
      } else next()
      if(replace){
        txtt = stringr::str_replace_all(txt, pattern = replacement_vec)
        writeLines(txtt, con = f)
      }
    }
    dplyr::bind_rows(matches, .id='file')
  }


#' Setup a package in natverse style
#'
#' @param lifecycle The developmental stage of the package (see
#'   \url{https://www.tidyverse.org/lifecycle})
#' @param path Path to git repository containing package (defaults to current
#'   working directory)
#'
#' @seealso \code{\link{nat_setup_badges}}, \code{\link{nat_setup_pkgdown}}
#' @export
#' @examples
#' \dontrun{
#' nat.devtools::nat_setup_package(lifecycle='maturing')
#' nat.devtools::nat_setup_package(lifecycle='stable')
#' nat.devtools::nat_setup_package(lifecycle='experimental')
#' }
nat_setup_package <- function(path='.',
                              lifecycle=c('experimental', 'maturing', 'stable')) {
  lifecycle=match.arg(lifecycle)
  owd <- setwd(path)
  on.exit(setwd(owd))
  pkg=get_package()

  # usethis::use_github()

  if(isTRUE(pkg$license=='GPL-3') || is.null(pkg$license))
    usethis::use_gpl3_license()
  usethis::use_tidy_description()
  usethis::use_testthat()

  usethis::git_vaccinate()
  usethis::use_github_links()
  use_nat_support()

  if(!proj_file_exists('README.md') && !proj_file_exists('README.Rmd'))
  usethis::use_readme_md(open = FALSE)
  nat_setup_badges()

  usethis::use_travis()

  usethis::use_package_doc()

  nat_setup_pkgdown()

  if(!proj_file_exists('NEWS.md'))
    usethis::ui_todo("Add {ui_path('NEWS.md')} file with {ui_code('usethis::use_news_md()')}")
}

#' Add a SUPPORT.md file with information about getting help
#'
#' @export
use_nat_support <- function() {
  pkg=get_package()
  usethis::use_directory(".github", ignore = TRUE)
  usethis::use_template(".github/SUPPORT.md",
               data = list(package = pkg$package),
               template="natverse-support.md",
               package = 'nat.devtools')
}
