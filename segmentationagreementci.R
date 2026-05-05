#' Compute Confidence Intervals for Segmentation Agreement
#'
#' This function computes bootstrap and parametric confidence intervals
#' for the difference in disagreement rates between device and observer
#' segmentation pairs.
#'
#' @param alpha Significance level (default: 0.05 for 95% CI)
#' @param segmentation_data Matrix or data.frame with DSC values
#' @param n_observer Number of observers (required)
#' @param n_bootstrap Number of bootstrap samples (default: 1000)
#' @param seed Random seed for reproducibility (default: 123)
#'
#' @return List containing confidence intervals and metadata

compute_segmentation_agreement_ci <- function(alpha = 0.05,
                                              segmentation_data,
                                              n_observer,
                                              n_bootstrap = 1000,
                                              seed = 123) {

  # Input validation
  if (!is.matrix(segmentation_data) && !is.data.frame(segmentation_data)) {
    stop("segmentation_data must be a matrix or data.frame")
  }
  if (alpha <= 0 || alpha >= 1) {
    stop("alpha must be between 0 and 1")
  }
  if (n_bootstrap < 100) {
    warning("Recommend at least 1000 bootstrap samples for stable estimates")
  }
  if (!is.numeric(seed) || length(seed) != 1) {
    stop("seed must be a single numeric value")
  }
  if (missing(n_observer) || !is.numeric(n_observer) || length(n_observer) != 1 || n_observer < 2) {
    stop("n_observer must be a single integer >= 2")
  }

  # Validate column names and counts
  observer_cols <- grepl("^DSC\\.observer\\.pair\\.", colnames(segmentation_data))
  device_cols   <- grepl("^DSC\\.device\\.observer\\.pair\\.", colnames(segmentation_data))

  n_observer_cols <- sum(observer_cols)
  n_device_cols   <- sum(device_cols)

  # --- BUG FIX ---
  # observer pairs  = n_observer * (n_observer - 1) / 2  (all unique observer-observer pairs)
  # device&observer pairs = n_observer                   (one device vs. each observer)
  expected_observer_pairs <- n_observer * (n_observer - 1) / 2    
  expected_device_pairs   <- n_observer                            

  # Check observer columns
  if (n_observer_cols == 0) {
    stop("Data must contain columns matching 'DSC.observer.pair.*'")
  }
  if (n_observer_cols != expected_observer_pairs) {
    stop(sprintf(
      "Expected %d observer pair columns for %d observers, but found %d columns matching 'DSC.observer.pair.*'",
      expected_observer_pairs, n_observer, n_observer_cols
    ))
  }

  # Check device-observer columns
  if (n_device_cols == 0) {
    stop("Data must contain columns matching 'DSC.device.observer.pair.*'")
  }
  if (n_device_cols != expected_device_pairs) {
    stop(sprintf(
      "Expected %d device-observer pair columns for %d observers, but found %d columns matching 'DSC.device.observer.pair.*'",
      expected_device_pairs, n_observer, n_device_cols
    ))
  }

  # Internal function: compute delta for each observation
  compute_delta <- function(row) {
    observer_dsc <- row[observer_cols]
    device_dsc   <- row[device_cols]

    observer_disagreement <- mean(1 - observer_dsc, na.rm = TRUE)
    device_disagreement   <- mean(1 - device_dsc,   na.rm = TRUE)

    return(device_disagreement - observer_disagreement)
  }

  # Calculate deltas for all observations
  deltas <- apply(segmentation_data, 1, compute_delta)
  deltas <- deltas[is.finite(deltas)]
  n_obs  <- length(deltas)

  if (n_obs < 2) {
    stop("Insufficient valid images for confidence interval estimation")
  }

  # Point estimate
  delta_est <- mean(deltas, na.rm = TRUE)

  # Bootstrap confidence interval
  set.seed(seed)
  bootstrap_estimates <- replicate(n_bootstrap, {
    bootstrap_sample <- sample(deltas, size = n_obs, replace = TRUE)
    mean(bootstrap_sample, na.rm = TRUE)
  })

  lower_bootstrap <- quantile(bootstrap_estimates, alpha / 2,     na.rm = TRUE)
  upper_bootstrap <- quantile(bootstrap_estimates, 1 - alpha / 2, na.rm = TRUE)

  # Z-Wald confidence interval
  delta_se   <- sd(deltas, na.rm = TRUE) / sqrt(n_obs)
  z_critical <- qnorm(1 - alpha / 2)

  lower_wald <- delta_est - z_critical * delta_se
  upper_wald <- delta_est + z_critical * delta_se

  results <- list(
    delta_est         = delta_est,
    lower_bootstrap   = lower_bootstrap,
    upper_bootstrap   = upper_bootstrap,
    lower_wald        = lower_wald,
    upper_wald        = upper_wald,
    n_images          = n_obs,
    n_observers       = n_observer,
    confidence_level  = 1 - alpha,
    n_bootstrap_samples = n_bootstrap
  )

  class(results) <- "segmentation_agreement_ci"
  return(results)
}

# Print method
print.segmentation_agreement_ci <- function(x, digits = 4, ...) {
  cat("Segmentation Agreement Analysis\n")
  cat("==============================\n")
  cat("Point Estimate (Delta):", round(x$delta_est, digits), "\n")
  cat("Confidence Level:", x$confidence_level * 100, "%\n\n")
  cat("Bootstrap CI: [", round(x$lower_bootstrap, digits), ", ",
      round(x$upper_bootstrap, digits), "]\n", sep = "")
  cat("Z-Wald CI:    [", round(x$lower_wald, digits), ", ",
      round(x$upper_wald, digits), "]\n\n", sep = "")
  cat("Sample Size:", x$n_images, "images\n")
  cat("Bootstrap Samples:", x$n_bootstrap_samples, "\n")
}
