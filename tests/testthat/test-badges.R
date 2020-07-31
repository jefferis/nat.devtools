context('badges')

test_that("has_badge_comments works", {
  expect_true(has_badge_comments('testdata/readme-with-badges.md'))
  expect_false(has_badge_comments('testdata/readme-no-badges.md'))
  expect_false(has_badge_comments('testdata/readme-no-badge-comments.md'))
  expect_false(has_badge_comments('testdata/readme-malformed-badge-comments.md'))
})

test_that("add_badge_comments works", {
  tf=tempfile('testpkg')
  on.exit(unlink(tf, recursive = TRUE))
  expect_output(usethis::create_package(path = tf, rstudio = F, open = F))
  file.copy('testdata/readme-no-badge-comments.md', file.path(tf, 'README.md'))
  file.copy('testdata/readme-with-badges.md', file.path(tf, 'baseline.md'))
  owd=setwd(tf)
  on.exit(setwd(owd), add = TRUE, after=FALSE)

  usethis::with_project(tf, {
    expect_message(add_badge_comments(), regexp = "marker comments added to")
    expect_equal(readLines('README.md'), readLines('baseline.md'))

    file.copy(file.path(owd,'testdata/readme-extraneous-badge-line.md'),
              file.path(tf, 'README.md'), overwrite = TRUE)
    expect_warning(add_badge_comments())
  })
})
