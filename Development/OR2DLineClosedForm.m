%%
clear all
clc

syms alpha beta x y

theta_1 = cos(alpha)*sin(beta);
theta_2 = sin(alpha)*sin(beta);
theta_3 = cos(beta);

e = (theta_1*x + theta_2*y + theta_3)^2 / (theta_1^2+theta_2^2);
% e = abs(theta_1*x + theta_2*y + theta_3) / sqrt(theta_1^2+theta_2^2);

D_e_alpha = simplify(diff(e, alpha));
D_e_beta = simplify(diff(e, beta));

eq_alpha = 'lhs = 0';
eq_alpha = subs(eq_alpha, 'lhs', D_e_alpha);
eq_alpha = subs(eq_alpha, 'x^2', 'Sxx');
eq_alpha = subs(eq_alpha, 'y^2', 'Syy');
eq_alpha = subs(eq_alpha, 'x*y', 'Sxy');
eq_alpha = subs(eq_alpha, 'y*x', 'Sxy');
eq_alpha = subs(eq_alpha, 'x', 'Sx');
eq_alpha = subs(eq_alpha, 'y', 'Sy');

eq_beta = 'lhs = 0';
eq_beta = subs(eq_beta, 'lhs', D_e_beta);
eq_beta = subs(eq_beta, 'x^2', 'Sxx');
eq_beta = subs(eq_beta, 'y^2', 'Syy');
eq_beta = subs(eq_beta, 'x*y', 'Sxy');
eq_beta = subs(eq_beta, 'y*x', 'Sxy');
eq_beta = subs(eq_beta, 'x', 'Sx');
eq_beta = subs(eq_beta, 'y', 'Sy');


sols = solve(eq_alpha, eq_beta, 'alpha', 'beta');

%%
s = 1;

theta_1 = subs(theta_1, 'alpha', sols.alpha(s));
theta_1 = subs(theta_1, 'beta', sols.beta(s));

theta_2 = subs(theta_2, 'alpha', sols.alpha(s));
theta_2 = subs(theta_2, 'beta', sols.beta(s));

theta_3 = subs(theta_3, 'alpha', sols.alpha(s));
theta_3 = subs(theta_3, 'beta', sols.beta(s));

pretty(simplify(theta_1/theta_3));
pretty(simplify(theta_2/theta_3));
pretty(simplify(theta_3/theta_3));
