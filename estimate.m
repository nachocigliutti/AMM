function [stats, res] = estimate(p)

%===============================================================================
%
% function out = estimate(p)
%
% Estimates both GMM + AMM to compare finite sample properties.
%
%===============================================================================

Ns = length(p.noise);
theta = zeros([Ns + 1, p.S]);   % Estimators (OLS, AMM)

%-------------------------------------------------------------------------------
%---------------------------   BEGIN OPTIMIZATION   ----------------------------
%-------------------------------------------------------------------------------

parfor s = 1:p.S

		[Y, X] = get_data(p);
        dataT = [Y, X];

		% Estimation
		ols = X \ Y;
		[amm,res{s}] = AMM_OLS(dataT, p);

		theta(:, s) = [ols; amm];

end

stats = get_stats(theta, p.parT);

end
