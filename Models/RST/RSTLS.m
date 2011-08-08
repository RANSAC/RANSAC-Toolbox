function [H s phi T] = RSTLS(X1, X2, normalization)

% [H s phi T] = RSTLS(X1, X2, normalization)
%
% DESC:
% computes the RST transformation between the point pairs X1, X2
%
% VERSION:
% 1.0.1
%
% INPUT:
% X1, X2        = point matches (cartesian coordinates)
% normalization = true (default) or false to enable/disable point 
%                 normalzation
%
% OUTPUT:
% H             = homography representing the RST transformation
% s             = scaling
% phi           = rotation angle
% T             = translation vector


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2011 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU GPL.
% Please refer to the files COPYING.txt for more information.


% HISTORY
% 1.0.0         08/27/08 - intial version
% 1.0.1         06/09/09 - implemented closed form for the LS estimation
%                          routines

if (nargin < 3)
    normalization = true;
end;

N = size(X1, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% checks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (size(X2, 2) ~= N)
    error('RSTLS:inputError', ...
        'The set of input points should have the same cardinality')
end;
if N < 2
    error('RSTLS:inputError', ...
        'At least 2 point correspondences are needed')
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalize the input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (normalization) && (N > 2)
    % fprintf('\nNormalizing...')
    [X1, T1] = normalize_points(X1);
    [X2, T2] = normalize_points(X2);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (N == 2)
    
    % fast estimation
    Theta = zeros(4,1);
    
    % $\mbox{\texttt{MM}} \eqdef M_{:,1} = \vct{y}^{(1)}-\vct{y}^{(2)} = \left[\begin{array}{c} y_1^{(1)}-y_1^{(2)} \\ y_2^{(1)}-y_2^{(2)} \end{array}\right]$
    % 2 additions
    MM = X1(:,1) - X1(:,2);
    % $ \mbox{\texttt{detMM}} \eqdef |M|$
    % 1 additions, 2 multiplication
    detMM = MM(1)*MM(1) + MM(2)*MM(2);
    % $ \mbox{\texttt{MMi}} \eqdef \left[ \begin{array}{c} \left[M^{-1}\right]_{1,1} \\ -\left[M^{-1}\right]_{2,1}\end{array}\right]$
    % 2 multiplications
    MMi = MM / detMM;

    % $ \mbox{\texttt{Delta}} \eqdef \vct{T}_{\vct{\theta}} (\vct{y}^{(1)})-\vct{T}_{\vct{\theta}} (\vct{y}^{(2)})$
    % 2 additions
    Delta = X2(:,1) - X2(:,2);
    
    % $ \mbox{\texttt{Theta(1:2)}} = M^{-1}\left(\vct{T}_{\vct{\theta}} (\vct{y}^{(1)})-\vct{T}_{\vct{\theta}} (\vct{y}^{(2)})\right)$
    % 1 additions, 2 multiplications
    Theta(1) = MMi(1)*Delta(1) + MMi(2)*Delta(2);
    % 1 additions, 2 multiplications
    Theta(2) = MMi(1)*Delta(2) - MMi(2)*Delta(1);
    % $ \mbox{\texttt{Theta(3:4)}} = -S^{(2)}\vct{\theta}_{1:2}+\vct{T}_{\vct{\theta}} (\vct{y}^{(2)})$ 
    % 2 additions, 2 multiplications
    
    Theta(3) = X2(1,2) - Theta(1)*X1(1,2) + Theta(2)*X1(2,2);
    % 2 additions, 2 multiplications
    Theta(4) = X2(2,2) - Theta(1)*X1(2,2) - Theta(2)*X1(1,2);

    % total: 11 additions, 12 multiplications
else
    
    % Closed form LS solution. Using the tutorial notation.
    
    % Notation semplification:
    % $\vct{p}^{(i)} = \bar{\vct{y}}^{(i)}$ and $\vct{q}^{(i)} = \overline{\vct{T}_{\vct{\theta}} (\vct{y}^{(i)})}$
    % $a = \sum_{i=1}^N\left( (p_1^{(i)})^2 + (p_2^{(i)})^2 \right)$
    a = sum(X1(:).^2);
    
    % Explicit LS expansion:
    % $  \theta_1 = \frac{1}{a}\sum_{i=1}^N p_1^{(i)} q_1^{(i)} + p_2^{(i)} q_2^{(i)} $
    % $  \theta_2 = \frac{1}{a}\sum_{i=1}^N -p_2^{(i)} q_1^{(i)} + p_1^{(i)} q_2^{(i)} $
    % $  \theta_3 = 0 $
    % $  \theta_4 = 0 $
    Theta(1) = sum( X1(1, :).*X2(1, :) + X1(2, :).*X2(2, :) ) / a;
    Theta(2) = sum( -X1(2, :).*X2(1, :) + X1(1, :).*X2(2, :) ) / a;
    Theta(3) = 0;
    Theta(4) = 0;
    
    % Traditional LS
    %
    %     A = zeros(2*N, 4);
    %     b = zeros(2*N, 1);
    %
    %     ind = 1:2;
    %     for n = 1:N
    %
    %         A(ind, 1:2) = [X1(1,n) -X1(2,n); X1(2,n) X1(1,n)];
    %         A(ind, 3:4) = eye(2);
    %
    %         b(ind) = X2(1:2, n);
    %
    %         ind = ind + 2;
    %
    %     end;
    %
    %     % solve the linear system in a least square sense
    %     Theta = A\b;
    
end;

% compute the corresponding homography
H = [Theta(1) -Theta(2) Theta(3); Theta(2) Theta(1) Theta(4); 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% de-normalize the parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (normalization) && (N > 2)
    H = T2\H*T1;
end;
H = H/H(9);

% prepare the output
if nargout > 1
    
    s       = sqrt(H(1,1)*H(1,1) + H(2,1)*H(2,1));
    phi     = atan2(H(2,1), H(1,1));
    T       = H(1:2, 3);
    
end;

return
