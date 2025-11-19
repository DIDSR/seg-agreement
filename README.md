# Segmentation Agreement Confidence Intervals

## Citation

This tool implements the method described in  

<sub><i>Hu T, Sahiner B, Guan S, Mikailov M, Cha K, Samuelson F, Petrick N. Statistical testing of agreement in overlap-based performance between an AI segmentation device and a multi-expert human panel without requiring a reference standard. J Med Imaging (Bellingham). 2025 Sep;12(5):055003. doi: 10.1117/1.JMI.12.5.055003. Epub 2025 Oct 22. PMID: 41132782; PMCID: PMC12543030.</i></small>


## Overview

A R function for computing confidence intervals  when comparing an AI segmentation algorithm performance against multiple-human-observer annotations.

## Quick Start

r

Source the function
source("segmentationagreementci.R")

Run analysis
result <- computesegmentationagreement_ci(

alpha = 0.05,                    # 95% confidence level
segmentation_data = your_data,   # Your DSC data matrix
n_observer = 3                   # Number of observers
)

View results
print(result)


## Input Data Format

Your data should be a matrix with columns:
- `DSC.observer.pair.1`, `DSC.observer.pair.2`, ... (n_observer columns)
- `DSC.device.observer.pair.1`, `DSC.device.observer.pair.2`, ... (n*(n-1)/2 or n*(n-1) columns)

## Output

Returns confidence intervals for the difference in disagreement rates:
- Point estimate (delta_est)
- Bootstrap CI (lower_bootstrap, upper_bootstrap)
- Z-Wald CI (lower_wald, upper_wald)


## Requirements

- R (>= 3.5.0)
- Base R packages: stats

## Contact

For questions regarding regulatory use or methodology, please contact Tingting.Hu@fda.hhs.gov.
