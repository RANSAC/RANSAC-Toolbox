function [F A] = FundamentalMatrix8Points(X1, X2, normalization)

% [F A] = FundamentalMatrix8Points(X1, X2, normalization)
%
% DESC:
% computes the fundamental matrix using the point pairs X1, X2
% using the (normalized) 8 point algorithm
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% X1, X2        = point matches (cartesian coordinates)
% normalization = true (default) or false to enable/disable point 
%                 normalzation
%
% OUTPUT:
% H             = fundamental matrix
% A             = homogenous linear system matrix

% HISTORY
% 1.0.0         08/09/12 - intial version

if (nargin < 3)
    normalization = true;
end;

N = size(X1, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% checks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (size(X2, 2) ~= N)
    error('FundamentalMatrix8Points:inputError', ...
        'The set of input points should have the same cardinality')
end;
if N < 8
    error('FundamentalMatrix8Points:inputError', ...
        'At least 8 point correspondences are needed')
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalize the input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if normalization
    % see the wonderful paper "In Defence of the 8-point Algorithm" by
    % Richard I. Hartley
    [X1, T1] = normalize_points(X1);
    [X2, T2] = normalize_points(X2);
end;

% compute h
A = get_A(X1, X2);

[U S V] = svd(A);
F = reshape(V(:, 9), 3, 3);
    
% reshape the output
F_full_rank = reshape(F, 3, 3);

% enforce the rank constraint
[U S V] = svd(F_full_rank);
S(3,3) = 0;

F = U*S*transpose(V);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% de-normalize the parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if normalization
    F = transpose(T2)*F*T1;
end;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matrix construction routine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function A = get_A(X1, X2)

% see the tutorial by Marc Pollefeys
% http://www.cs.unc.edu/~marc/tutorial/node54.html

x1 = transpose(X1(1,:));
y1 = transpose(X1(2,:));
x2 = transpose(X2(1,:));
y2 = transpose(X2(2,:));

N = size(X1, 2);

A = zeros(N, 9);
A(:, 1) = x1.*x2;
A(:, 2) = x1.*y2;
A(:, 3) = x1;

A(:, 4) = y1.*x2;
A(:, 5) = y1.*y2;
A(:, 6) = y1;

A(:, 7) =     x2;
A(:, 8) =     y2;
A(:, 9) = 1;

return