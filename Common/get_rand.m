function r = get_rand(N, M, seed)

% r = get_rand(N, M, seed)
%
% DESC:
% returns a logical vector of length M with N trues uniformly ditributed
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
% 
% VERSION
% 1.0.1
% 
% INPUT:
% N             = number of ones
% M             = number of elements
% seed          = seed of the random number generator
%
% OUTPUT:
% r             = M-dimensional vector with N ones and M-N zeros
%
% HISTORY
% 1.0.0         - ??/??/04 - Initial version
% 1.0.1         - ??/??/06 - Uses logical indexing
% 1.0.2         - 06/25/08 - Fixes the seed of the random number generator

% fix the seed of the random number generator
if (nargin == 3) && ~isempty(seed)
    rand('twister', seed);
end;

if (N > M)
    error('RANSACToolbox:get_rand', 'N should be less or equal than M');
end;

r = [true(1, N) false(1, M-N+1)];

temp = rand(1, M);

[dummy ind] = sort(temp);
r = r(ind);

return
