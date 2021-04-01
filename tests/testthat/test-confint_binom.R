test_that("calls check_args_binom", {
	expect_error(confint_binom(n = 10, N = 9), class = "domain_error")
})

test_that("Accepts default arguments", {
	expect_error(confint_binom(n = 50, N = 100), NA)
})

test_that("Returns a numeric vector of length two", {
	res <- confint_binom(1, 2)

	expect_type(res, "double")
	expect_length(res, 2)
})

test_that("Has a cl attribute with the correct value", {
	cl <- 0.95
	res <- confint_binom(1, 2, cl = cl)

	expect_identical(attr(res, "cl"), cl)
})
