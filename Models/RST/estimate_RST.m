function [Theta, k] = estimate_RST(X, s)

% [Theta k] = estimate_RST(X, s)
%
% DESC:
% estimate the parameters of an RST trasformation via least squares.
% Note that Theta = [s*cos(phi); s*sin(phi); tx; ty] where:
% s         is the scaling factor
% phi       is the rotation angle
% tx, ty    is the translation
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
% Theta             = estimated parameter vector 
% k                 = dimension of the minimal subset

% HISTORY:
% 1.0.0             = 08/27/08 - initial version

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
    error('estimate_RST:inputError', ...
        'At least 2 point correspondences are required');
end;

H = RSTLS(X(1:2, :), X(3:4, :));
Theta = [H(1,1); H(2,1); H(1,3); H(2,3)];

return;