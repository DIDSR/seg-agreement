# Example Usage of Segmentation Agreement CI Function
# ==================================================

# Load the function
source("segmentation_agreement_ci.R")

# Create example data for 3 observers
set.seed(123)
n_images <- 300
n_observers <- 3

# Generate example DSC data (values between 0.7 and 0.95)
example_data <- matrix(runif(n_images * (n_observers + 3), 0.7, 0.95), 
                      nrow = n_images)

# Set proper column names
colnames(example_data) <- c(
    # Observer pair columns (n_observer columns)
    paste0("DSC.observer.pair.", 1:n_observers),
    
    # Device-observer pair columns (3 pairs for unique combinations)
    paste0("DSC.device.observer.pair.", 1:3)
)

# Display first few rows
cat("Example Data (first 5 rows):\n")
print(head(example_data, 5))

# Run the analysis
cat("\n=== Running Segmentation Agreement Analysis ===\n")
result <- compute_segmentation_agreement_ci(
    alpha = 0.05,                    # 95% confidence intervals
    segmentation_data = example_data,
    n_observer = 3,                  # 3 observers
    n_bootstrap = 1000,              # 1000 bootstrap samples
    seed = 123                       # For reproducible results
)

# Display results
print(result)

# Access individual components
cat("\n=== Individual Results ===\n")
cat("Point Estimate:", result$delta_est, "\n")
cat("Bootstrap 95% CI: [", result$lower_bootstrap, ", ", result$upper_bootstrap, "]\n")
cat("Z-Wald 95% CI: [", result$lower_wald, ", ", result$upper_wald, "]\n")

