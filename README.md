# nat.devtools

<!-- badges: start -->
[![natverse](https://img.shields.io/badge/natverse-Part%20of%20the%20natverse-a241b6)](https://natverse.github.io)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://jefferis.github.io/nat.devtools/reference/)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build status](https://travis-ci.org/jefferis/nat.devtools.svg?branch=master)](https://travis-ci.org/jefferis/nat.devtools)
<!-- badges: end -->


The goal of nat.devtools is to enable efficient development of R packages according
to natverse conventions.

## Setup

nat.devtools uses the [usethis](https://usethis.r-lib.org/) package 
to automate a number of development tasks. Please ensure that you have configured
usethis [as recommended](https://usethis.r-lib.org/articles/articles/usethis-setup.html).

You can do this by typing the following in your R session:

```
nat.devtools::use_nat_description_defaults()
```

to edit your `.Rprofile` file. Mine looks like this:

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


## Use 

Once you're all set up, then the easiest way to use the package 
to configure your current project is to do:

```
nat.devtools::nat_setup_package()
```

This configures almost everything about a project and will ask interactive
questions to determine if you want to upgrade / overwrite different files.

If you switch between different projects in the same session,
then you must do:

```
usethis::proj_set()
```

to set the active project to the current directory.
