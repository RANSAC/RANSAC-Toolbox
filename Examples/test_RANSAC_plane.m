% NAME:
% test_RANSAC_plane.m
%
% DESC:
% test to estimate the parameters of a 3D plane

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of points
N = 1000;
% inilers percentage
p = 0.25;
% noise
sigma = 0.01;

% set RANSAC options
options.epsilon = 1e-6;
options.P_inlier = 0.99;
options.sigma = sigma;
options.est_fun = @estimate_plane;
options.man_fun = @error_plane;
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

% build a plane passing through three points 
X = 2*(rand(3, 3)-0.5);
v1 = X(:, 2) - X(:, 1); 
v1 = v1/norm(v1);
v2 = X(:, 3) - X(:, 1);
v2 = v2/norm(v2);
X0 = 2*(rand(3, 1)-0.5);

% generate a set of points spread in a cube
Ni = round(p*N);
No = N-Ni;

% inliers
lambda1 = 2*(rand(1, Ni)-0.5);
lambda2 = 2*(rand(1, Ni)-0.5);
Xi = repmat(X0, [1 Ni]) + ...
    repmat(lambda1, [3 1]).*repmat(v1, [1 Ni]) + ...
    repmat(lambda2, [3 1]).*repmat(v2, [1 Ni]); 

% and add some noise
Xi = Xi + sigma*randn(3, Ni);

% outliers
Xo = 2*(rand(3, No)-0.5) + repmat(X0, [1 No]);
X = [Xi Xo];

% scrample (just in case...)
[dummy ind] = sort(rand(1, N));
X = X(:, ind);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run RANSAC
[results, options] = RANSAC(X, options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
hold on
plot3(Xi(1, :), Xi(2, :), Xi(3, :), '+g')
plot3(Xo(1, :), Xo(2, :), Xo(3, :), '+r')
ind = results.CS;
plot3(X(1, ind), X(2, ind), X(3, ind), 'sg')
plot3(X(1, ~ind), X(2, ~ind), X(3, ~ind), 'sr')
xlabel('x')
ylabel('y')
zlabel('z')
title('RANSAC results for 3D plane estimation')
legend('Inliers', 'Outliers', 'Estimated Iniliers', 'Estimated Outliers')
axis equal tight
view(3)


