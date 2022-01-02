
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fcci

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check](https://github.com/vgherard/fcci/workflows/R-CMD-check/badge.svg)](https://github.com/vgherard/fcci/actions)
[![Codecov test
coverage](https://codecov.io/gh/vgherard/fcci/branch/master/graph/badge.svg)](https://app.codecov.io/gh/vgherard/fcci?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/fcci)](https://CRAN.R-project.org/package=fcci)
[![R-universe
status](https://vgherard.r-universe.dev/badges/fcci)](https://vgherard.r-universe.dev/)
[![Website](https://img.shields.io/badge/Website-here-blue)](https://vgherard.github.io/fcci/)
[![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=%7Bfcci%7D:%20Feldman-Cousins%20Confidence%20Intervals%20in%20R&url=https://vgherard.github.io/r2r&via=ValerioGherardi&hashtags=rstats,statistics,physics,confidenceintervals)
<!-- badges: end -->

`fcci` is an R package providing support for building
[Feldman-Cousins](https://doi.org/10.1103/PhysRevD.57.3873) confidence
intervals.

## Motivation

The Feldman-Cousins construction was originally developed in the context
of High-Energy Physics, as a consistent method for building classical
(frequentist) confidence intervals for Poisson rates of rare events. In
experiments which expect only few events, it is often the case that the
number of observed events is actually zero or, more generally, lower
than the expected number of spurious background events (if the latter is
significantly larger than zero).

In these situations, classical central intervals (such as those produced
by `stats::poisson.test()`) are not satisfying, as they can lead both to
significant overcoverage and to non-physical negative rates in the
presence of a non-negligible background. Moreover, a naive special
treatment of boundary values, which chooses to report an upper limit or
a confidence interval depending on the data (the so-called
[“flip-flopping” policy](https://doi.org/10.1103/PhysRevD.57.3873)), can
lead to undercoverage.

Feldman and Cousins provide a unified treatment of boundary and regular
values, by explicitly constructing the [Neyman confidence
belt](https://en.wikipedia.org/wiki/Neyman_construction) for physical
rates, using an ordering for count values based on a likelihood ratio.

## Installation

You can install the latest release of `fcci` from
[CRAN](https://CRAN.R-project.org/package=fcci) using:

``` r
install.packages("fcci")
```

and the development version from [my
R-universe](https://vgherard.r-universe.dev/) with:

``` r
install.packages("fcci", repos = "https://vgherard.r-universe.dev/")
```

## Example

``` r
library(fcci)
```

To compute a confidence interval for, e.g., a Poisson rate, use:

``` r
# 95% C.L. interval for n = 10 events and b = 2 expected background events
confint_pois(n = 10, b = 2, cl = 0.95)
#> [1]  2.9205 15.8130
#> attr(,"cl")
#> [1] 0.95
```

Let us compare the 68% C.L. intervals for *n* = 0 events and no
background obtained from `fcci` and from `stats::poisson.test()`

``` r
confint_pois(n = 0, cl = 0.68)
#> [1] 0.000 1.275
#> attr(,"cl")
#> [1] 0.68
stats::poisson.test(0, conf.level = 0.68, alternative = "two.sided")$conf.int
#> [1] 0.000000 1.832581
#> attr(,"conf.level")
#> [1] 0.68
```

Notice that the latter is significantly larger, and it corresponds in
fact to an 84% C.L. *upper limit* on the rate:

``` r
stats::poisson.test(0, conf.level = 0.84, alternative = "less")$conf.int
#> [1] 0.000000 1.832581
#> attr(,"conf.level")
#> [1] 0.84
```

## Getting Help

For further help, you can consult the reference page of the `fcci`
[website](https://vgherard.github.io/fcci/) or [open an
issue](https://github.com/vgherard/fcci/issues) on the GitHub repository
of `fcci`.
