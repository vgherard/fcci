test_that("calls check_args_pois", {
	expect_error(confint_pois(-1), class = "domain_error")
})

test_that("Accepts default arguments", {
	expect_error(confint_pois(0), NA)
})

test_that("Returns a numeric vector of length two", {
	res <- confint_pois(0)

	expect_type(res, "double")
	expect_length(res, 2)
})

test_that("Has a cl attribute with the correct value", {
	cl <- 0.95
	res <- confint_pois(0, cl = cl)

	expect_identical(attr(res, "cl"), cl)
})

test_that("checks truncation", {
	expect_warning(
		confint_pois(0, lambda_max = 1), class = "truncation_warning"
		)
	expect_warning(
		confint_pois(0, lambda_min = 0.5), class = "truncation_warning"
		)
})
