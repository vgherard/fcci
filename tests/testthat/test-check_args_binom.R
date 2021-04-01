# Set of good arguments
good_args <- list(
	n = 5,
	N = 10,
	cl = 0.95,
	acc = 0.1
	)

# Expectation generator; see usage below
expect_domain_errors <- function(good_args, ..., throw = TRUE)
{
	if (throw)
		regexp <- NULL
	else
		regexp <- NA

	dots <- list(...)
	for (i in seq_along(dots)) {
		var_name <- names(dots)[[i]]
		for (value in dots[[i]]) {
			good_args[[var_name]] <- value
			expect_error(
				do.call(check_args_binom, good_args),
				class = "domain_error",
				regexp = regexp
				)
		}
	}
}

test_that("No error with good arguments", {
	expect_error(object = do.call(check_args_binom, good_args), NA)
})

test_that("Errors on various wrong arguments", {
	expect_domain_errors(
		good_args,
		n = list(length = 1:2, negative = -1, na = NA, too_large = 11),
		N = list(length = 1:2, negative = -1, na = NA),
		cl = list(
			length = c(0.68, 0.95),
			negative = -0.68,
			larger_than_one = 1.32,
			exactly_zero = 0,
			exactly_one = 1,
			na = NA
			),
		acc = list(
			length = c(0.01, 0.001),
			negative = -0.1,
			zero = 0,
			na = NA
			)
		)
})
