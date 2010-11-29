function [E T_noise_squared d] = error_plane(Theta, X, sigma, P_inlier)

% [E T_noise_squared d] = error_plane(Theta, X, sigma, P_inlier)
%
% DESC:
% estimate the squared fitting error for a plane expresed in cartesian form
%
% a*x1+b*y1+c*z1+d = 0
% a*x2+b*y2+c*z2+d = 0
% a*x3+b*y3+c*z3+d = 0
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.1
%
% INPUT:
% Theta             = plane parameter vector
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
% 1.0.0             - 07/05/08 initial version
% 1.0.1             - 02/22/09 updated error threshold

% compute the squared error
E = [];
if ~isempty(Theta) && ~isempty(X)
    
    den = Theta(1)^2 + Theta(2)^2 + Theta(3)^2;
    
    E = ( ...
        Theta(1)*X(1,:) + ...
        Theta(2)*X(2,:) + ...
        Theta(3)*X(3,:) + ...
        Theta(4)...
        ).^2 / den;
                
end;

% compute the error threshold
if (nargout > 1)
    
    if (P_inlier == 0)
        T_noise_squared = sigma;
    else
        % Assumes the errors are normally distributed. Hence the sum of
        % their squares is Chi distributed (with 3 DOF since we are 
        % computing the distance of a 3D point to a plane)
        d = 3;
        
        % compute the inverse probability
        T_noise_squared = sigma^2 * chi2inv_LUT(P_inlier, d);

    end;
    
end;

return;
