function [results, options] = RANSAC(X, options)

% [results, options] = RANSAC(X, options)
%
% DESC:
% estimate the vector of parameters Theta using RANSAC (see source [1],
% [2])
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.1.5
%
% INPUT:
%
% X                 = input data. The data id provided as a matrix that has
%                     dimensions 2dxN where d is the data dimensionality
%                     and N is the number of elements
%
% options           = structure containing the following fields:
%
%   sigma               = noise std
%   P_inlier            = Chi squared probability threshold for inliers
%                         (i.e. the probability that an point whose squared
%                          error is less than T_noise_squared is an inlier)
%                         (default = 0.99)
%   T_noise_squared     = Error threshold (overrides sigma)
%   epsilon             = False Alarm Rate (i.e. the probability we never
%                         pick a good minimal sample set) (default = 1e-3)
%   Ps                  = sampling probability ( 1 x size(X, 2) )
%                         (default: uniform, i.e. Ps is empty)
%   ind_tabu            = logical array indicating the elements that should
%                         not be considered to construct the MSS (default
%                         is empty)
%   validateMSS_fun     = function that validates a MSS
%                         Should be in the form of:
%
%                         flag = validateMSS_foo(X, s)
%
%   validateTheta_fun   = function that validates a parameter vector
%                         Should be in the form of:
%
%                         flag = validateTheta_foo(X, Theta, s)
%
%   est_fun             = function that estimates Theta.
%                         Should be in the form of:
%
%                         [Theta k] = estimate_foo(X, s)
%
%   man_fun             = function that returns the residual error.
%                         Should be in the form of:
%
%                         [E T_noise_squared] = man_fun(Theta, X)
%
%   parameters          = a structure that is passed to all the estimation,
%                         validation and error functions containing data to
%                         be used by such functions (e.g. parameters.alpha)
%
%   mode                = algorithm flavour
%                         'RANSAC'  -> Fischler & Bolles
%                         'MSAC'    -> Torr & Zisserman
%
%
%   max_iters           = maximum number of iterations  (default = inf)
%   min_iters           = minimum number of iterations  (default = 0)
%   max_no_updates      = maximum number of iterations with no updates
%                         (default = inf)
%   fix_seed            = true to fix the seed of the random number
%                         generator so that the results on the same data
%                         set are repeatable (default = false)
%   reestimate          = true to resestimate the parameter vector using
%                         all the detected inliers
%                         (default = false)
%   verbose             = true for verbose output
%                         (default = true)
%   notify_iters        = if verbose output is on then print some
%                         information every notify_iters iterations.
%                         If empty information is displayed only for
%                         updates (default = [])
%
% OUTPUT:
%
% results           = structure containing the following fields:
%
%   Theta               = estimated parameter vector
%   E                   = fitting error obtained from man_fun
%   CS                  = consensus set (true -> inliers, false -> outliers)
%   r                   = rank of the solution
%   iter                = number of iterations
%   time                = time to perform the computation
%
% options           = options (including the defaults set by the algorithm)
%
% SEE ALSO:             SetPathLocal

% HISTORY:
%
% 1.1.0         - 01/12/08 - New packaging and some updates
% 1.1.1         - 01/17/08 - Fixed a bug to set the max muber of iterations
%                          - Added notify option
% 1.1.2         - 04/11/08 - Fixed a couple of minor bugs.
%                          - Initialization and check on the cardinality of
%                            the MSS
% 1.1.3         - 06/25/08 - Changed the interface for est_fun and man_fun
%                            so that the sets are specified as arguments
%                          - Added ind_tabu option
%                          - Added optional random seed fixation
%                          - stabilization procedure (beta version)
% 1.1.4         - 09/13/08 - Added validation functions
% 1.1.5         - 09/13/08 - Added time in the results
% 1.1.6         - 05/26/14 - Added parmeters support

