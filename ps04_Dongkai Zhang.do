* =========================================================
* ECON 689 Problem Set 4
* Name: Dongkai Zhang
* =========================================================

clear all
set more off

* ---------------------------------------------------------
* Problem 1: Generate the data and estimate the full regression
* ---------------------------------------------------------

* 1. Set seed and create 500 observations
set seed 2026
set obs 500

* 2. Generate data based on the given DGP
* x2 ~ N(1, 1)
gen x2 = rnormal(1, 1)

* v ~ N(0, 1)
gen v = rnormal(0, 1)

* x1 = 0.7*x2 + v
gen x1 = 0.7 * x2 + v

* u ~ N(0, 2^2)
gen u = rnormal(0, 2)

* y = 5 + 3*x1 - 2*x2 + u
gen y = 5 + 3 * x1 - 2 * x2 + u

* 3. Summarize y, x1, and x2
summarize y x1 x2

* 4. Estimate the full regression
regress y x1 x2

* 5. Store the estimated coefficient on x1 as b1_full and display it
scalar b1_full = _b[x1]
display "The estimated coefficient b1_full is: " b1_full


* ---------------------------------------------------------
* Problem 2: Verify the FWL theorem
* ---------------------------------------------------------

* 1. Regress y on x2 and save residuals as y_resid
regress y x2
predict y_resid, residuals

* 2. Regress x1 on x2 and save residuals as x1_resid
regress x1 x2
predict x1_resid, residuals

* 3. Scatterplot of y_resid against x1_resid with fitted line
twoway (scatter y_resid x1_resid) (lfit y_resid x1_resid), ///
    title("FWL Theorem Verification") ///
    ytitle("Residuals of y on x2") ///
    xtitle("Residuals of x1 on x2") ///
    legend(order(1 "y_resid" 2 "Fitted line")) 
    
* 4. Regress y_resid on x1_resid WITHOUT a constant
regress y_resid x1_resid, noconstant

* Store the coefficient on x1_resid as b1_fwl
scalar b1_fwl = _b[x1_resid]

* 5. Display b1_full, b1_fwl, and their difference
display "b1_full (from full regression): " b1_full
display "b1_fwl  (from FWL procedure):    " b1_fwl
display "Difference (b1_full - b1_fwl):   " b1_full - b1_fwl
display "Absolute Difference:             " abs(b1_full - b1_fwl)

* Verify that the difference is approximately 0.
* The absolute difference is around 1e-8, so the verification is successful.

* Close the log.
capture log close