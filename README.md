# studyplanner 📦
[![R-CMD-check](https://github.com/jh-adv-data-sci/project-4-r-packages-chunyu-yes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jh-adv-data-sci/project-4-r-packages-chunyu-yes/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/jh-adv-data-sci/project-4-r-packages-chunyu-yes/branch/main/graph/badge.svg?token=2f4b0a8b-97d6-4004-96fc-7af0f249ca64)](https://app.codecov.io/github/jh-adv-data-sci/project-4-r-packages-chunyu-yes)
![coverage](https://img.shields.io/endpoint?url=https%3A%2F%2Fgist.githubusercontent.com%2Fchunyu-yes%2F5fe9554552dc548aea2fd0a0915be94e%2Fraw%2Fcoverage.json&cacheSeconds=300)

An R package for planning two-arm studies with cost and power considerations.  
This package implements helper functions to calculate adjusted effect size, statistical power, sample size, study cost, and to optimize designs under budget constraints.

---

## 🚀 Installation

Clone the repo and install locally:

```r
# install.packages("devtools")
devtools::install_github("jh-adv-data-sci/project-4-r-packages-chunyu-yes", subdir = "studyplanner")
```

## Usage

```r
library(studyplanner)

# Adjusted effect size for correlated baseline-follow-up design
d <- effect_size_adj(delta = 0.05, sigma = 0.2, rho = 0.9)

# Power calculation
power_two_arm(d, n = 100, alpha = 0.05)

# Required sample size for 90% power
sample_size_two_arm(d, alpha = 0.05, target_power = 0.9)

# Study cost (fixed costs= baseline $3000 + 1-year $2000=$5000, cost_per_subject=MRI$5000*2=$10000)
study_cost(n = 100, cost_per_subject = 10000, fixed_costs = 5000)

# Optimize under budget
optimize_under_budget(d, alpha = 0.05, budget = 1000000, cost_per_subject = 10000)

# High-level helper
study_planner(delta = 0.05, sigma = 0.2, rho = 0.9,
              alpha = 0.05, target_power = 0.9,
              budget = 1000000, cost_per_subject = 10000)
```

## Testing & Coverage
Run unit tests:
```r
devtools::test()
```
Check coverage:
```r
# install.packages("covr")
covr::report()
```
## Vignette
For a worked example, see the vignette:
```r
browseVignettes("studyplanner")
```
