function [E T_noise_squared d] = error_homography(Theta, X, sigma, P_inlier)

% [E T_noise_squared d] = error_homography(Theta, X, sigma, P_inlier)
%
% DESC:
% estimate the squared symmetric transfer error due to the homographic 
% constraint
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.1
%
% INPUT:
% Theta             = homography parameter vector
% X                 = samples on the manifold
% sigma             = noise std
% P_inlier          = Chi squared probability threshold for inliers
%                     If 0 then use directly sigma.
%
% OUTPUT:
% E                 = squared symmetric transfer error 
% T_noise_squared   = squared noise threshold
% d                 = degrees of freedom of the error distribution

% HISTORY
%
% 1.0.0             - 11/18/06 initial version
% 1.0.1             - 02/22/09 updated error threshold


% compute the squared symmetric reprojection error
E = [];
if ~isempty(Theta) && ~isempty(X)
        
    N = size(X, 2);

    X12 = zeros(2, N);
    [X12(1, :) X12(2, :)] = mapping_homography(X(1,:), X(2,:), true, Theta);

    X21 = zeros(2, N);
    [X21(1, :) X21(2, :)] = mapping_homography(X(3,:), X(4,:), false, Theta);
    
    E1 = sum((X(1:2, :)-X21).^2, 1);
    E2 = sum((X(3:4, :)-X12).^2, 1);
    
    E = E1 + E2;
end;

% compute the error threshold
if (nargout > 1)
    
    if (P_inlier == 0)
        T_noise_squared = sigma;
    else
        % Assumes the errors are normally distributed. Hence the sum of
        % their squares is Chi distributed (with 4 DOF since the symmetric 
        % distance contributes for two terms and the dimensionality is 2)
        d = 4;
        
        % compute the inverse probability
        T_noise_squared = sigma^2 * chi2inv_LUT(P_inlier, d);

    end;
    
end;

return;
