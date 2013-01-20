function [s, Theta_hat, PROSAC_context] = get_minimal_sample_set_PROSAC(k, X, quality, est_fun, validateMSS_fun, ind_tabu, PROSAC_context)

% [s, Theta_hat, PROSAC_context] = get_minimal_sample_set_PROSAC(k, X, quality, est_fun, validateMSS_fun, ind_tabu, PROSAC_context)
%
% DESC:
% select the minimal sample set using the PROSAC sampling strategy: the
% MSS associated to large probability values are sampled first.
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% k                 = minimal sample set cardinality
% X                 = input data
% quality           = match quality (larger is better quality)
% est_fun           = function that estimates Theta. Should be in the form of:
%
%                     Theta = est_fun(X, s)
%
% validateMSS_fun   = function that validates a MSS. Should be in the form of:
%
%                     flag = validateMSS_foo(X, s)
%
% ind_tabu          = indices of elements excluded from the sample set
% PROSAC_context    = the context for PROSAC sampling. First time can be an
%                     empty array
%
% OUTPUT:
% s                 = minimal sample set
% Theta_hat         = estimated parameter vector on s
% PROSAC_context    = the updated PROSAC context

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 4
    est_fun = [];
end

if nargin < 5
    validateMSS_fun = [];
end

if nargin < 6
    ind_tabu = [];
end

if nargin < 7
    PROSAC_context = [];
end

if isempty(quality)
    error('RANSACToolbox:get_minimal_sample_set_PROSAC', ...
                'The quality vector cannot be empty');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Init PROSAC context
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = size(X, 2);
ind = 1:N;

% create the PROSAC context if it is empty (most likely because it is the 
% first time the sampling function is called)
if isempty(PROSAC_context)
    
    % remove tabu elements (if any)    
    if ~isempty(ind_tabu)
        ind = ind(~ind_tabu);
        quality = quality(~ind_tabu);
        N = length(ind);
        
        % check if we are left with enough elements for finding a MSS
        if (N < k)
            
            error('RANSACToolbox:get_minimal_sample_set_PROSAC', ...
                'Too few input input elements after removing tabu elements');
        end;
    end;
    
    % sort the quality measure. Make sure the matches with the highest
    % quality are at the right (i.e. for larger indices)
    [PROSAC_context.quality_sorted, PROSAC_context.ind_sorted] = sort(quality, 'ascend');
    
    % init the sampling mask
    [PROSAC_context.mask, PROSAC_context.r, PROSAC_context.q] = next_combination(k, false(1, N));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debug = true;

if debug
    %nMax = nchoosek(N, k);
    nMax = 10000;
    qMSSMin = zeros(1, nMax);
    qMSSMean = zeros(1, nMax);
    for n = 1:nMax
        % fetch the indices of the selected elements
        s = PROSAC_context.ind_sorted(PROSAC_context.mask);
        qMSSMin(n) = min(quality(s));
        qMSSMean(n) = mean(quality(s));
        
        % get the next combination in lexicographical order
        [PROSAC_context.mask, PROSAC_context.r, PROSAC_context.q] = next_combination(k, PROSAC_context.mask, PROSAC_context.r, PROSAC_context.q);
    end;
    
    figure;
    hold on
    plot(qMSSMin, 'b', 'LineWidth', 2)
    plot(qMSSMean, 'r', 'LineWidth', 1)
    xlabel('MSS s')
    ylabel('Bias')
    legend('min_{d \in MSS} \omega(d)', 'mean_{d \in MSS} \omega(d)')
    grid on
    
    
    keyboard
end

while true
    
    % fetch the indices of the selected elements
    s = PROSAC_context.ind_sorted(PROSAC_context.mask);
    
    % get the next combination in lexicographical order
    [PROSAC_context.mask, PROSAC_context.r, PROSAC_context.q] = next_combination(k, PROSAC_context.mask, PROSAC_context.r, PROSAC_context.q);

    % check if we are done
    if isempty(est_fun)
        Theta_hat = [];
        break;
    end;
    
    % validate the MSS
    if ~isempty(validateMSS_fun) && ~feval(validateMSS_fun, X, s)
        continue;
    end;
    
    % estimate the parameter and the residual error
    Theta_hat = feval(est_fun, X, s);
    
    % verify that the estimation produced something
    if ~isempty(Theta_hat)
        break;
    end;
    
end;

return