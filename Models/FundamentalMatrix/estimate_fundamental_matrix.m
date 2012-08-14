function [Theta, k] = estimate_fundamental_matrix(X, s)

% [Theta k] = estimate_fundamental_matrix(X, s)
%
% DESC:
% estimate the fundamental matrix using the normalized 8 point
% algorithm. Note that Theta = F(:)
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
% Theta             = estimated parameter vector Theta = F(:)
% k                 = dimension of the minimal subset

% HISTORY:
% 1.0.0             = 08/09/12 - initial version

% cardinality of the MSS
k = 8;

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
    error('estimate_fundamental_matrix:inputError', ...
        'At least 8 point correspondences are required');
end;

F = FundamentalMatrix8Points(X(1:2, :), X(3:4, :));
Theta = F(:);

return;
