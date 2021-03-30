#' @export
confint_binom <- function(n, N, cl = 0.95, acc = 1e-3, p_min = 0, p_max = 1)
{
	res <- binom_confint_cpp(n, N, cl, p_min, p_max, acc / 2)

	if (res[[1]] == p_min & res[[2]] == p_max) {
		msg <- paste0("Confidence interval might be truncated",
			      "due to low accuracy.")
		warning(msg)
	}

	return(res)
}
