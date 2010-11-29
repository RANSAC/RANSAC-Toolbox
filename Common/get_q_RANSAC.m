function [q num den]= get_q_RANSAC(N, N_I, k)

% [q num den] = get_q_RANSAC(N, N_I, k)
%
% DESC:
% calculates the probability q 
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0
%
% INPUT:
% N                 = number of elements
% N_I               = number of inliers
% k                 = cardinality of the MSS
%
% OUTPUT:
% q                 = probability
% num, den          = q = num / den

if (k > N_I)
    error('k should be less or equal than N_I')
end;

if (N == N_I)
    q = 1;
    return;
end;

num = N_I:-1:N_I-k+1;
den = N:-1:N-k+1;
q = prod(num./den);

return
