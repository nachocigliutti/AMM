clear;

rng(1005)
hpc = 0;

if hpc == 0
    cd('/Users/nacho/Dropbox/AMM/MATLAB/1_ols')
else 
    % Directory for HPC
    cd('/scratch/ic985')
    addpath(strcat(cd, '/compecon/'));
end

addpath(strcat(cd, '/utils/'))
respath = strcat(cd, '/results/');

%--------------------------------------------------------------------------

% 1. SETUP
%---------

N = [100; 200; 500];       % Sample size
D = [3; 4; 5];             % Distributions
S = 500;                   % Simulations

max_iter = 600;		       % For AMM optimization
tau = 1;				   % Ratio between true/synth data
boot = 0;                  % Bootstrap data?

grid = gridmake(N, D);
ntot = size(grid, 1);
nN = length(N);
nD = length(D);

NN = grid(:, 1);
DD = grid(:, 2);

names = {'Uniform', 'Exponential', 'Normal', ...
          'Student t', 'Log-Normal', 'Gaussian Mixture'};

% Results
output = cell([ntot, 1]);
stats  = cell([ntot, 1]);
lambda = cell([ntot, 1]);   % D's coefficients

%--------------------------------------------------------------------------

% 2. SIMULATIONS
%--------------

for i = 1:ntot
    
    p = struct;

    % Fixed across experiments
    p.max_iter = max_iter;
    p.parT = 1;
    p.parF = 0;
    p.tau = tau;
    p.boot = boot;
    p.S = S;
	
    % Setup
    p.N = NN(i);
	p.M = p.N/tau;
    p.dT = DD(i);
    p.dF = 3;          % Restrict to Normal distribution

    % Run experiments
    fprintf('\n')
    fprintf('Exercise # %.0f/%.0f \n', i, ntot);
    fprintf('Simulations = %.0f \n', p.S);
    fprintf('(N, T) = (%.0f, %.0f) \n', p.N, p.T);
    fprintf('Distribution = %s \n', names{p.dT});
    fprintf('N/M ratio = %.2f \n', p.tau);
    % fprintf('Distribution (F) = %s \n', Dnames{p.dF});
    
    tic
    [output{i}, stats{i}, lambda{i}] = estimate(p);
    toc

    RES = array2table(round(output{i}, 3), ...
    'RowNames', {'GMM-1', 'GMM-2', 'GMM-IT', 'GMM-CU', 'SMM', 'SMM-2', 'AMM'}, ...
    'VariableNames', {'Bias','STD', 'RMSE','p5', 'p20', 'p50', 'p80', 'p95'});

    fprintf('\n')
    disp(RES);
    disp('--------------------------------------------------------------------')
end

filename = strcat('AMM-AS96-tau2-miss', date);
%save(strcat(respath, filename));

%run('plots_AS.m')

