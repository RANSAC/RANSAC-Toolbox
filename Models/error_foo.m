function [E, T_noise_squared, d] = error_foo(Theta, X, sigma, P_inlier, parameters)

% [E T_noise_squared d] = error_foo(Theta, X, sigma, P_inlier, parameters)
%
% DESC:
% Template to estimate the error due to the foo constraint. To
% return only the error threshold the function call should be:
%
% [dummy T_noise d] = error_foo([], [], sigma, P_inlier, parameters);
%
% INPUT:
% Theta             = foo parameter vector
% X                 = samples on the manifold
% sigma             = noise std
% P_inlier          = Chi squared probability threshold for inliers
%                     If 0 then use directly sigma.
% parameters        = the parameters used by the functions
%
% OUTPUT:
% E                 = squared error
% T_noise_squared   = squared noise threshold
% d                 = degrees of freedom of the error distribution

% compute the error obtained by the orthogonal projection of
% the data points X onto the model manifold instantiated with the
% parameters Theta
E = [];
if ~isempty(Theta) && ~isempty(X)

    % error computation

end;

% compute the error threshold
if (nargout > 1)

    if (P_inlier == 0)
        % in this case the parameter sigma coincides with the noise
        % threshold
        T_noise_squared = sigma;
    else
        % otherwise we compute the error threshold given the standard
        % deviation of the noise assuming that the errors are normally
        % distributed. Hence the sum of their squares is Chi2
        % distributed with d degrees of freedom
        d = ;

        % compute the inverse probability
        T_noise_squared = sigma^2 * chi2inv_LUT(P_inlier, d);

    end;

end;

return;
