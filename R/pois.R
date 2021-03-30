#' @export
confint_pois <- function(
	n, b = 0, cl = 0.95, acc = 1e-3 * (max(n - b, 0) + 1),
	lambda_min = NULL, lambda_max = NULL
	)
{
	check_args_pois(n, b, cl, acc, lambda_min, lambda_max)

	grid <- pois_lambda_grid(n, b, cl, acc)

	if (length(b) == 3)
		res <- pois_confint_cpp_adjusted(
			n, b[[1]], cl,
			grid[["min"]], grid[["max"]], grid[["step"]],
			b[[2]], b[[3]]
			)
	else
		res <- pois_confint_cpp(
			n, b, cl, grid[["min"]], grid[["max"]], grid[["step"]]
			)

	check_truncation_pois(res, grid)

	return(res)
}


#-------------------------------- Helpers -------------------------------------#
check_args_pois <- function(n, b, cl, acc, lambda_min, lambda_max)
{

}

pois_lambda_grid <- function(n, b, cl, acc, lambda_min, lambda_max)
{
	if (is.null(lambda_min) || is.null(lambda_max)) {
		z <- -qnorm((1 - cl) / 2)
		hw <- 2 * z * sqrt(n + 10)
	}

	if (is.null(lambda_min))
		lambda_min <- max(0, n - b - hw)

	if (!is.null(lambda_max))
		lambda_max <- max(n - b, 0) + hw

	lambda_step <- min(acc, lambda_max - lambda_min) / 2

	return( list(min = lambda_min, max = lambda_max, step = lambda_step) )
}

check_truncation_pois <- function(res, grid) {
	if (res[[1]] == grid[["min"]] & res[[1]] > 0) {
		h <- "Lower endpoint truncation"
		x <- "Lower limit might be overestimated due to grid size."
		i <- paste0("Try reducing 'lambda_min' or improving 'acc',",
			    "until this warning stops to appear.")
		rlang::warn(c(h, x = x, i = i), class = "ci_estimation_warning")
	}

	if (res[[2]] == grid[["max"]]) {
		h <- "Upper endpoint truncation"
		x <- "Upper limit might be underestimated due to grid size."
		i <- paste0("Try increasing 'lambda_max' or improving 'acc',",
			    "until this warning stops to appear.")
		rlang::warn(c(h, x = x, i = i), class = "ci_estimation_warnng")
	}
}
