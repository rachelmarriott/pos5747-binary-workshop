# =====================================================================
# solutions.R  --  Example 2 solution (civil war onset)
# POS 5747 Workshop: Modeling Binary Outcomes
# Barna Bose and Rachel Marriott
#
# Fearon and Laitin (2003), APSR 97(1): 75-90.
# Reduced teaching model -- NOT a replication of the published results.
# =====================================================================

library(ggplot2)
library(marginaleffects)

civil_war <- read.csv("data/civil_war.csv")

# --- 0. Look at the outcome ------------------------------------------
table(civil_war$onset)         # 107 onsets in 6,373 country-years
mean(civil_war$onset)          # about 1.7%: a rare event
summary(civil_war$gdpenl)      # median ~2.0, max ~66.7: right-skewed

# --- 1. Fit ----------------------------------------------------------
fit_war <- glm(
  onset ~ gdpenl + lpopl1,
  data   = civil_war,
  family = binomial()
)
summary(fit_war)
# gdpenl is about -0.31 (log-odds per $1,000); lpopl1 about +0.27.

# --- 2. Expected values: predicted onset across income ---------------
p2 <- predictions(
  fit_war,
  newdata = datagrid(gdpenl = seq(0.5, 10, by = 0.5),
                     lpopl1 = mean),   # hold log population at its mean
  vcov = ~ccode                        # countries repeat across years
)
p2

ggplot(p2, aes(x = gdpenl, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(fill = "#782F40", alpha = 0.2) +
  geom_line(color = "#782F40", linewidth = 1) +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "Lagged GDP per capita (thousands of 1985 USD)",
       y = "Predicted Pr(onset)") +
  theme_minimal()

# --- 3. First difference: income at its 25th vs. 75th percentile -----
q <- quantile(civil_war$gdpenl, c(0.25, 0.75))
q                                      # $930 and $4,484

comparisons(
  fit_war,
  variables = list(gdpenl = as.numeric(q)),
  newdata   = datagrid(lpopl1 = mean),
  vcov      = ~ccode
)

# --- 4. Interpretation -----------------------------------------------
# Holding log population at its mean, moving lagged income from its
# 25th percentile ($930) to its 75th percentile ($4,484) lowers the
# predicted probability that a civil war begins in a given year from
# about 2.4% to about 0.8%: a first difference of about -1.6 percentage
# points (95% CI roughly -2.1 to -1.0, clustered by country). In
# relative terms that is a drop of about two-thirds, because onset is
# rare. This is an association, not a causal effect: income may proxy
# for state capacity or other factors that also shape conflict risk.
