function [xd yd] = mapping_homography(xs, ys, mode, Theta)

% [xd yd] = mapping_homography(xs, ys, mode, Theta)
%
% DESC:
% Apply the homography mapping to the source points (xs, ys)
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
% 1.0.0             - 11/28/08 - Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for the input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preliminary operations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = reshape(Theta, 3, 3);

xs = transpose(xs(:));
ys = transpose(ys(:));
Xs = [xs; ys];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mapping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mode
    % forward mapping
    Xd = homo2cart(H*cart2homo(Xs));
else
    % backward mapping
    Xd = homo2cart(H\cart2homo(Xs)); 
end;

% make sure the points are returned as row vectors
xd = Xd(1,:);
yd = Xd(2,:);

return;