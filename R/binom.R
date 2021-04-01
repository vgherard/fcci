#' Binomial proportion confidence intervals
#' @md
#' @description
#' Build confidence intervals for binomial proportions using the Feldman-Cousins
#' construction (Feldman and Cousins, 1998).
#' @param n number of successes. Numeric vector of length one.
#' @param N number of trials. Numeric vector of length one.
#' @param cl confidence level for the returned confidence interval.
#' A number between zero and one.
#' @param acc required accuracy in the confidence interval endpoints.
#' A positive number.
#' @return a numeric vector of length two, containing the confidence interval
#' endpoints.
#' @details
#' More details on the Feldman-Cousins construction can be found in the
#' documentation page of \link[fcci]{confint_pois}.
#' @seealso \link[fcci]{confint_pois}
#' @references
#' Feldman, Gary J. and Cousins, Robert D.
#' "Unified approach to the classical statistical analysis of small signals"
#' *Phys. Rev. D* **57**, issue 7 (1998): 3873-3889.
#' @examples
#' confint_binom(50, 100, cl = 0.95, acc = 1e-3)
#' @export
confint_binom <- function(n, N, cl = 0.95, acc = 1e-3)
{
	check_args_binom(n, N, cl, acc)

	res <- confint_binom_cpp(n = n, N = N, cl = cl,
				 p_min = 0, p_max = 1, p_step = acc / 2)

	attr(res, "cl") <- cl

	return(res)
}

#----------------------------------- Helpers ----------------------------------#


check_args_binom <- function(n, N, cl, acc)
{
	tryCatch(
		# try
		assertthat::assert_that(
			is_event_count(n),
			is_event_count(N), N > 0,
			n <= N,
			is_probability(cl), cl > 0, cl < 1,
			is_positive(acc)
			)
		,
		# catch
		error = function(cnd)
			rlang::abort(cnd$message, class = "domain_error")
		)
}

