# nat.devtools

<!-- badges: start -->
<!-- badges: end -->

The goal of nat.devtools is to enable efficient development of R packages according
to natverse conventions.

## Setup

nat.devtools uses the [usethis](https://usethis.r-lib.org/) package 
to automate a number of development tasks. Please ensure that you have configured
usethis [as recommended](https://usethis.r-lib.org/articles/articles/usethis-setup.html).
In particular, I have the following in my `.Rprofile`:

```
options(
  usethis.full_name = "Gregory Jefferis",
  usethis.protocol  = "ssh",
  usethis.description = list(
    `Authors@R` = 'person("Gregory","Jefferis", email="jefferis@gmail.com", 
      role=c("aut", "cre"), comment = c(ORCID = "0000-0002-0587-9355"))',
    License = "GPL-3",
    Encoding = "UTF-8",
    Language = "en-GB"
  )
)
```
