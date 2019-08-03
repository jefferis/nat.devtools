#' Add natverse badges to package README
#'
#' @description \code{use_doc_badge} adds a badge linking to the pkgdown site for the package
#'
#' @param path Path to git repository containing package (defaults to current
#'   working directory)
#'
#' @export
#' @rdname natverse-badges
use_doc_badge <- function(path=".") {
  pkg=devtools::as.package(path)
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


#' @description \code{use_natverse_badge} adds a badge to say that package is a member of the natverse
#'
#' @export
#' @rdname natverse-badges
use_natverse_badge <- function(path=".") {
  usethis::use_badge(badge_name = "natverse",
                     href = 'https://natverse.github.io',
                     src = "https://img.shields.io/badge/natverse-Part%20of%20the%20natverse-a241b6")
}

