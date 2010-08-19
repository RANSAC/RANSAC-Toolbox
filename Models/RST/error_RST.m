function [E T_noise_squared d] = error_line(Theta, X, sigma, P_inlier)

% [E T_noise_squared d] = error_line(Theta, X, sigma, P_inlier)
%
% DESC:
% estimate the squared symmetric transfer error due to the RST 
% constraint
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% Theta             = homography parameter vector
% X                 = samples on the manifold
% sigma             = noise std
% P_inlier          = Chi squared probability threshold for inliers
%                     If 0 then use directly sigma.
%
% OUTPUT:
% E                 = squared symmetric reprojection error 
% T_noise_squared   = squared noise threshold
% d                 = degrees of freedom of the error distribution

% HISTORY
%
% 1.0.0             - 27/08/06 initial version

% compute the squared symmetric reprojection error
E = [];
if ~isempty(Theta) && ~isempty(X)
        
    X12(1, :) = Theta(1)*X(1, :) - Theta(2)*X(2, :) + Theta(3);
    X12(2, :) = Theta(2)*X(1, :) + Theta(1)*X(2, :) + Theta(4);

    det = Theta(1)*Theta(1)+Theta(2)*Theta(2);
    dx = X(3, :) - Theta(3);
    dy = X(4, :) - Theta(4);
    X21(1, :) = ( Theta(1)*dx + Theta(2)*dy)/det;
    X21(2, :) = (-Theta(2)*dx + Theta(1)*dy)/det;
    
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