function [xn, T] = normalize_points(x)

% [xn, T] = normalize_points(x)
%
% DESC:
% normalize a set of points using the procedure described in the book by
% Hartley and Zisserman
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% x             = points to be normalized
%
% OUTPUT:
% Xn            = normalized set of points
% T             = transformation matrix such that Xn = T * X

% HISTORY
% 1.0.0         - ??/??/05 - Initial version

% compute the translation
x_bar = mean(x, 2);

% center the points
% faster than xc = x - repmat(x_bar, 1, size(x, 2));
xc(1, :) = x(1, :) - x_bar(1);
xc(2, :) = x(2, :) - x_bar(2);

% compute the average point distance
rho = sqrt(sum(xc.^2, 1));
rho_bar = mean(rho);

% compute the scale factor
s = sqrt(2)/rho_bar;

% scale the points
xn = s*xc;

% compute the transformation matrix
T = [s 0 -s*x_bar(1); 0 s -s*x_bar(2); 0 0 1];

return
