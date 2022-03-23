function [theta, stats] = AMM_OLS(data, p)

%===============================================================================
%
% [out, stats] = AMM(p, data)
%
% Computes the GAN estimator with a Logit discriminator.
%
% 1. Model:
%        - Generates data accoring to the same function as true data.
%        - Can allow for misspecification if a different distribution is
%          chosen.
%        - If true sample size is different than simulated, bootstrap data
%          to match it (preserve MLE)
% 2. Gradient descent:
%        - Different SGD schemes available (Vainilla, Momentum, RMSprop, Adam)
%        - Parameter space is bounded, but shouldn't be binding when using
%          GMM estimate as initial guess.

%===============================================================================

% Supress warnings from Logit fit / iteration limit
warning('off', 'stats:glmfit:PerfectSeparation');
warning('off', 'stats:glmfit:IterationLimit');

%-------------------------------------------------------------------------------

% Unpack
max_iter = p.max_iter;
noise = p.noise;
par = p.par0;
N = p.N;

Ns = length(noise);

%------------------------------------

% Boundaries
lim = 0.02;       % Bound D's predicted probabilities
par_min = -5;     % LB parameter space
par_max = 5;      % UB parameter space
hstep = 0.05;     % Parameter step size

% SGD scheme
% 0: Vainilla SGD / 1: Momentum / 2: RMSprop / 3: Adam
sgd.scheme = 3;

% SGD hyperparameters
sgd.eta = .01;    % Learning rate
sgd.eps = 1e-8;   % Correction for #DIV/0
sgd.g = .9;       % Momentum's exponential avg - Mean
sgd.b1 = .9;      % Adam's exponential avg - Mean
sgd.b2 = .999;    % Adam's exponential avg - Variance

%-------------------------------------------------------------------------------

% Storage
stats = cell(Ns, 1);
theta = zeros(Ns, 1);

Y   = [ones(N, 1); zeros(N, 1)];	% Label
eps = randn(N, 1);                  % Random deviations from 0

for i = 1:Ns
    
    loss_mat = zeros([max_iter, 1]);
    grad_mat = zeros([max_iter, 1]);
    par_mat  = zeros([max_iter, 1]);
    
    % Initialize
    iter = 1;
    m = 0; v = 0;
    grad_num = 1;
    
    mF = noise(i) * eps;

    while iter <= max_iter && abs(grad_num) > 1e-4
        
        sgd.iter = iter;
	    mT = get_moments(data, par);
    
        %-------------------------------------------------------------------------
        %-------------------   1. TRAIN THE DISCRIMINATOR   ----------------------
        %-------------------------------------------------------------------------
    
	    % Run logit discriminator
        X = [mT; mF];
        b = glmfit(X, Y, 'binomial', 'link', 'logit');
        Y_hat = glmval(b, X, 'logit');
        loss  = loss_fun([Y, Y_hat]);
    
	    %-------------------------------------------------------------------------
	    %------------------------  2.  GRADIENT SETUP    -------------------------
	    %-------------------------------------------------------------------------
    
        % Shifted parameters
	    parP = par + hstep;
	    parM = par - hstep;
        mTP = get_moments(data, parP);
        mTM = get_moments(data, parM);
        XFP = [mTP; mF];
        XFM = [mTM; mF];
    
        % Predicted probabilities (bounded)
        probP = glmval(b, XFP, 'logit');
	    probM = glmval(b, XFM, 'logit');
	    aux = [probP, probM];
	    aux = max(min(aux, 1-lim), lim);
    
        % Compute gradient by finite differences [ *(-1) for MIN]
	    mean_aux = mean(log(aux));
        grad_num = (mean_aux(1) - mean_aux(2)) / (2*hstep);
        
        % Correction to avoid SGD getting stuck
        iter0 = 0;
        while loss > -.5 && abs(grad_num) < .05
            iter0 = iter0 + 1;
            parP = par + (1 + iter0/10) * hstep;
		    parM = par - (1 + iter0/10) * hstep;
            mTP = get_moments(data, parP);
            mTM = get_moments(data, parM);
            XP(1:N, :) = mTP;
            XM(1:N, :) = mTM;

            % Predicted probabilities (bounded)
	        probP = glmval(b, XP, 'logit');
		    probM = glmval(b, XM, 'logit');
		    aux = [probP, probM];
		    aux = max(min(aux, 1-lim), lim);
		
            % Compute gradient by finite differences
            mean_aux = mean(log(aux));
            grad_num = (mean_aux(1) - mean_aux(2)) / (2*hstep);
        end
        
	    %-------------------------------------------------------------------------
	    %------------------------  3.  UPDATING STEP    --------------------------
	    %-------------------------------------------------------------------------
    
        if iter == 1
            step = sgd.eta .* grad_num;
        end
    
        [update, step, v, m] = sgd_step(par, grad_num, step, v, m, sgd);
    
        % Bound parameter update
        par = min(max(update, par_min), par_max);
    
        % Gather results
        par_mat(iter)  = par;
        grad_mat(iter) = grad_num;
        loss_mat(iter) = loss;
    
        iter = iter + 1;
    end
    
    % Find min(D)
    loc = find(loss_mat == min(loss_mat), 1);
    theta(i) = par_mat(loc);
    stats{i} = [par_mat, grad_mat, loss_mat];
end

end
