#' Add natverse badges to package README
#'
#' @description \code{use_doc_badge} adds a badge linking to the pkgdown site
#'   for the current package
#'
#' @export
#' @name natverse-badges
#' @aliases use_doc_badge
use_doc_badge <- function() {
  pkg <- get_package()
  issues <- pkg$bugreports
  if(is.null(issues))
    stop("Please set the Bug Reports with usethis::use_github_links()")

  repopath <- httr::parse_url(dirname(pkg$bugreports))$path
  repo=basename(repopath)
  user=dirname(repopath)

  url <- sprintf('https://%s.github.io/%s/reference/',user, repo)
  usethis::use_badge(badge_name = "Docs",
                     href = url,
                     src = "https://img.shields.io/badge/docs-100%25-brightgreen.svg")
}


#' @description \code{use_cran_downloads_badge} adds a badge to give the number
#'   of downloads / month from CRAN.
#'
#' @export
#' @rdname natverse-badges
#' @importFrom glue glue
use_cran_downloads_badge <- function() {
  pkg=get_package()
  package=pkg$package
  usethis::use_badge(badge_name = "Downloads",
                     href = glue('http://www.r-pkg.org/pkg/{package}'),
                     src = glue("http://cranlogs.r-pkg.org/badges/{package}?color=brightgreen"))
}


#' @description \code{use_natverse_badge} adds a badge to say that package is a member of the natverse
#'
#' @export
#' @rdname natverse-badges
use_natverse_badge <- function() {
  usethis::use_badge(badge_name = "natverse",
                     href = 'https://natverse.github.io',
                     src = "https://img.shields.io/badge/natverse-Part%20of%20the%20natverse-a241b6")
}


#' @description \code{nat_standard_badges} Adds all standard badges to your README.md
#' @inheritParams add_badge_comments
#' @inheritParams nat_setup_package
#' @export
#' @rdname natverse-badges
nat_standard_badges <- function(x='README.md', lifecycle=NULL) {
  # f=remove_badges(x)

  add_badge_comments()
  use_natverse_badge()
  use_doc_badge()
  if(on_cran()){
    usethis::use_cran_badge()
    use_cran_downloads_badge()
  }
  if(!is.null(lifecycle))
    usethis::use_lifecycle_badge(lifecycle)

}



has_badge_comments <- function(f) {
  txt = readLines(f)
  badge_comments=c("<!-- badges: start -->","<!-- badges: end -->")
  res = sapply(badge_comments, function(x)
    stringr::str_detect(txt, stringr::fixed(x)))
  if(length(res)==2) res=matrix(res, ncol=2)
  # exactly one instance of each
  found_both <- identical(unname(colSums(res)), c(1, 1))
  found_both
}

badge_lines <- function(f) {
  txt = readLines(f)
  # they should start [![ finish ) and contain badge and/or svg somewhere
  patts=c("badge", ".svg")
  res1=sapply(patts, function(p) stringr::str_detect(txt, stringr::fixed(p)))
  # trim whitespace from start/end of line
  txt=trimws(txt)
  res2=substr(txt,1,3)=="[!["
  res3=substr(txt,nchar(txt),nchar(txt))==")"

  positives=apply(res1,1,sum)>0 & res2 & res3
  which(positives)
}

remove_badges <- function(x='README.md') {
  ow=options(warn=2)
  on.exit(options(ow))

  f <- add_badge_comments(x)
  bl=badge_lines(f)
  if(length(bl)) {
    txt = readLines(f)
    txt=txt[-bl]
    writeLines(txt, f)
  }
  invisible(f)
}


#' Add special marker comments delimiting the badge section of package README
#'
#' @details Badge comment lines are required for
#'   \code{usethis::\link{use_badge}} and friends to automagically add badges to
#'   a README.
#'
#'   \code{add_badge_comments} will only add badge comments if they are not yet
#'   present. If there are some badges present then will add marker comments on
#'   either side. Will give a warning and do nothing if badge lines are not
#'   contiguous
#'
#' @param x Name of README file
#' @param f Absolute path to file (can be used instead of \code{x} for
#'   debugging)
#'
#' @return Path to modified readme file (invisibly)
#'
#' @export
#' @seealso \code{\link{natverse-badges}}, \code{usethis::\link{use_badge}}
add_badge_comments <- function(x='README.md', f=NULL) {
  if(is.null(f))
    f <- usethis::proj_path(x)
  txt = readLines(f)
  if(has_badge_comments(f))
    return(invisible(NULL))

  badge_comments=c("<!-- badges: start -->","<!-- badges: end -->")

  bl=badge_lines(f)
  if(length(bl)) {
    if(length(bl)>1 && any(diff(bl)!=1)){
      usethis::ui_warn(paste0("Badge marker comments could not be added to ",
                               "{ui_field(x)}: non-contiguous badge lines"))
      return(invisible(NULL))
    }

    # we already have some badges, so we need to insert either side of them
    txt=insert_text(txt, badge_comments[1], min(bl)-1L)
    # nb +1 as we've inserted a line
    txt=insert_text(txt, badge_comments[2], max(bl)+1L, f=f)
  } else {
    # don't seem to be any badges, let's go for line 2
    txt=insert_text(length(txt), badge_comments, 2, f=f)
  }

  usethis::ui_done("Badge marker comments added to {ui_field(x)}")
  invisible(f)
}
