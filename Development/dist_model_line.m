function d = dist_model_line(X, theta1, theta2)

% a*x + b*y + c = 0
%
% y = -a/b*x -c/b
%
% x = -b/a*x -c/a

m1 = -theta1(1)/theta1(2);
q1 = -theta1(3)/theta1(2);

y1 = m1*X(1, :)+q1;

m2 = -theta2(1)/theta2(2);
q2 = -theta2(3)/theta2(2);

y2 = m2*X(1, :)+q2;

ye = mean(abs(y1-y2));

m1 = -theta1(2)/theta1(1);
q1 = -theta1(3)/theta1(1);

x1 = m1*X(2, :)+q1;

m2 = -theta2(2)/theta2(1);
q2 = -theta2(3)/theta2(1);

x2 = m2*X(2, :)+q2;

xe = mean(abs(x1-x2));

d = 0.5*(xe+ye);

return