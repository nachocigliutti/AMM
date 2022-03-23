clear;

rng(1005)

cd('/Users/nacho/Dropbox/AMM/MATLAB/1_ols')

addpath(strcat(cd, '/utils/'))
respath = strcat(cd, '/results/');

%-------------------------------------------------------------------------------
% 1. SETUP


N = 200; 				 % Sample size
S = 500; 				 % Replications
par = -1:.1:3;	 % Bounded parameter space
max_iter = 600;	 % For AMM optimization
sigma = [0, .5, 1, 2];  % Noise dispersion (simulated observations)

Nsigma = length(sigma);
Npar = length(par);

loss = zeros(Nsigma, Npar);

%--------------------------------------------------------------------------
% 2. COMPUTE LIKELIHOOD

% Structure
p.parT = 1;
p.N = N;

dataT = get_data(p);

Y = [ones(N, 1); zeros(N, 1)];	% Label
e = randn(N, S);								% Random deviations from 0

for i = 1:Nsigma

	MF = sigma(i) * e;

	for j = 1:Npar

		parfor k = 1:S
			mF = MF(:, k);
			mT = get_moments(dataT, par(j));

			% Run logit discriminator
	  	    X = [mT; mF];
	  	    b = glmfit(X, Y, 'binomial', 'link', 'logit');
	  	    Y_hat = glmval(b, X, 'logit');
	  	    loss(i, j, k) = loss_fun([Y, Y_hat]);
        end
    end
end

perc = prctile(loss, [10, 25, 50, 75, 90], 3);

% PLOTS
plot_config

for g = 1:4
    subplot(2, 2, g)
    plot(par, squeeze(perc(g, :, :)))
    ylabel('Loss')
    xlabel('$\beta$')
    title(strcat('Noise dispersion $\sigma = ', num2str(sigma(g)), '$'))
    legend('p10', 'p25', 'p50', 'p75', 'p90', 'Position',[.05 .45 .05 .15],'FontSize', 24)
end



