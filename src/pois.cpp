#include <Rcpp.h>
#include <Rmath.h>
#include <vector>
using namespace Rcpp;

double pois_lik_ratio(int n, double lambda, double b) {
	if (n < 0)
		return 0;
	return R::dpois(n, lambda + b, 0) / R::dpois(n, n - b > 0 ? n : b, 0);
}

// [[Rcpp::export]]
std::vector<double> confint_pois_cpp(
		int n, double b, double cl,
		double lambda_min, double lambda_max, double lambda_step
	)
{
	size_t grid_len = (lambda_max - lambda_min) / lambda_step + 1;

	double lambda_up, lambda_lo;
	bool found_lo = false;

	for (size_t i = 0; i < grid_len; ++i)
	{
		double lambda = lambda_min + lambda_step * i;
		int l, r; double Rbest = 0;

		// One of these three points maximizes the likelihood ratio
		for (int m : {(int)b, (int)(lambda + b), (int)(lambda + b) + 1})
		{
			double R = pois_lik_ratio(m, lambda, b);
			if (R > Rbest) { l = r = m; Rbest = R; }
		}

		double prob = R::dpois(l, lambda + b, 0);

		while (prob < cl) {
			double R_l = pois_lik_ratio(l - 1, lambda, b);
			double R_r = pois_lik_ratio(r + 1, lambda, b);
			if (R_r  > R_l)
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
