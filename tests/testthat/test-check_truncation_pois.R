test_that("no warnings are thrown in a normal case", {
	expect_warning(
		regexp = NA,
		object = check_truncation_pois(
			res = c(1, 2),
			grid = list(min = 0.5, max = 2.5, step = 0.5),
			acc = 0.1
		)
	)
})

test_that("no warnings are thrown when lo = min = 0", {
	expect_warning(
		regexp = NA,
		object = check_truncation_pois(
			res = c(0, 2),
			grid = list(min = 0, max = 2.5, step = 0.5),
			acc = 0.1
		)
	)
})

test_that("Warn on lower endpoint truncation", {
	expect_warning(
		object = check_truncation_pois(
			res = c(1, 2),
			grid = list(min = 1, max = 3, step = 0.5),
			acc = 0.1
		),
		class = "truncation_warning"
	)
})

test_that("Warn on upper endpoint truncation", {
	expect_warning(
		object = check_truncation_pois(
			res = c(1, 2),
			grid = list(min = 0, max = 2, step = 0.5),
			acc = 0.1
		),
		class = "truncation_warning"
	)
})
