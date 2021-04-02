#include <Rcpp.h>
#include <Rmath.h>
#include <cmath>
#include <limits>
#include <vector>
using namespace Rcpp;

double lik_ratio_pois(int n, double lambda, double b) {
	if (n < 0)
		return -std::numeric_limits<double>::infinity();
	double rate = lambda + b;
	double rate_best = n > b ? n : b;
	if (rate_best < std::numeric_limits<double>::epsilon())
		return -(lambda + b);
	if (rate < std::numeric_limits<double>::epsilon())
		return -std::numeric_limits<double>::infinity();
	return n * std::log(rate / rate_best) - rate + rate_best;
}

// [[Rcpp::export]]
std::vector<double> confint_pois_cpp(
		int n, double b, double cl,
		double lambda_min, double lambda_max, double lambda_step
	)
{
	size_t grid_len = (lambda_max - lambda_min) / lambda_step + 1;

	double lambda_up = lambda_min, lambda_lo = lambda_min;
	bool found_lo = false;

	for (size_t i = 0; i < grid_len; ++i)
	{
		double lambda = lambda_min + lambda_step * i;
		int l, r; double Rbest = -std::numeric_limits<double>::infinity();

		// One of these three points maximizes the likelihood ratio
		for (int m : {(int)b, (int)(lambda + b), (int)(lambda + b) + 1})
		{
			double R = lik_ratio_pois(m, lambda, b);
			if (R > Rbest) { l = r = m; Rbest = R; }
		}

		double prob = R::dpois(l, lambda + b, 0);

		while (prob < cl) {
			double R_l = lik_ratio_pois(l - 1, lambda, b);
			double R_r = lik_ratio_pois(r + 1, lambda, b);
			if (R_r > R_l)
				prob += R::dpois(++r, lambda + b, 0);
			else
				prob += R::dpois(--l, lambda + b, 0);
		}

		if ((l <= n) & (n <= r)) {
			lambda_up = lambda;
			if (not found_lo) {
				lambda_lo = lambda;
				found_lo = true;
			}
		}
	}

	return {lambda_lo, lambda_up};
}

// [[Rcpp::export]]
std::vector<double> confint_pois_adj_cpp(
		int n, double b, double cl,
		double lambda_min, double lambda_max, double lambda_step,
		double b_max = 0, double b_step = 0
	)
{
	std::vector<double> res =
		confint_pois_cpp(n, b, cl, lambda_min, lambda_max, lambda_step);

	b += b_step;
	for (; b < b_max; b += b_step) {
		std::vector<double> tmp =
			confint_pois_cpp(
				n, b, cl, lambda_min, lambda_max, lambda_step);
		res[1] = std::max(res[1], tmp[1]);
	}

	return res;
}
