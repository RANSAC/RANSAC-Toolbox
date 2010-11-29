function T_iter = get_iter_RANSAC(epsilon, q)

% T_iter = get_iter_RANSAC(epsilon, q)
%
% DESC:
% estimates the number of iterations for RANSAC
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0
%
% INPUT:
% epsilon           = false alarm rate
% q                 = probability
%
% OUTPUT:
% T_iter            = number of iterations

if (1 - q) > 1e-12
    T_iter = ceil( log(epsilon) / log(1 - q) );
else
    T_iter = 0;
end;

return
