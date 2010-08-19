clear all
clc


flag = true;
iter = 0;

while flag
        
    theta1 = randn(3,1);
    theta1 = theta1/norm(theta1);
    
    theta2 = randn(3,1);
    theta2 = theta2/norm(theta2);
    
    theta3 = randn(3,1);
    theta3 = theta3/norm(theta3);

    X = 2*(rand(2, 100)-0.5);
    
    d12 = dist_model_line(X, theta1, theta2);
    d23 = dist_model_line(X, theta2, theta3);
    d13 = dist_model_line(X, theta1, theta3);
    
    flag = d12 + d23 >= d13;
        
    iter = iter + 1;
    fprintf('\nIter = %d', iter)
    
end;