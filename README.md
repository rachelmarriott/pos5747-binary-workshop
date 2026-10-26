# Modeling Binary Outcomes: An Introduction to Logistic Regression

POS 5747: Modern Statistical Modeling, Florida State University
Barna Bose and Rachel Marriott

## Before the workshop (5–10 minutes)

1. Read `read-ahead.html` (or `read-ahead.pdf`).
2. Open this folder as an RStudio project:
   - **Local RStudio:** double-click `workshop.Rproj`.
   - **Posit Cloud:** New Project → upload the zipped folder → unzip it, keeping the `data/` subfolder → open `workshop.Rproj`.
3. Open `setup.R` and click **Source**. You should see an S-shaped test plot and the message `SUCCESS`.

## Files

| File | Purpose |
|---|---|
| `read-ahead.html` / `.pdf` | 5–10 minute introduction and setup instructions |
| `setup.R` | Installs packages and tests your setup (run before the workshop) |
| `workshop.R` | Example 1 (live coding) and Example 2 skeleton (your turn) |
| `solutions.R` | Completed Example 2 (look after the workshop!) |
| `handout.pdf` / `.html` | Take-home handout: concepts, math, both examples, references, alternative assignment |
| `slides.html` | Lecture slides (Quarto reveal.js; open in any browser, works offline). Press `S` for speaker notes, `F` for full screen, `E` then Ctrl/Cmd+P for PDF |
| `slides.qmd`, `garnet.scss` | Slide source and garnet theme (render with `quarto render slides.qmd`) |
| `slides/POS5747_Workshop.pdf` | Earlier Beamer version of the slides |
| `data/turnout.csv` | Prepared voter-turnout data (Example 1) |
| `data/civil_war.csv` | Prepared civil-war data (Example 2) |
| `data/exclusion_audit.csv` | Rows dropped during data preparation |
| `prepare_workshop_data.R` | Instructors only: builds `data/` from the original replication files |

## Data

### `data/turnout.csv` — Gerber, Green, and Larimer (2008)

229,444 registered voters in the Michigan August 2006 primary field experiment, restricted to the **control** and **neighbors-mailing** conditions. No rows were dropped.

| Variable | Definition |
|---|---|
| `voted` | 1 = voted in the August 2006 primary; 0 = did not |
| `treatment` | Original treatment code (0 = control, 3 = neighbors) |
| `neighbors` | 1 = household received the neighbors mailing; 0 = control |
| `hh_id` | Household identifier (treatment was assigned by household) |
| `yob` | Year of birth |
| `age` | Age at the 2006 primary (2006 − `yob`) |
| `p2004` | 1 = voted in the August 2004 primary; 0 = did not |

Source: Yale ISPS Data Archive, replication materials for Gerber, Green, and Larimer (2008).

### `data/civil_war.csv` — Fearon and Laitin (2003)

6,373 country-years, 1945–1999 (237 of 6,610 country-years dropped for missing income or population).

| Variable | Definition |
|---|---|
| `onset` | 1 = a civil war began in this country-year; 0 = otherwise |
| `onset_original` | Original coding (one country-year, Russia 1946, is coded 4; recoded to 1 in `onset`) |
| `gdpenl` | GDP per capita, lagged one year (thousands of 1985 US dollars) |
| `lpopl1` | Log population, lagged one year |
| `ccode` | Country code |

Source: Fearon and Laitin (2003) replication data (`repdata.dta`).

Both examples are **teaching adaptations**, not replications of the published analyses.

## Software

R (4.3 or newer recommended) with `ggplot2`, `marginaleffects`, and `sandwich`. `setup.R` installs anything missing.
