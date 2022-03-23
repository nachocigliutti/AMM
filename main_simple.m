clear;

rng(1005)

cd('/Users/nacho/Dropbox/AMM/MATLAB/1_ols')

addpath(strcat(cd, '/utils/'))
respath = strcat(cd, '/results/');

%-------------------------------------------------------------------------------
% 1. SETUP


N = 200; 		 % Sample size
S = 500;         % Simulations
max_iter = 200;	 % For AMM optimization

% Noise dispersion (simulated observations)
noise = [0; .05; .1; .5; 1];       

%--------------------------------------------------------------------------
% 2. SIMULATIONS

% Structure
p.max_iter = max_iter;
p.noise = noise;
p.parT = 1;
p.par0 = 0;
p.N = N;
p.S = S;

% Print
fprintf('\n')
fprintf('Simulations = %.0f, N = %.0f \n', p.S, p.N);

tic
[stats, res] = estimate(p);
toc

% Label AMM estimators
AMMcases = cell(length(noise), 1);
for i = 1:length(noise)
    AMMcases{i} = strcat('AMM-', num2str(100 * noise(i)));
end

rowN = [{'OLS'}, AMMcases(:)'];
varN = {'Bias','STD', 'RMSE','p5', 'p20', 'p50', 'p80', 'p95'};

% Print results
results = array2table(round(stats, 3), 'RowNames', rowN, 'VariableNames', varN);
fprintf('\n')
disp(results);

