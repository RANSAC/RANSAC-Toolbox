function [flag, r, q] = next_combination(k, flag, r, q)

% [flag, r, q] = next_combination(k, flag, r, q)
%
% DESC:
% sequentially returns the combinations of n choose k elements in 
% lexicographical order, following the algorithm described in:
% "Producing Permutations and Combinations in Lexicographical Order" by
% Alon Itai.
%
% Example:
%
% This call initilalizes the first element in the sequence:
%
% [flag, r, q] = next_combination(k, false(1, n));
%
% the next element in the sequence of combinations is given by:
%
% [flag, r, q] = next_combination(k, flag, r, q);
%
% and so on so forth
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.0
%
% INPUT:
% k                 = number of elements to select
% flag              = n dimensional logical array of size 1 x n. Must
%                     contain k elements consistent with the values r and
%                     q. If all false the first element of the sequence
%                     will be generated
% r                 = the counter 0 <= r <= k counts the number of
%                     consecutive trues that follow the last false
% q                 = the counter 1 <= r <= n-k counts the number of
%                     consecutive falses before the last run of trues
%
% OUTPUT:
% s                 = minimal sample set
% r                 = the updated value of r
% q                 = the updated value of q

index_offset = 1;

n = numel(flag);

if all(~flag)
    flag(n-(0:k-1)) = true;
    r = k;
    q = n-k;
    return
end

if nnz(flag) ~= k
    error('next_combination:narginchk:badInputType', 'the flag vector should contain k=%d true values', k)
end;

if n == k
    return
end;

if r > 0
    flag(n-r   +index_offset) = false;
    flag(n-r-1 +index_offset) = true;
    r = r-1;
    q = 1;
    return
end;

if q == n-k
    flag = false(1, n);
    flag(n-(0:k-1)) = true;
    return
end;

last_true = n-q-1;
f = last_true;
while flag(f +index_offset)
    f = f-1;
end;

flag(f +index_offset) = true;
f = f+1;
flag(f +index_offset) = false;

s = last_true-f+1;

minimum = s-1;
if minimum > q
    minimum = q;
end;

span1 = (n-minimum):(n-1);
span2 = (f+1):(f+minimum);
temp = flag(span1 +index_offset);
flag(span1 +index_offset) = flag(span2 +index_offset);
flag(span2 +index_offset) = temp;

q = q+1;
r = s-1;

return