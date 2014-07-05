function [Theta, k] = estimate_foo(X, s, parameters)

% [Theta k] = estimate_foo(X, s)
%
% DESC:
% Template for the estimation function to be used inside RANSAC
%
% INPUT:
% X                 = 2D point correspondences
% s                 = indices of the points used to estimate the 
%                     parameter vector. If empty all the points 
%                     are used
% parameters        = a structure of parameters to be used by the function
%
% OUTPUT:
% Theta             = estimated parameter vector Theta = H(:). If  
%                     the estimation is not successful return an 
%                     empty vector. i.e. Theta = [];
% k                 = dimension of the minimal subset

% here we define the size of the MSS
k = ;

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

% call the estimation function foo
Theta = foo(X, parameters);

% here you may want to check if the results are meaningful.
% If not return an empty vector

return;
