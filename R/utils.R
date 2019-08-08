insert_text <- function(text, insert, line, f=NULL) {
  nlines <- length(text)
  checkmate::assert_integerish(line, lower = 0, upper=nlines)
  if(line>nlines){
    warning('insertion point beyond end of text!')
    line=nlines
  }
  head <- if(line==0) character() else text[seq_len(line)]
  tail <- if(line==nlines) character()
  else if(line==0) text
  else text[seq.int(from=line+1L, to=nlines)]
  res=c(head, insert, tail)
  if(!is.null(f))
    writeLines(res, f)
  else res
}

# unused for now but keeping just in case
fake_package <- function(path=tempfile()) {
  if(!file.exists(path)) dir.create(path)
  else stopifnot(file.info(path)$isdir)
  owd=setwd(path)
  on.exit(setwd(owd))
  writeLines(con='DESCRIPTION', c(
    'Package: test',
    'Title: test',
    'Version: 0.0.0.9000',
    'Description: test'))
  path
}

proj_file_exists <- function(...) {
  file.exists(usethis::proj_path(...))
}

get_package <- function() {
  path=proj_get()
  devtools::as.package(path)
}

on_cran <- function(pkgname=NULL){
  if(is.null(pkgname))
    pkg=get_package()
  pkgname=pkg$package

  # nb this universal mirror is faster than the canonical url
  # https://cran.r-project.org
  cran_url <- glue('https://cloud.r-project.org/package={pkgname}')
  url_ok(cran_url)
}

url_ok <- function(x) {
  identical(httr::status_code(httr::HEAD(x)), 200L)
}
