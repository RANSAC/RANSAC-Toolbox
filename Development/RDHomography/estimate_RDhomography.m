function [Theta, k] = estimate_RDhomography(X, s)

% [Theta k] = estimate_RDhomography(X, s)
%
% DESC:
% estimate the parameters of an homography using the normalized
% DLT algorithm. Note that Theta = H(:)
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% X                 = 2D point correspondences
% s                 = indices of the points used to estimate the parameter
%                     vector. If empty all the points are used
%
% OUTPUT:
% Theta             = estimated parameter vector Theta = H(:)
% k                 = dimension of the minimal subset

% HISTORY:
% 1.0.0             = 09/16/09 - initial version


% cardinality of the MSS
k = 5;

if (nargin == 0) || isempty(X)
    Theta = [];
    return;
end;

if (nargin == 2) && ~isempty(s)
    X = X(:, s);
end;
    
% check if we have enough points
N = size(X, 2);
if (N < k)
    error('estimate_RDhomography:inputError', ...
        'At least 4 point correspondences are required');
end;

X1 = X(1:2, :);
X2 = X(3:4, :);

while true
    
    % estimate the parameters of the homography
    H = HomographyDLT(X1, X2);
    
    % estimate the radial distortion parameters
    X2u = homo2cart(H * cart2homo(X1));
    a = X2 - X2u;
    n1 = X2u(1, :).^2+X2u(2, :).^2;
    kappa2 = mean( [a(1, :)./(n1.*X2u(1,:)) a(2, :)./(n1.*X2u(2,:))] );
        
    X1u = homo2cart(H \ cart2homo(X2));
    a = X1 - X1u;
    n2 = X1u(1, :).^2+X1u(2, :).^2;
    kappa1 = mean( [a(1, :)./(n2.*X1u(1,:)) a(2, :)./(n2.*X1u(2,:))] );
    
    % correct the point positon
    X1 = X1u + kappa1*repmat(n1,2,1).*X1u;
    X2 = X2u + kappa2*repmat(n2,2,1).*X2u;
    
    E = error_homography(H(:), [X1;X2]);
    sum(E)
end;

return;