function Q_cart = homo2cart(Q_homo)

% Q_cart = homo2cart(Q_homo)
%
% DESC:
% converts from cartesian coordinates to homegeneous ones
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
% 
% INPUT:
% Q_homo		= homogeneous coordinates of the points
%
% OUTPUT:
% Q_cart		= cartesian coordinates of the points


% HISTORY
% 1.0.0         - ??/??/01 - Initial version

l = size(Q_homo, 1);

% check if point or vector
if Q_homo(l) == 0
   Q_homo(l) = 1;
end;

Q_cart = Q_homo(1:l - 1, :)./repmat(Q_homo(l, :), [l-1, 1]);

return;
