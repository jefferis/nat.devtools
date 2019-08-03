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
#' @inheritParams use_doc_badge
#'
#' @return Paths to any bad files
#' @export
nv_check_urls <-
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
        sel_res=res[any_res,,drop=FALSE]
        matches[[f]] = cbind(sel_lines, tibble::as_tibble(sel_res))
      } else next()
      if(replace){
        txtt = sapply(oldpaths, function(x)
          stringr::str_replace_all(txt, pattern = replacement_vec))
        writeLines(txtt, con = f)
      }
    }
    dplyr::bind_rows(matches, .id='file')
  }
