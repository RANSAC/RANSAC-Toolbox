function Theta = estimate_line_ML(X, s, sigma, mode)

% Theta = estimate_line_ML(X, s, signa, mode)
%
% DESC:
% estimate the parameters of a 2D line given the pairs [x, y]^T
% Theta = [a; b; c] where a*x+b*yc = 0. Uses the maximum likelihood
% criterion (non linear optimization involved).
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
% Christina Kumor - ckumor@hotmail.com
%
% VERSION:
% 1.0.1
%
% INPUT:
% X                 = 2D points
% s                 = indices of the points used to estimate the parameter
%                     vector. If empty all the points are used
% sigma             = noise scale factor (default 1.0)
% mode              = type of the M-estimator (default 0):
%                     0 = least squares (sigma is the std of the noise):
%                                          2
%                                         x
%                             rho = 1/2 ------
%                                            2
%                                       sigma
%                     1 = Cauchy-Lorentz (according to Kry Crunchy-Lorentz)
%                         (sigma is the noise scale for the distribution)
%
%                                              2
%                                             x
%                         rho = log(1 + 1/2 ------)
%                                                2
%                                           sigma
%
% OUTPUT:
% Theta             = estimated parameter vector Theta = [a; b; c]

% HISTORY:
% 1.0.0             = 03/28/09 - initial version
% 1.0.1             = 06/21/09 - Added check for the optimization toolbox

% parameter checking
if (nargin < 2) || isempty(s)
    s = 1:size(X,2);
end;

if nargin < 3
    sigma = 1;
end;

if nargin < 4
    mode = 0;
end;

% select the appropriate estimator
switch mode
    case 0
        % M-estimator for Gaussian distribution
        rho = @(x)( 0.5*(x/sigma).^2 );
        Drho = @(x)( x/sigma^2 );
    case 1
        % M-estimator for Cauchy-Lorentz distribution
        rho = @(x)( log( 1 + 0.5*(x/sigma).^2 ) );
        Drho = @(x)( (x/sigma^2)./(1+0.5*(x/sigma).^2) );
    otherwise
        error('RANSACToolbox:estimate_line_ML', 'Unknown estimator mode');
end;

% initialize the starting point for the descent
Theta0 = estimate_line(X, s);

try

    % set the optimization options
    options = optimset(...
        'Jacobian', 'on',...
        'Display', 'iter' );

    % perform the descent
    Theta0 = double(Theta0);
    X = double(X);

    [Theta, resnorm, residual, exitflag, output] = ...
        lsqnonlin(@compute_F, Theta0, [], [], options, X(:, s), rho, Drho);

catch
    error('RANSACToolbox:estimate_line_ML', ...
        'Something went wrong with the nonlinear optimization. Make sure you have the optimization toolbox.');
end;

return

function [F, J] = compute_F(Theta, X, rho, Drho)

den = sqrt( Theta(1)^2 + Theta(2)^2 );
E = ( Theta(1)*X(1,:) + Theta(2)*X(2,:) + Theta(3) ) / den;

F = rho(E);

% Two output arguments: compute also the Jacobian
if nargout > 1

    N = size(X, 2);
    J = zeros(N, 3);

    temp = Drho(E);

    J(:, 1) = temp(:) .* ( transpose(X(1, :))/den(:) - Theta(1)/den(:).*E(:) );
    J(:, 2) = temp(:) .* ( transpose(X(2, :))/den(:) - Theta(2)/den(:).*E(:) );
    J(:, 3) = temp(:) .* 1/den(:);

end

return
