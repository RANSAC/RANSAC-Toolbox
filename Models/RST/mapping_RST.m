function [xd yd] = mapping_RST(xs, ys, mode, Theta)

% [xd yd] = mapping_RST(xs, ys, mode, Theta)
%
% DESC:
% Apply the RST mapping to the source points (xs, ys)
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% xs, ys            = source points
% mode              = true for forward mapping, false for backward mapping
% Theta             = parameters of the mapping function
%   
% OUTPUT:
% xd, yd            = destination points
%
% SEE ALSO: imcanvas

% HISTORY
% 1.0.0             - 09/28/08 - Initial version
% 1.0.1             - 11/26/10 - Adapted for RANSAC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for the input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preliminary operations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recover translation
tx = Theta(3);
ty = Theta(4);

sC = Theta(1);
sS = Theta(2);

% recover scaling
s = sqrt(sC*sC + sS*sS);

C = sC / s;
S = sS / s;

xs = transpose(xs(:));
ys = transpose(ys(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mapping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mode
    % forward mapping
    xd = tx + s*(C*xs - S*ys);
    yd = ty + s*(S*xs + C*ys);
else
    % backward mapping
    dx = xs-tx;
    dy = ys-ty;
    xd = ( C*dx + S*dy)/s;
    yd = (-S*dx + C*dy)/s;
end;

% make sure the points are returned as row vectors
xd = transpose(xd(:));
yd = transpose(yd(:));

return;