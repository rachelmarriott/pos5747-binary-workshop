# =====================================================================
# setup.R  --  Run this ONCE before the workshop (takes 2-5 minutes)
# POS 5747 Workshop: Modeling Binary Outcomes
# Barna Bose and Rachel Marriott
#
# How to run: open the workshop project (workshop.Rproj or the folder in
# Posit Cloud), open this file, and click "Source" (top right of the
# script pane), or press Ctrl+Shift+S (Cmd+Shift+S on a Mac).
# =====================================================================

# --- 1. Install any missing packages ---------------------------------
needed  <- c("ggplot2", "marginaleffects", "sandwich")
missing <- needed[!needed %in% rownames(installed.packages())]
if (length(missing) > 0) {
  message("Installing: ", paste(missing, collapse = ", "))
  install.packages(missing)
}

library(ggplot2)
library(marginaleffects)

# --- 2. Check that the workshop data are where R expects them --------
files <- c("data/turnout.csv", "data/civil_war.csv")
found <- file.exists(files)
if (!all(found)) {
  stop(
    "Cannot find: ", paste(files[!found], collapse = ", "), "\n",
    "Make sure you opened the workshop folder as an RStudio project ",
    "and that the data/ subfolder is inside it.\n",
    "Your current working directory is: ", getwd()
  )
}

# --- 3. Test the full workflow on a built-in R dataset ---------------
# mtcars ships with R. am = 1 if a car has a manual transmission.
# (We use it here so the setup check does not reveal workshop results.)
test_fit <- glm(am ~ wt, data = mtcars, family = binomial())

test_pred <- predictions(
  test_fit,
  newdata = datagrid(wt = seq(1.5, 5.5, by = 0.25))
)

test_plot <- ggplot(test_pred,
                    aes(x = wt, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(fill = "#782F40", alpha = 0.2) +
  geom_line(color = "#782F40", linewidth = 1) +
  labs(x = "Car weight (1,000 lbs)",
       y = "Predicted Pr(manual transmission)",
       title = "Setup test: if you can see this S-shaped curve, you are ready!") +
  theme_minimal()
print(test_plot)

# --- 4. Report -------------------------------------------------------
cat("\n================================================\n")
cat("R version:              ", R.version$major, ".", R.version$minor, "\n", sep = "")
cat("marginaleffects version:", as.character(packageVersion("marginaleffects")), "\n")
cat("Data files found:        yes\n")
cat("SUCCESS: your setup works. See you at the workshop!\n")
cat("================================================\n")
