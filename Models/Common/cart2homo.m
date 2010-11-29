function Q_homo = cart2homo(Q_cart, lambda)

% Q_homo = cart2homo(Q_cart, lambda)
%
% DESC:
% converts from homegeneous coordinates to cartesian ones 
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.1
% 
% INPUT:
% Q_cart		= cartesian coordinates of the points
% lambda        = scale factor (optional)
%
% OUTPUT:
% Q_homo		= homogeneous coordinates of the points

% HISTORY
% 1.0.0         - ??/??/01 - Initial version

if nargin == 1
   lambda = 1;
end;

l = size(Q_cart, 1);
n = size(Q_cart, 2);

Q_homo = zeros(l + 1, n, class(Q_cart));
Q_homo(1:l, :) = (1 / lambda) * Q_cart(1:l, :);
Q_homo(l + 1, :) = lambda;

return;
