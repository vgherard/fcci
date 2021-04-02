// [[Rcpp::plugins(cpp11)]]

#include "DiscreteFeldmanCousins.h"
#include <Rcpp.h>
#include <cmath>
#include <limits>

struct PoissonFeldmanCousins : public DiscreteFeldmanCousins {

	double b_;

	double lik_ratio(int m) {
		if (m < 0)
			return -std::numeric_limits<double>::infinity();
		double rate = t_ + b_;
		double rate_best = m > b_ ? m : b_;
		if (rate_best < std::numeric_limits<double>::epsilon())
			return -rate;
		if (rate < std::numeric_limits<double>::epsilon())
			return -std::numeric_limits<double>::infinity();
		return m * std::log(rate / rate_best) - rate + rate_best;
	}

	double prob(int m) { return R::dpois(m, t_ + b_, 0); }

	int top_n() {
		int res = 0;
		double Rbest = -std::numeric_limits<double>::infinity();

		for (int m : {(int)b_, (int)(t_ + b_), (int)(t_ + b_) + 1})
		{
			double R = lik_ratio(m);
			if (R > Rbest) { res = m; Rbest = R; }
		}

		return res;
	}

	PoissonFeldmanCousins(
		int n, double b, double cl,
		double lambda_min, double lambda_max, double lambda_step
	) : DiscreteFeldmanCousins(n, cl, lambda_min, lambda_max, lambda_step),
		b_(b) {}
};

/// @brief Compute confidence intervals for a Poisson rate using the
/// Feldman-Cousins construction.
/// @param n an integer. Number of observed events.
/// @param b a positive number. Rate of background events.
/// @param cl a probability. Confidence level for the returned confidence
/// intervals.
/// @param lambda_min,lambda_max,lambda_step parameters defining the grid for
/// which the Neyman belt construction is carried out.
/// @return a vector<double> of length two, containing the endpoints of the
/// confidence interval.
// [[Rcpp::export]]
Rcpp::NumericVector confint_pois_cpp(
		int n, double b, double cl,
		double lambda_min, double lambda_max, double lambda_step
	)
{
	PoissonFeldmanCousins fc(n, b, cl, lambda_min, lambda_max, lambda_step);
	return fc.confint();
}

/// @brief Compute adjusted confidence intervals for a Poisson rate using the
/// Feldman-Cousins construction.
/// @param n an integer. Number of observed events.
/// @param b a positive number. Rate of background events.
/// @param cl a probability. Confidence level for the returned confidence
/// intervals.
/// @param lambda_min,lambda_max,lambda_step parameters defining the grid for
/// which the Neyman belt construction is carried out.
/// @param b_max,b_step parameters defining the grid of 'b' values for which
/// the correction described by FC is applied.
/// @return a vector<double> of length two, containing the endpoints of the
/// confidence interval.
/// @details These adjusted confidence intervals ensure for the monotonicity
/// of upper endpoints as functions of 'b', by enlarging the confidence interval
/// obtained through the basic construction as necessary.
// [[Rcpp::export]]
Rcpp::NumericVector confint_pois_adj_cpp(
		int n, double b, double cl,
		double lambda_min, double lambda_max, double lambda_step,
		double b_max, double b_step
	)
{
	PoissonFeldmanCousins fc(n, b, cl, lambda_min, lambda_max, lambda_step);

	Rcpp::NumericVector res = fc.confint();

	b += b_step;
	for (; b < b_max; b += b_step) {
		fc.b_ = b;
		Rcpp::NumericVector tmp = fc.confint();
		if (tmp[1] > res[1])
			res[1] = tmp[1];
	}

	return res;
}
