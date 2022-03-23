This folder contains the files to estimate a linear regression model
in Matlab and compare the finite-sample properties vs. the Logistic GANs estimator of Kaji, Manresa & Pouliot (2020).

Main files
----------

1. main.m: Runs 'linearGMM.m' and 'logisticGAN.m' for a different configurations (CS, TS & distributions)
2. main_simple.m: Same as 'main.m' but for a particular setup (for checks).
3. main_loss_plot.m: Runs 'loss_plot.m' and saves the plots.

4. estimate.m: Estimates both GMM + AMM to compare finite sample properties.
5. GMM_AS.m: Computes {1-step, 2-step, Iterated, CU} GMM estimators for the linear model [g(theta) = x - theta]
6. AMM.m: Computes Logistic GANs for the same model (moment conditions), with data drawn from a set of 
parametric distributions (Uniform, Normal, Student t, Log-Normal and Gaussian Mixture).
7. loss_plot.m: Computes inputs for plotting the loss function for different parameter values (by simulation).

Auxiliary files
---------------

1. sim_shocks.m: Simulates data for different panel data sizes (N, T) and parametric distribution
(Uniform, Normal, Student t, Log-Normal and Gaussian Mixture). This draws are fixed across iterations
while using SGD.
3. sgd_step.m: Different potential SGD updates (Vainilla, Momentum, RMSprop, Adam).
4. plot_config.m: Set up default config for plots.
