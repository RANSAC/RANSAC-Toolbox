function [Theta, k] = estimate_line(X, s)

% [Theta k] = estimate_line(X, s)
%
% DESC:
% estimate the parameters of a 2D line given the pairs [x, y]^T
% Theta = [a; b; c] where a*x+b*yc = 0
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% X                 = 2D points 
% s                 = indices of the points used to estimate the parameter
%                     vector. If empty all the points are used
%
% OUTPUT:
% Theta             = estimated parameter vector Theta = [a; b; c]
% k                 = dimension of the minimal subset

% HISTORY:
% 1.0.0             = 01/26/08 - initial version

% cardinality of the MSS
k = 2;

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
    error('estimate_line:inputError', ...
        'At least 2 points are required');
end;

% compute the mean
mu = mean(X, 2);
% center the points
Xn = X - repmat(mu, 1, N);
    
% populate the matrix $A^TA = \left[ \begin{array}{cc}a & b\\b & c\end{array}\right]$
a = dot(Xn(1, :), Xn(1, :));
b = dot(Xn(1, :), Xn(2, :));
c = dot(Xn(2, :), Xn(2, :));

% Sacrifice accuracy for speed: compute the eigendecomposition of $A^TA$
alpha   = a+c;
temp    = a-c;
beta    = temp*temp;
gamma   = 4*b*b;
delta   = sqrt(beta + gamma);
lambda  = 0.5*(alpha+delta);
phi     = atan2(lambda-a,b);

% Get the eigenvector corresponding to the smallest eigenvalue
Theta(1,1) = -sin(phi);
Theta(2,1) = cos(phi);
Theta(3,1) = -Theta(1)*mu(1) - Theta(2)*mu(2);

return;
