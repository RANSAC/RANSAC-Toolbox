function [E, CS] = get_consensus_set(X, Theta_hat, T_noise_squared, man_fun, parameters)

% [E, CS] = get_consensus_set(X, Theta_hat, T_noise_squared, man_fun)
%
% DESC:
% select the consensus set for a given parameter vector.
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0
%
% INPUT:
% X                 = input data
% Theta_hat         = estimated parameter vector
% T_noise_squared   = noise threshold
% man_fun           = function that returns the residual error. Should
%                     be in the form of:
%
%                     Theta = man_fun(Theta, X)
% parameters        = the function parameters
%
%
% OUTPUT:
% E                 = error associated to each data element
% CS                = consensus set indicator vector

% HISTORY:
%
% 1.0.0             - ??/??/06 - Initial version
% 1.0.1             - 05/26/14 - Added support for the function parameters

% calculate the errors over the entire data set
if isempty(parameters)
    E = feval(man_fun, Theta_hat, X, [], []);
else
    E = feval(man_fun, Theta_hat, X, [], [], parameters);
end;

% find the points within the error threshold
CS = (E <= T_noise_squared);

return
