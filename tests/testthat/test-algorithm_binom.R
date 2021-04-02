test_that("Test of correct coverage for 10 random 'p's and 1 random 'N'", {
	cl <- 0.95
	tol <- 1e-3
	N_max <- 20
	N <- floor(runif(1, min = 1, max = N_max))

	N_test <- 1e3
	p <- runif(N_test, min = 0, max = 1)
	prob <- numeric(N_test)

	for (n in 0:N) {
		ci <- confint_binom(n, N, cl, acc = tol / 2)
		mask <- ci[[1]] <= p + tol & p - tol <= ci[[2]]
		prob_n <- dbinom(n, N, p)
		prob <- prob + prob_n * mask
	}


	for (i in seq_along(prob)) {
		label <- paste0("p: ", p[[i]], ", N: ", N)
		expect_gte(prob[[i]], cl, label = label)
	}
})
