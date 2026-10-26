# =====================================================================
# workshop.R  --  Modeling Binary Outcomes: An Introduction to Logit
# POS 5747: Modern Statistical Modeling, Florida State University
# Barna Bose and Rachel Marriott
#
# Run this script LINE BY LINE (Ctrl+Enter / Cmd+Enter), not with "Source".
# Part 2 contains blanks (___) for you to fill in, so sourcing the whole
# file will stop with an error until they are filled.
#
# The workflow has three steps, and the same three steps work for both
# examples:
#   1. Fit         -- glm(..., family = binomial())
#   2. Expected values (predicted probabilities) -- predictions()
#   3. First differences (change in probability)  -- comparisons()
# =====================================================================

library(ggplot2)
library(marginaleffects)


# =====================================================================
# PART 1 (LIVE CODING): Social pressure and voter turnout
# Gerber, Green, and Larimer (2008), APSR 102(1): 33-48.
#
# 229,444 registered voters in the Michigan August 2006 primary.
#   voted     1 = voted in the 2006 primary, 0 = did not
#   neighbors 1 = household got the "neighbors" mailing, 0 = control
#   age       age at the 2006 primary (2006 - year of birth)
#   p2004     1 = voted in the August 2004 primary, 0 = did not
#   hh_id     household ID (mailings were sent to households)
# =====================================================================

turnout <- read.csv("data/turnout.csv")

# --- 0. Look at the outcome before modeling --------------------------
table(turnout$voted)                          # only 0s and 1s, no NAs
tapply(turnout$voted, turnout$neighbors, mean) # raw turnout by group

# --- 1. Fit ---------------------------------------------------------
fit_turnout <- glm(
  voted ~ neighbors + age + p2004,
  data   = turnout,
  family = binomial()        # binomial() uses the logit link by default
)
summary(fit_turnout)          # coefficients are in LOG-ODDS

# --- 2. Expected values: predicted turnout across age ---------------
# Scenario: people aged 20-90 who did NOT vote in 2004, with and
# without the neighbors mailing.
p <- predictions(
  fit_turnout,
  newdata = datagrid(neighbors = c(0, 1),
                     age       = seq(20, 90, by = 5),
                     p2004     = 0),
  vcov = ~hh_id              # uncertainty clustered by household
)
p

ggplot(p, aes(x = age, y = estimate, ymin = conf.low, ymax = conf.high,
              color = factor(neighbors), fill = factor(neighbors))) +
  geom_ribbon(alpha = 0.2, color = NA) +
  geom_line(linewidth = 1) +
  scale_y_continuous(labels = scales::percent) +
  scale_color_manual(values = c("grey40", "#782F40"),
                     labels = c("Control", "Neighbors mailing")) +
  scale_fill_manual(values = c("grey40", "#782F40"),
                    labels = c("Control", "Neighbors mailing")) +
  labs(x = "Age at the 2006 primary", y = "Predicted Pr(voted)",
       color = NULL, fill = NULL) +
  theme_minimal()

# --- 3. First difference: neighbors minus control, across age -------
cmp <- comparisons(
  fit_turnout,
  variables = "neighbors",   # what changes: 0 -> 1
  newdata   = datagrid(age = seq(20, 90, by = 5), p2004 = 0),  # what is fixed
  vcov      = ~hh_id
)
cmp

ggplot(cmp, aes(x = age, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(fill = "#782F40", alpha = 0.2) +
  geom_line(color = "#782F40", linewidth = 1) +
  scale_y_continuous(labels = scales::label_percent(suffix = " pp")) +
  labs(x = "Age at the 2006 primary",
       y = "Neighbors - control\n(percentage points)") +
  theme_minimal()


# =====================================================================
# PART 2 (YOUR TURN): Does national income predict civil war onset?
# Fearon and Laitin (2003), APSR 97(1): 75-90.
# Reduced teaching model -- NOT a replication of the published results.
#
# 6,373 country-years, 1945-1999.
#   onset   1 = a civil war BEGAN in this country-year, 0 = otherwise
#   gdpenl  GDP per capita, lagged one year (thousands of 1985 US$)
#   lpopl1  log population, lagged one year
#   ccode   country code (countries appear in many years)
#
# Fill in every ___ . Use Part 1 as your template.
# =====================================================================

civil_war <- read.csv("data/civil_war.csv")

# --- 0. Look at the outcome ------------------------------------------
table(civil_war$onset)
mean(civil_war$onset)          # how common is onset?
summary(civil_war$gdpenl)      # income is right-skewed

# --- 1. Fit: onset on lagged income and lagged log population --------
fit_war <- glm(
  ___ ~ ___ + ___,
  data   = civil_war,
  family = binomial()
)
summary(fit_war)

# --- 2. Expected values: predicted onset across income ---------------
# Income from 0.5 to 10 (thousands), log population held at its mean.
p2 <- predictions(
  fit_war,
  newdata = datagrid(gdpenl = seq(___, ___, by = 0.5),
                     lpopl1 = ___),
  vcov = ~___                  # cluster by country
)
p2

ggplot(p2, aes(x = ___, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(fill = "#782F40", alpha = 0.2) +
  geom_line(color = "#782F40", linewidth = 1) +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "Lagged GDP per capita (thousands of 1985 USD)",
       y = "Predicted Pr(onset)") +
  theme_minimal()

# --- 3. First difference: income at its 25th vs. 75th percentile -----
q <- quantile(civil_war$gdpenl, c(0.25, 0.75))
q

comparisons(
  fit_war,
  variables = list(gdpenl = as.numeric(q)),   # 25th -> 75th percentile
  newdata   = datagrid(lpopl1 = ___),
  vcov      = ~___
)

# --- 4. Interpret (write your answer as a comment) --------------------
# In one or two sentences: by how many PERCENTAGE POINTS does the
# predicted probability of onset change, what did you hold fixed, and
# why is this association not necessarily a causal effect?
#
#
