function [Theta, k] = estimate_circle(X, s, parameters)

% [Theta k] = estimate_circle(X, s, parameters)
%
% DESC:
% Circle estimation give the radius. See:
% Gander, W., Golub, G. H., & Strebel, R. (1996). Least-squares fitting of 
% circles and ellipses. Bulletin of the Belgian Mathematical .
%
% INPUT:
% X                 = 2D point coordinates
% s                 = indices of the points used to estimate the 
%                     parameter vector. If empty all the points 
%                     are used
% parameters        = parameters.radius is the radius of the circle
%
% OUTPUT:
% Theta             = estimated parameter vector Theta = H(:). If  
%                     the estimation is not successful return an 
%                     empty vector. i.e. Theta = [];
% k                 = dimension of the minimal subset

% here we define the size of the MSS
k = 3;

% check if the input parameters are valid
if (nargin == 0) || isempty(X)
    Theta = [];
    return;
end;

% select the points to estimate the parameter vector
if (nargin >= 2) && ~isempty(s)
    X = X(:, s);
end;

% check if we have enough points
N = size(X, 2);
if (N < k)
    error('estimate_foo:inputError', ...
        'At least k point correspondences are required');
end;

x = transpose(X(1,:));
y = transpose(X(2,:));
r2 = parameters.radius^2;
H = [x y ones(N,1)];
z = 1-(x.^2+y.^2)/r2;
w = H\z;
Theta(1) = -0.5*r2*w(1);
Theta(2) = -0.5*r2*w(2);

return;
