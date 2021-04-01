# Set of good arguments
good_args <- list(
	n = 10,
	b = 10,
	cl = 0.95,
	acc = 0.1,
	lambda_min = 0,
	lambda_max = 20
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
				do.call(check_args_pois, good_args),
				class = "domain_error",
				regexp = regexp
				)
		}
	}
}

test_that("No error with good arguments", {
	expect_error(object = do.call(check_args_pois, good_args), NA)
})

test_that("Errors on various wrong arguments", {
	expect_domain_errors(
		good_args,
		n = list(length = 1:2, negative = -1, na = NA),
		b = list(length = 1:2, negative = -1, na = NA),
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
			),
		lambda_min = list(
			length = c(0.01, 0.001),
			negative = -0.1,
			too_large = good_args[["lambda_max"]] + 1,
			na = NA
			),
		lambda_max = list(
			length = c(0.01, 0.001),
			negative = -0.1,
			too_small = good_args[["lambda_min"]] - 1,
			na = NA
			)
		)
})

test_that("No error with valid 'b' of length 3", {
	expect_domain_errors(
		good_args,
		b = list(valid = c(1, 2, 0.5)),
		throw = FALSE
		)
})

test_that("Errors with invalid 'b' of length 3", {
	expect_domain_errors(
		good_args,
		b = list(
			b_max_small = c(1, 0.5, 0.25),
			b_max_na = c(1, NA, 0.25),
			b_step_zero = c(1, 2, 0),
			b_step_negative = c(1, 2, -1)
			)
	)
})
