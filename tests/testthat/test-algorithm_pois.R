test_that("Test of correct coverage for 10 random 'lambda's and 1 random 'b'", {
	cl <- 0.95
	tol <- 2 * 1e-3

	b_max <- 10
	b <- floor(runif(1, min = 0, max = b_max))

	N_test <- 10
	lambda_max <- 10
	lambda <- runif(N_test, min = 0, max = lambda_max)
	prob <- numeric(N_test)

	n_max <- b + max(lambda) + 10 * sqrt(b + max(lambda))
	for (n in 0:n_max) {
		ci <- confint_pois(n, b = b)
		mask <- ci[[1]] <= lambda * (1 + tol) &
			lambda * (1 - tol) <= ci[[2]]
		prob_n <- dpois(n, lambda + b)
		prob <- prob + prob_n * mask
	}

	for (i in seq_along(prob)) {
		label <- paste0("lambda: ", lambda[[i]], ", b: ", b)
		expect_gte(prob[[i]], cl, label = label)
	}
})

test_that("agreement with few cases from Felmdan-Cousins paper",
	# ref: https://arxiv.org/pdf/physics/9711021.pdf
{
	ee <- function(actual, expected) {
		attributes(actual) <- NULL
		expect_equal(actual, expected, tolerance = 0.01)
	}

	ee(confint_pois(n = 0, b = 0), c(0.00, 3.09))
	ee(confint_pois(n = 10, b = 2), c(2.92, 15.82))

	# Special case which requires the 'b' correction for agreement with FC
	n <- 0; b <- 2; cl <- 0.9
	expected <- c(0, 1.26)
	actual <- confint_pois(n = n, b = b, cl = cl)
	actual_corrected <- confint_pois(
		n = n, b = c(2, 3, 0.01), cl = cl, acc = 0.003, lambda_max = 1.5
		)

	expect_failure(ee(actual, expected))
	ee(actual_corrected, expected)
})
