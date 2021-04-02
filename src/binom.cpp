// [[Rcpp::plugins(cpp11)]]
#include "DiscreteFeldmanCousins.h"
#include <Rcpp.h>
#include <Rmath.h>

struct BinomialFeldmanCousins : public DiscreteFeldmanCousins {

	int N_;

	double lik_ratio(int m) {
		return m < 0 ? 0 :
			R::dbinom(m, N_, t_, 0) /
			R::dbinom(m, N_, (double)m / N_, 0);
		}

	double prob(int m) { return R::dbinom(m, N_, t_, 0); }

	int top_n() {
		int res = 0;
		double Rbest = 0;

		for (int m : {(int) (t_ * N_), (int)(t_ * N_) + 1})
		{
			double R = lik_ratio(m);
			if (R > Rbest) { res = m; Rbest = R; }
		}

		return res;
	}

	BinomialFeldmanCousins(
		int n, int N, double cl,
		double p_min, double p_max, double p_step
	) : DiscreteFeldmanCousins(n, cl, p_min, p_max, p_step), N_(N) {}
};

// [[Rcpp::export]]
Rcpp::NumericVector confint_binom_cpp(
		int n, int N, double cl,
		double p_min, double p_max, double p_step
)
{
	BinomialFeldmanCousins fc(n, N, cl, p_min, p_max, p_step);
	return fc.confint();
}
