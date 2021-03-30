#include <Rcpp.h>
#include <Rmath.h>
#include <vector>
using namespace Rcpp;

double binom_lik_ratio(int n, int N, double p, double b) {
	if (n < 0)
		return 0;
	return R::dbinom(n, N, p, 0) / R::dbinom(n, N, (double)n / N, 0);
}

// [[Rcpp::export]]
std::vector<double> binom_confint_cpp(
		int n, int N, double cl,
		double p_min, double p_max, double p_step
)
{
	size_t grid_len = (p_max - p_min) / p_step + 1;

	double p_up, p_lo;
	bool found_lo = false;

	for (size_t i = 0; i < grid_len; ++i)
	{
		double p = p_min + p_step * i;
		int l, r; double Rbest = 0;

		// One of these two points maximizes the likelihood ratio
		for (int m : {(int) (p * N), (int)(p * N) + 1})
		{
			double R = binom_lik_ratio(m, N, p, 0);
			if (R > Rbest) { l = r = m; Rbest = R; }
		}

		double prob = R::dbinom(l, N, p, 0);

		while (prob < cl) {
			double R_l = binom_lik_ratio(l - 1, N, p, 0);
			double R_r = binom_lik_ratio(r + 1, N, p, 0);
			if (R_r  > R_l)
				prob += R::dbinom(++r, N, p, 0);
			else
				prob += R::dbinom(--l, N, p, 0);
		}
		if ((l <= n) & (n <= r)) {
			p_up = p;
			if (not found_lo) {
				p_lo = p;
				found_lo = true;
			}
		}
	}

	return {p_lo, p_up};
}
