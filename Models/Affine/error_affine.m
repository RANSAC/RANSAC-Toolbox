function [E T_noise_squared d] = error_affine(Theta, X, sigma, P_inlier)

% [E T_noise_squared d] = error_affine(Theta, X, sigma, P_inlier)
%
% DESC:
% estimate the squared symmetric transfer error due to the affine
% constraint
%
% VERSION:
% 1.0.0
%
% INPUT:
% Theta             = affine parameter vector
% X                 = samples on the manifold
% sigma             = noise std
% P_inlier          = Chi squared probability threshold for inliers
%                     If 0 then use directly sigma.
%
% OUTPUT:
% E                 = squared symmetric reprojection error
% T_noise_squared   = squared noise threshold
% d                 = degrees of freedom of the error distribution


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2009 by Marco Zuliani
%
% LICENSE:
% This toolbox is distributed under the terms of the GNU GPL.
% Please refer to the files COPYING.txt for more information.


% HISTORY
%
% 1.0.0             - 12/12/10 initial version

% compute the squared symmetric reprojection error
E = [];
if ~isempty(Theta) && ~isempty(X)

    N = size(X, 2);
    
    X12 = zeros(2, N);
    [X12(1, :) X12(2, :)] = mapping_affine(X(1, :), X(2, :), true, Theta);

    X21 = zeros(2, N);
    [X21(1, :) X21(2, :)] = mapping_affine(X(3, :), X(4, :), false, Theta);
    
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