# AMM
 
This folder contains the files to estimate a linear regression model using AMM, an adversarial estimator
using a GAN with a Logistic discriminator.

# Main files

1. main.m: Runs 'linearGMM.m' and 'logisticGAN.m' for a different configurations
2. main_simple.m: Same as 'main.m' but for a particular setup (for checks).
3. estimate.m: Estimates both GMM + AMM to compare finite sample properties.
4. AMM_OLS.m: Computes AMM for the same model 
5. loss_plot.m: Computes inputs for plotting the loss function for different parameter values (by simulation).

# Auxiliary files

1. sim_shocks.m: Simulates data for different panel data sizes (N, T) and parametric distribution
(Uniform, Normal, Student t, Log-Normal and Gaussian Mixture). This draws are fixed across iterations
while using SGD.
3. sgd_step.m: Different potential SGD updates (Vainilla, Momentum, RMSprop, Adam).
4. plot_config.m: Set up default config for plots.
