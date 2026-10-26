# =====================================================================
# prepare_workshop_data.R  --  Instructors only; participants do NOT run this.
# Creates data/turnout.csv, data/civil_war.csv, data/exclusion_audit.csv
# from the original replication files.
#
# Run once from a folder containing the two unzipped Stata files:
#   GerberGreenLarimer_APSR_2008_social_pressure.dta  (Yale ISPS Data Archive)
#   repdata.dta                                       (Fearon & Laitin replication)
# =====================================================================

# install.packages("haven")   # only if not installed
library(haven)
dir.create("data", showWarnings = FALSE)

# --- 1. Voter turnout: Gerber, Green, and Larimer (2008) -------------
gerber <- read_dta("GerberGreenLarimer_APSR_2008_social_pressure.dta")

# Keep control (0) and neighbors-mailing (3) groups
turnout <- subset(
  gerber,
  treatment %in% c(0, 3),
  select = c(voted, treatment, hh_id, yob, p2004)
)
turnout <- as.data.frame(lapply(turnout, as.numeric))   # drop Stata labels
turnout$neighbors <- as.integer(turnout$treatment == 3) # 1 = neighbors mailing
turnout$age <- 2006 - turnout$yob                       # age at Aug. 2006 primary

n_turnout_before <- nrow(turnout)
turnout <- na.omit(turnout)
write.csv(turnout, "data/turnout.csv", row.names = FALSE)

# --- 2. Civil war onset: Fearon and Laitin (2003) --------------------
fearon <- read_dta("repdata.dta")
civil_war <- as.data.frame(
  lapply(fearon[c("onset", "gdpenl", "lpopl1", "ccode")], as.numeric)
)

# Teaching recode: one country-year (Russia, 1946) has onset = 4; treat it
# as an onset (1). The original value is kept in onset_original for auditing.
civil_war$onset_original <- civil_war$onset
civil_war$onset[civil_war$onset == 4 & !is.na(civil_war$onset)] <- 1

n_war_before <- nrow(civil_war)
civil_war <- na.omit(civil_war)   # drops missing gdpenl / lpopl1
write.csv(civil_war, "data/civil_war.csv", row.names = FALSE)

# --- 3. Audit of exclusions ------------------------------------------
audit <- data.frame(
  dataset             = c("turnout", "civil_war"),
  rows_before_na_omit = c(n_turnout_before, n_war_before),
  rows_kept           = c(nrow(turnout), nrow(civil_war))
)
audit$rows_dropped <- audit$rows_before_na_omit - audit$rows_kept
write.csv(audit, "data/exclusion_audit.csv", row.names = FALSE)
