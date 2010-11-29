function [Theta, k] = estimate_plane(X, s)

% [Theta k] = estimate_plane(X)
%
% DESC:
% estimate the parameters of a 3D plane given the pairs [x, y, z]^T
% Theta = [a; b; c; d] where:
%
% a*x1+b*y1+c*z1+d = 0
% a*x2+b*y2+c*z2+d = 0
% a*x3+b*y3+c*z3+d = 0
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% X                 = 3D points 
% s                 = indices of the points used to estimate the parameter
%                     vector. If empty all the points are used
%
% OUTPUT:
% Theta             = estimated parameter vector Theta = [a; b; c; d]
% k                 = dimension of the minimal subset

% HISTORY:
% 1.0.0             = 07/05/08 - initial version

% cardinality of the MSS
k = 3;

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
    error('estimate_plane:inputError', ...
        'At least 3 points are required');
end;

A = [transpose(X(1, :)) transpose(X(2, :)) transpose(X(3, :)) ones(N, 1)];
[U S V] = svd(A);
Theta = V(:, 4);

return;
