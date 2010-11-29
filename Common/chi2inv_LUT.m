function x = chi2inv_LUT(p, v)

% x = chi2inv_LUT(p, v)
%
% DESC:
% returns the inverse of the chi-square cdf with V  degrees of freedom 
% at the values in P. The chi-square cdf with V degrees of freedom, is the 
% gamma cdf with parameters V/2 and 2. Uses a look up table.  
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0
%
% INPUT:
% p                 = probability
% v                 = degrees of freedom
%
% OUTPUT:
% x                 = inverse value

load chi2inv_LUT;

% identify the closest point
delta_v = abs(v-v_LUT);
[delta_v_sorted ind_v_sorted] = sort(delta_v, 'ascend');
delta_p = abs(p-p_LUT);
[delta_p_sorted ind_p_sorted] = sort(delta_p, 'ascend');

v1 = v_LUT(ind_v_sorted(1));
v2 = v_LUT(ind_v_sorted(2));
p1 = p_LUT(ind_p_sorted(1));
p2 = p_LUT(ind_p_sorted(2));
x_11 = x_LUT(ind_p_sorted(1) , ind_v_sorted(1));
x_12 = x_LUT(ind_p_sorted(1) , ind_v_sorted(2));
x_21 = x_LUT(ind_p_sorted(2) , ind_v_sorted(1));
x_22 = x_LUT(ind_p_sorted(2) , ind_v_sorted(2));

% bilinear interpolation
f1 = (p2-p)/(p2-p1);
f2 = (p-p1)/(p2-p1);
x_1 = f1*x_11 + f2*x_21;
x_2 = f1*x_12 + f2*x_22;
x = (v2-v)/(v2-v1)*x_1 + (v-v1)/(v2-v1)*x_2;

return
