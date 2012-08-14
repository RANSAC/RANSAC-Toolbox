function [E T_noise_squared d] = error_fundamental_matrix(Theta, X, sigma, P_inlier)

% [E T_noise_squared d] = error_fundamental_matrix(Theta, X, sigma, P_inlier)
%
% DESC:
% estimate the squared symmetric transfer error due to the homographic 
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
% E                 = squared symmetric transfer error 
% T_noise_squared   = squared noise threshold
% d                 = degrees of freedom of the error distribution

% HISTORY
%
% 1.0.0             - 08/09/12 initial version


% compute the squared symmetric reprojection error
E = [];
if ~isempty(Theta) && ~isempty(X)
        
    N = size(X, 2);

    % recover the fundamental matrix
    F = reshape(Theta, 3, 3);

    % recover the epipolar lines
    X1h = cart2homo(X(1:2, :));
    l1 = F*X1h;
    X2h = cart2homo(X(3:4, :));
    l2 = transpose(F)*X2h;

    % compute the point to line distance
    E1 = ( l1(1,:).*X(3,:) + l1(2,:).*X(4,:) + l1(3, :) ).^2 ./ ( l1(1,:).^2 + l1(2,:).^2 );
    E2 = ( l2(1,:).*X(1,:) + l2(2,:).*X(2,:) + l2(3, :) ).^2 ./ ( l2(1,:).^2 + l2(2,:).^2 );

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
