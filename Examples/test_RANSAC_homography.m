% NAME:
% test_RANSAC_homography.m
%
% DESC:
% test to estimate the parameters of an homography

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of points
N = 300;
% inilers percentage
p = 0.25;
% noise
sigma = 1;

% set RANSAC options
options.epsilon = 1e-6;
options.P_inlier = 1-1e-4;
options.sigma = sigma;
options.validateMSS_fun = @validateMSS_homography;
options.est_fun = @estimate_homography;
options.man_fun = @error_homography;
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
seed = 34545;
rand('twister', seed);
randn('state', seed);

% generate an homographic transformation
% scaling is in [1-As, 1+As]
As = 0.5;
s   = 1 + (As * (rand()-0.5));
% angle is in [-Aphi Aphi]
Aphi = 30;
phi = Aphi*pi*(rand()-0.5);
T   = randn(2, 1);
gamma = 0.05*randn(1); 
proj = 1e-7*randn(1,2);

C = s*cos(phi);
S = s*sin(phi);
H = [C C*gamma-S T(1); S S*gamma+C T(2); proj 1];

% generate a set of points correspondences
Ni = round(p*N);
No = N-Ni;

% inliers
L = 512;
X1i = L*rand(2, Ni) - L/2;
X2i = homo2cart(H*cart2homo(X1i));

% outliers
X1o = 512*randn(2, No);
X2o = 512*randn(2, No);

X1 = [X1i X1o];
X2 = [X2i X2o];

% scramble (just in case...)
[dummy, ind] = sort(rand(1, N));
X1 = X1(:, ind);
X2 = X2(:, ind);

% and add some noise
X1 = X1 + sigma*randn(2, N);
X2 = X2 + sigma*randn(2, N);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% form the input data pairs
X = [X1; X2];
% run RANSAC
[results, options] = RANSAC(X, options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = reshape(results.Theta, 3, 3);

X1_map = homo2cart(H*cart2homo(X1));
X2_map = homo2cart(H\cart2homo(X2));

figure;

subplot(1,2,1)
hold on
plot(X2_map(1, results.CS), X2_map(2, results.CS), 'sg', 'MarkerFaceColor', 'g')
plot(X1(1, :), X1(2, :), '+r')

axis equal tight
xlabel('x');
ylabel('y');

legend('Estimated Inliers', 'Data Points')

subplot(1,2,2)
hold on
plot(X1_map(1, results.CS), X1_map(2, results.CS), 'sg', 'MarkerFaceColor', 'g')
plot(X2(1, :), X2(2, :), '+r')

axis equal tight
xlabel('x');
ylabel('y');

legend('Estimated Inliers', 'Data Points')