% REFERENCES:
%
% [1] @ARTICLE{Fischler81,
% AUTHOR =       "M. A. Fischler and R. C. Bolles",
% TITLE =        "Random Sample Consensus: A Paradigm for Model Fitting with Applications to Image Analysis and Automated Cartography",
% JOURNAL =      "Communications of the ACM",
% YEAR =         "1981",
% volume =       "24",
% pages =        "381--395",
% }
%
% [2] @ARTICLE{Torr00,
%   AUTHOR =       {P.H.S. Torr and A. Zisserman},
%   TITLE =        {{MLESAC}: A New Robust Estimator with Application to Estimating Image Geometry},
%   JOURNAL =      {Journal of Computer Vision and Image Understanding},
%   YEAR =         {2000},
%   volume =       {78},
%   number =       {1},
%   pages =        {138ó-156},
% }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the parameters
if ~isfield(options, 'stabilize')
    options.stabilize = false;
end;

if ~isfield(options, 'sigma') && ~isfield(options, 'T_noise_squared')
    error('RANSACToolbox:optionError', 'Either the option field sigma or T_noise_squared must be specified by the user');
end;

if ~isfield(options, 'est_fun')
    error('RANSACToolbox:optionError', 'Estimation function not specified');
end;

if ~isfield(options, 'man_fun')
    error('RANSACToolbox:optionError', 'Manifold function not specified');
end;

if ~isfield(options, 'validateMSS_fun')
    options.validateMSS_fun = [];
end;

if ~isfield(options, 'validateTheta_fun')
    options.validateTheta_fun = [];
end;

if ~isfield(options, 'parameters')
    options.parameters = [];
end;

if ~isfield(options, 'ind_tabu')
    options.ind_tabu = [];
end;

if ~isfield(options, 'epsilon')
    options.epsilon = 1e-3;
end;

if ~isfield(options, 'mode')
    options.mode = 'MSAC';
end;

if ~isfield(options, 'P_inlier')
    options.P_inlier = 0.99;
end;

if ~isfield(options, 'max_iters')
    options.max_iters = inf;
end;

if ~isfield(options, 'min_iters')
    options.min_iters = 0;
end;

if ~isfield(options, 'max_no_updates')
    options.max_no_updates = inf;
end;

if ~isfield(options, 'fix_seed')
    options.fix_seed = false;
end;

if ~isfield(options, 'reestimate')
    options.reestimate = false;
end;

if ~isfield(options, 'verbose')
    options.verbose = true;
end;

if ~isfield(options, 'notify_iters')
    options.notify_iters = [];
end;

if ~isfield(options, 'Ps')
    options.Ps = [];
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initializations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (options.verbose)
    fprintf('\nStarting RANSAC');
    if (options.fix_seed)
        fprintf(' [random number generator seed is fixed]');
    end;
end;

% start timer
tic;

% get minimal subset size and model codimension
if isempty(options.parameters)
    [~, k] = feval(options.est_fun, [], []);
else
    [~, k] = feval(options.est_fun, [], [], options.parameters);
end
if (options.verbose)
    fprintf('\nMinimal sample set dimension = %d', k);
end;

% total number of elements
N = size(X, 2);

% exit if the number of points is smaller than the cardinality of a MSS
if (N < k)

    results.Theta = [];
    results.E = [];
    results.CS = [];
    results.iter = 0;

    warning('RANSACToolbox:dataSetTooSmall', 'The input data set is composed by too few elements.')

    return;
end

% calculate the probability for the inlier detection.
if ~isfield(options, 'T_noise_squared')
    % get the noise threshold via Chi squared distribution
    if isempty(options.parameters)
        [~, T_noise_squared, d] = feval(options.man_fun, [], [], options.sigma, options.P_inlier);
    else
        [~, T_noise_squared, d] = feval(options.man_fun, [], [], options.sigma, options.P_inlier, options.parameters);
    end;

    options.T_noise_squared = T_noise_squared;
    if (options.verbose)
        fprintf('\nSquared noise threshold = %f, (assuming Gaussian noise, for sigma = %f)', T_noise_squared, options.sigma);
    end;
else
    % set a hard noise threshold
    T_noise_squared = options.T_noise_squared;
    if (options.verbose)
        fprintf('\nSquared noise threshold = %f', T_noise_squared);
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Randomization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~(options.fix_seed)
    seed = sum(100*clock);
else
    seed = 2222;
end;

rand('twister', seed);
randn('state', seed);

global RANSAC_SEED;
RANSAC_SEED = seed;

global RANSAC_SEED_UPDATED;
if (options.fix_seed)
    RANSAC_SEED_UPDATED = RANSAC_SEED;
