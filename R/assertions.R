

is_event_count <- function(x) {
	assertthat::assert_that(
		assertthat::is.number(x),
		msg = paste0(deparse(match.call()$x), " is not a number.")
		)
	return(x >= 0)
}

assertthat::on_failure(is_event_count) <- function(call, env) {
	paste0(deparse(call$x), " must be non negative.")
}

is_probability <- function(x) {
	assertthat::assert_that(
		assertthat::is.number(x),
		msg = paste0(deparse(match.call()$x), " is not a number.")
	)
	return(0 <= x && x <= 1)
}

assertthat::on_failure(is_probability) <- function(call, env) {
	paste0(deparse(call$x), " must be a number between zero and one.")
}

is_non_negative <- function(x) {
	assertthat::assert_that(
		assertthat::is.number(x),
		msg = paste0(deparse(match.call()$x), " is not a number.")
	)
	return(x >= 0)
}

assertthat::on_failure(is_non_negative) <- function(call, env) {
	paste0(deparse(call$x), " must be non negative.")
}


is_positive <- function(x) {
	assertthat::assert_that(
		assertthat::is.number(x),
		msg = paste0(deparse(match.call()$x), " is not a number.")
	)
	return(x > 0)
}

assertthat::on_failure(is_positive) <- function(call, env) {
	paste0(deparse(call$x), " must be positive.")
}
