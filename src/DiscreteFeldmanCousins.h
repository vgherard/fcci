#ifndef DISCRETE_FELDMAN_COUSINS_HPP
#define DISCRETE_FELDMAN_COUSINS_HPP

#include <Rcpp.h>

struct DiscreteFeldmanCousins {
	int n_;
	double cl_;
	double t_min_, t_max_, t_step_;
	double t_;
	virtual double lik_ratio(int m) { return 1; }
	virtual double prob(int m) { return 1; }
	virtual int top_n() { return 0; }

	DiscreteFeldmanCousins (
		int n, double cl, double t_min, double t_max, double t_step
	) : n_(n), cl_(cl),
		t_min_(t_min), t_max_(t_max), t_step_(t_step), t_(t_min)
	{}

	Rcpp::NumericVector confint()
	{
		size_t grid_len = (t_max_ - t_min_) / t_step_ + 1;

		double t_up, t_lo;
		bool found_lo = false;

		for (size_t i = 0; i < grid_len; ++i)
		{
			t_ = t_min_ + t_step_ * i;

			int l, r;
			l = r = top_n();

			double p = prob(l);

			while (p < cl_) {
				double R_l = lik_ratio(l - 1);
				double R_r = lik_ratio(r + 1);
				if (lik_ratio(r + 1)  > lik_ratio(l - 1))
					p += prob(++r);
				else
					p += prob(--l);
			}

			if ((l <= n_) & (n_ <= r)) {
				t_up = t_;
				if (not found_lo) {
					t_lo = t_;
					found_lo = true;
				}
			}
		}

		return {t_lo, t_up};
	}

};

#endif // DISCRETE_FELDMAN_COUSINS_HPP
