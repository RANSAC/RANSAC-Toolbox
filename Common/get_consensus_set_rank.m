function r = get_consensus_set_rank(CS, E, mode, T_noise_squared)

% r = get_consensus_set_rank(CS, E, mode, T_noise_squared)
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
% T_noise_squared   = noise threshold to discriminate inliers vs outliers
%
% OUTPUT:
% r                 = consensus set rank

% HISTORY:
%
% 1.0.0             - 01/13/08 - Initial version
% 1.0.1             - 01/17/08 - Added different M-estimators
% 1.0.2             - 02/22/08 - Removed the M-estimators
%                                Added different ranking modes
% 1.0.3             - 05/26/14 - Removed MLESAC

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
        
    otherwise
        
        error('RANSACToolbox:optionError', 'Unknown ranking mode');
        
end

return
