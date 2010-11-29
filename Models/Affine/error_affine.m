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
% 1.0.0             - 27/08/06 initial version

% compute the squared symmetric reprojection error
E = [];
if ~isempty(Theta) && ~isempty(X)
    
    X12(1, :) = Theta(1)*X(1, :) + Theta(3)*X(2, :) + Theta(5);
    X12(2, :) = Theta(2)*X(1, :) + Theta(4)*X(2, :) + Theta(6);
    
    det = Theta(1)*Theta(4)-Theta(2)*Theta(3);
    dy = Theta(6) - X(4, :);
    X21(1, :) =  (dy*Theta(3) - Theta(4)*Theta(5) + Theta(4)*X(3, :))/det;
    X21(2, :) = -(dy*Theta(1) - Theta(2)*Theta(5) + Theta(2)*X(3, :))/det;
    
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