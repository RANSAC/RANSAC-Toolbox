% NAME:
% test_RANSAC_line_01.m
%
% DESC:
% test to estimate the parameters of a line using synthetic data

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of points
N = 300;
% inilers percentage
p = 0.15;
% noise
sigma = 0.05;

% set RANSAC options
options.epsilon = 1e-6;
options.P_inlier = 0.99;
options.sigma = sigma;
options.est_fun = @estimate_line;
options.man_fun = @error_line;
options.mode = 'MSAC';
options.Ps = [];
options.notify_iters = [];
options.min_iters = 1000;
options.fix_seed = false;
options.reestimate = true;
options.stabilize = false;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make it pseudo-random
rand('twister', 2222);
randn('state', 2222);

% line parameters
m = -0.8;
q = 0.3;

% generate a set of points 
Ni = round(p*N);
No = N-Ni;

% inliers
X1i = 3 * 2*(rand(1, Ni)-0.5);
X2i = m*X1i+q;

% and add some noise
X1i = X1i + sigma*randn(1, Ni);
X2i = X2i + sigma*randn(1, Ni);

% outliers
X1o = 3 * 2*(rand(1, No)-0.5);
X2o = 3 * 2*(rand(1, No)-0.5);

X1 = [X1i X1o];
X2 = [X2i X2o];

% scrample (just in case...)
[dummy ind] = sort(rand(1, N));
X1 = X1(:, ind);
X2 = X2(:, ind);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% form the input data pairs
X = [X1; X2];
% run RANSAC
[results, options] = RANSAC(X, options);

%% refine the estimate via ML estimation
try
    Theta_ML = estimate_line_ML(X, find(results.CS), sigma, 0);
    ML = true;
catch
    % probably the optimization toolbox is not installed
    ML = false;
end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
hold on
plot(X1i, X2i, '+g')
plot(X1o, X2o, '+r')
ind = results.CS;
plot(X(1, ind), X(2, ind), 'sg') 
plot(X(1, ~ind), X(2, ~ind), 'sr')
xlabel('x')
ylabel('y')
title(sprintf('RANSAC results for 2D line estimation (inlier percentage = %3.2f%%)', Ni/N*100))
legend('Inliers', 'Outliers', 'Estimated Iniliers', 'Estimated Outliers')
axis equal tight
x = linspace(-3, 3, 256);
y = -results.Theta(1)/results.Theta(2)*x - results.Theta(3)/results.Theta(2);
plot(x, y, 'g', 'LineWidth', 2)
if ML
    y_ML = -Theta_ML(1)/Theta_ML(2)*x - Theta_ML(3)/Theta_ML(2);
    plot(x, y_ML, 'b--', 'LineWidth', 2)
end;

