function [Theta, k] = estimate_homography(X, s)

% [Theta k] = estimate_homography(X, s)
%
% DESC:
% estimate the parameters of an homography using the normalized
% DLT algorithm. Note that Theta = H(:)
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.1
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
% 1.0.0             = ??/??/05 - initial version
% 1.0.1             = 27/08/08 - minor improvements

% cardinality of the MSS
k = 4;

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
    error('estimate_homography:inputError', ...
        'At least 4 point correspondences are required');
end;

H = HomographyDLT(X(1:2, :), X(3:4, :));
Theta = H(:);

return;
