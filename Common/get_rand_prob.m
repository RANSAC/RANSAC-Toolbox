function h = get_rand_prob(N, P, seed)

% h = get_rand_prob(N, P, seed)
%
% DESC:
% returns a set of indices in the interval from 1 to length(P) with a
% probability given by P (i.e. P(k) = probability that the element k is
% choosen). The returned elements are unique (no repetitions)
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.2
%
% INPUT:
% N                 = number of elements to return
% P                 = probability vector
% seed              = seed of the random number generator
%
% OUTPUT:
% h                 = indices

% HISTORY:
%
% 1.0.0             - ??/??/05 - Initial version
% 1.0.1             - ??/??/06 - Bug fix
% 1.0.2             - 06/25/06 - Fixes the seed of the random number
%                                generator

if (N > length(P))
    error('N should be less or equal than the length of P')
end;

if (nargin < 3)
    seed = [];
end;

% fix the seed of the random number generator
if ~isempty(seed)
    rand('twister', seed);
end;

% use roulette method. create bounds for the roulette entries
cmf = cumsum( P/sum(P) );
flag = false(1, length(P));

n = 1;
h = zeros(1, N);
while (n <= N)

    % get an element uniformly distributed in [0, 1]
    v = rand;
    
    % seek for the smallest upper bound
    h(n) = 1;
    while (v > cmf(h(n)))
        h(n) = h(n) + 1;
    end;

    % make sure the element was not already selected
    if (flag(h(n)) == false)
        flag(h(n)) = true;
        n = n + 1;
    else
        % we need to increment the seed in order not to generate always the
        % same random number
        if ~isempty(seed)
            seed = seed + 1;
        end;        
    end;
    
end;

return
