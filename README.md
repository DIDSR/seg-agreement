# Segmentation Agreement Confidence Intervals

This tool implements the method described in Hu et al. (2025).

## Overview

A R function for computing confidence intervals  when comparing an AI segmentation algorithm performance against multiple-human-observer annotations.

## Quick Start

the programming language: R
```
## Source the function
source("segmentationagreementci.R")

## Run analysis
result <- computesegmentationagreement_ci(

alpha = 0.05,                    # 95% confidence level
segmentation_data = your_data,   # Your DSC data matrix
n_observer = 3                   # Number of observers
)

## View results
print(result)
```

## Input Data Format

Your data should be a matrix with columns:
- `DSC.observer.pair.1`, `DSC.observer.pair.2`, ...  
- `DSC.device.observer.pair.1`, `DSC.device.observer.pair.2`, ... 

## Output

Returns confidence intervals for the difference in disagreement rates:
- Point estimate (delta_est)
- Bootstrap CI (lower_bootstrap, upper_bootstrap)
- Z-Wald CI (lower_wald, upper_wald)


## Requirements

- R (>= 3.5.0)
- Base R packages: stats

## Contact

For questions regarding regulatory use or methodology, please contact <small>`Tingting.Hu@fda.hhs.gov`</small>.

## Related Reference

<sub><i>Hu T, Sahiner B, Guan S, Mikailov M, Cha K, Samuelson F, Petrick N. Statistical testing of agreement in overlap-based performance between an AI segmentation device and a multi-expert human panel without requiring a reference standard. J Med Imaging (Bellingham). 2025 Sep;12(5):055003. doi: 10.1117/1.JMI.12.5.055003. Epub 2025 Oct 22. PMID: 41132782; PMCID: PMC12543030.</i></small>

## Tool Reference
•	RST Reference Number: RST26AI03.01
•	Date of Publication: 05/04/2026
•	Recommended Citation: U.S. Food and Drug Administration. (2026). SegAgree: Statistical Assessment of Agreement in Overlap-Based Performance Between an AI Segmentation Device and a Multi-Expert Human Panel (RST26AI03.01). https://cdrh-rst.fda.gov/segagree-statistical-assessment-agreement-overlap-based-performance-between-ai-segmentation-device

## Disclaimer About the Catalog of Regulatory Science Tools
The enclosed tool is part of the Catalog of Regulatory Science Tools, which provides a peer-reviewed resource for stakeholders to use where standards and qualified Medical Device Development Tools (MDDTs) do not yet exist. These tools do not replace FDA-recognized standards or MDDTs. This catalog collates a variety of regulatory science tools that the FDA's Center for Devices and Radiological Health's (CDRH) Office of Science and Engineering Labs (OSEL) developed. These tools use the most innovative science to support medical device development and patient access to safe and effective medical devices. If you are considering using a tool from this catalog in your marketing submissions, note that these tools have not been qualified as Medical Device Development Tools and the FDA has not evaluated the suitability of these tools within any specific context of use. You may request feedback or meetings for medical device submissions as part of the Q-Submission Program.
For more information about the Catalog of Regulatory Science Tools, email RST_CDRH@fda.hhs.gov.  

## Disclaimer
This software and documentation was developed at the Food and Drug Administration (FDA) by employees of the Federal Government in the course of their official duties. Pursuant to Title 17, Section 105 of the United States Code, this work is not subject to copyright protection and is in the public domain. Permission is hereby granted, free of charge, to any person obtaining a copy of the Software, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, or sell copies of the Software or derivatives, and to permit persons to whom the Software is furnished to do so. FDA assumes no responsibility whatsoever for use by other parties of the Software, its source code, documentation or compiled executables, and makes no guarantees, expressed or implied, about its quality, reliability, or any other characteristic. Further, use of this code in no way implies endorsement by the FDA or confers any advantage in regulatory decisions. Although this software can be redistributed and/or modified freely, we ask that any derivative works bear some notice that they are derived from it, and any modified versions bear some notice that they have been modified.

