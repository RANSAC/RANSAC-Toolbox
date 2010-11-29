function r = get_consensus_set_rank(CS, E, mode, T_noise_squared, sigma, d)

% r = get_consensus_set_rank(CS, E, mode, T_noise_squared, sigma, d)
%
% DESC:
% get the rank of a consensus set 
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.2
%
% INPUT:
% CS                = logical array identifyng the CS
% E                 = error associated to each data element
% mode              = specify the type of ranking
%                     0 -> RANSAC (cardinality of the CS)
%                     1 -> MSAC 
%                     2 -> MLESAC 
% T_noise_squared   = noise threshold to discriminate inliers vs outliers
% sigma             = standard deviation of the inlier error (Gaussian
%                     distribution)
% d                 = degrees of freedom of the error distribution
%
% OUTPUT:
% r                 = consensus set rank

% HISTORY:
%
% 1.0.0             - 01/13/08 - Initial version
% 1.0.1             - 01/17/08 - Added different M-estimators
% 1.0.2             - 02/22/08 - Removed the M-estimators
%                                Added different ranking modes

N = length(CS);

switch mode

    case 'RANSAC'

        r = sum(CS);
        
    case 'MSAC'

        rho = E;
        rho(rho >= T_noise_squared) = T_noise_squared;
        
        % set to negative sothat also this rank is to be
        % maximized
        r = -sum(rho)/N;
        
    case 'MLESAC'
        
        % MLESAC
        % compute the cumulative sigma (assuming independece)
        sigmac_squared = d*sigma*sigma;
        p_i = exp( -0.5 * (E/sigmac_squared) ) / ...
            ( (2*pi*sigmac_squared)^(1/d) );
        
        Emax = max(E);
        p_o = ones(1, N) / Emax;
                        
        gamma = linspace(0, 1, 128);
        
        r = -inf;
        for h = 1:length(gamma)
            
            p = p_i*gamma(h) + p_o*(1-gamma(h));
            L_ast = sum( log(p) );
            
            if (r < L_ast)
                r = L_ast;
            end;
                
        end
        
    otherwise
        
        error('RANSACToolbox:optionError', 'Unknown ranking mode');
        
end

return
