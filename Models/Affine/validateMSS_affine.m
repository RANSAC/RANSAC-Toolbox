function flag = validateMSS_affine(X, s)

% flag = validateMSS_affine(X, s)
%
% DESC:
% Validates the MSS obtained sampling the data for an affine transformation
% computation
%
% INPUT:
% X                 = samples on the manifold
% s                 = indices of the MSS
%
% OUTPUT:
% flag              = true if the MSS is valid


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2009 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU GPL.
% Please refer to the files COPYING.txt for more information.


% HISTORY:
%
% 1.0.0             - 12/22/10 - Initial version

det = ...
    X(1,s(1)) * ( X(2,s(2)) - X(2,s(3)) ) + ...
    X(1,s(2)) * ( X(2,s(3)) - X(2,s(1)) ) + ...
    X(1,s(3)) * ( X(2,s(1)) - X(2,s(2)) );

flag =true;
if det < eps
    flag = false;
end;

return
