function [H A b] = affineLS(X1, X2, normalization)

% [H A b] = affineLS(X1, X2, normalization)
%
% DESC:
% computes the affine transformation between the point pairs X1, X2
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
% H             = homography representing the affine transformation
% A             = 4x4 affine coefficient matrix
% b             = affine translation vector


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2010 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU GPL.
% Please refer to the files COPYING.txt for more information.


% HISTORY
% 1.0.0         11/22/10 - intial version

if (nargin < 3)
    normalization = true;
end;

N = size(X1, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% checks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (size(X2, 2) ~= N)
    error('AffineLS:inputError', ...
        'The set of input points should have the same cardinality')
end;
if N < 2
    error('AffineLS:inputError', ...
        'At least 3 point correspondences are needed')
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalize the input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if normalization
    % fprintf('\nNormalizing...')
    [X1, T1] = normalize_points(X1);
    [X2, T2] = normalize_points(X2);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Traditional LS
P = zeros(2*N, 6);
q = zeros(2*N, 1);

ind = 1:2;
for n = 1:N
    
    P(ind, :) = [X1(1,n) 0 X1(2,n) 0 1 0; 0 X1(1,n) 0 X1(2,n) 0 1];
    
    q(ind) = X2(1:2, n);
    
    ind = ind + 2;
    
end;

% solve the linear system in a least square sense
Theta = P\q;

% compute the corresponding homography
H = [Theta(1) Theta(3) Theta(5); Theta(2) Theta(4) Theta(6); 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% de-normalize the parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if normalization
    H = T2\H*T1;
end;
H = H/H(9);

% prepare the output
if nargout > 1
    
    A = H(1:2, 1:2);
    b = H(1:2, 3);
    
end;

return