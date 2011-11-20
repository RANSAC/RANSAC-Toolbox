function [xd yd] = mapping_affine(xs, ys, mode, Theta)

% [xd yd] = mapping_affine(xs, ys, mode, Theta)
%
% DESC:
% Apply the affine mapping to the source points (xs, ys)
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
a11 = Theta(1);
a21 = Theta(2);

a12 = Theta(3);
a22 = Theta(4);

b1 = Theta(5);
b2 = Theta(6);

xs = transpose(xs(:));
ys = transpose(ys(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mapping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mode
    % forward mapping
    xd = b1 + a11*xs + a12*ys;
    yd = b2 + a21*xs + a22*ys;
else
    % backward mapping
    dx = xs-b1;
    dy = ys-b2;
    det = a11*a22 - a12*a21;
    xd = ( a22*dx - a12*dy)/det;
    yd = (-a21*dx + a11*dy)/det;
end;

% make sure the points are returned as row vectors
xd = transpose(xd(:));
yd = transpose(yd(:));

return;