else
    RANSAC_SEED_UPDATED = [];
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some initializations
N_I_star = 0; % k
r_star = -inf;
CS_star = false(1, N);
ind_CS_star = [];
Theta_star = [];
% number of iterations
iter = 0;
% threshold on the number of iterations
T_iter = options.max_iters;
% number of iterations with no updates
no_updates = 0;

while (...
        (iter <= options.min_iters) || ...
        ( (iter <= T_iter) && (iter <= options.max_iters) && (no_updates <= options.max_no_updates) ) ...
        )

    % update the number of iterations
    iter = iter + 1;

    % initialize flags
    if ~isempty(options.notify_iters) && (mod(iter, options.notify_iters) == 0);
        notify = true;
    else
        notify = false;
    end;

    update_sets = false;
    update_T_iter = false;

    % Hypothesize ---------------------------------------------------------

    % select MSS
    if isempty(options.parameters)
        [MSS, Theta] = get_minimal_sample_set(k, X, options.Ps, options.est_fun, options.validateMSS_fun, options.ind_tabu);
    else
        [MSS, Theta] = get_minimal_sample_set(k, X, options.Ps, options.est_fun, options.validateMSS_fun, options.ind_tabu, options.parameters);
    end

    % validate the parameter vector Theta
    if ~isempty(options.validateTheta_fun) && ~feval(options.validateTheta_fun, X, Theta, MSS, options.parameters)
        continue;
    end;

    % Test ----------------------------------------------------------------

    % find the CS
    [E, CS] = get_consensus_set(X, Theta, T_noise_squared, options.man_fun, options.parameters);

    % get the ranking of the CS
    r = get_consensus_set_rank(CS, E, options.mode, T_noise_squared);

    % get the indices
    ind_CS = find(CS);

    % get the estimated number of inliers
    N_I = length(ind_CS);

    % Update --------------------------------------------------------------

    % if we found a larger inlier set update both the inlier set and the
    % number of iterations
    if (N_I >= N_I_star) && (r > r_star)
        
        notify = true;
        r_star = r;

        update_sets = true;
        if (N_I > N_I_star)
            update_T_iter = true;
        end;
    
    end;

    % update the sets
    if update_sets

        Theta_star          = Theta;
        CS_star             = CS;
        E_star              = E;
        N_I_star            = N_I;
        ind_CS_star         = ind_CS;

        no_updates = 0;

    else

        no_updates = no_updates + 1;

    end;

    % update the number of iterations
    if update_T_iter

        q = get_q_RANSAC(N, N_I_star, k);

        if (q > eps)
            T_iter = get_iter_RANSAC(options.epsilon, q);
        end;

    end;

    if (options.verbose)

        if ( update_T_iter || update_sets || notify )

            fprintf('\nIteration = %5d/%9d. ', iter, T_iter);
            fprintf('Inliers = %6d/%6d (rank is r = %8.8f)', N_I_star, N, r_star);

        end;

    end;

    % if all the points have been assigned then exit the loop
    if (length(ind_CS_star) == N)
        break
    end;

end;

% Reestimation --------------------------------------------------------
if (options.reestimate)
    
    if (options.verbose)
        fprintf('\nRestimating the parameter vector... ')
    end;
    
    if isempty(options.parameters)
        Theta_star = feval(options.est_fun, X(:, CS_star), []);
    else
        Theta_star = feval(options.est_fun, X(:, CS_star), [], options.parameters);
    end;
    
    [E_star, CS_star] = get_consensus_set(X, Theta_star, T_noise_squared, options.man_fun, options.parameters);
    r_star = get_consensus_set_rank(CS_star, E_star, options.mode, T_noise_squared);
    
    if (options.verbose)
        fprintf('Done')
    end;
    
end;

% save the results
results.Theta = Theta_star;
results.E = E_star;
results.CS = CS_star;
results.T_noise_squared = T_noise_squared;
results.r = r_star;

% perform stabilization
if (options.stabilize)
    results = stabilize(X, results, options);
end

if (options.verbose)
    fprintf('\nFinal number of inliers = %d/%d', sum(results.CS), N);
end;

results.time = toc;
if (options.verbose)
    fprintf('\nConverged in %d iterations (%f seconds)\n', iter, results.time);
end;

return;
