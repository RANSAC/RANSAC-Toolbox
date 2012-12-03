% NAME:
% test_RANSAC_homography_02.m
%
% DESC:
% test to estimate the parameters of an homography

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load HomographyData

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% noise
sigma = 1;

% set RANSAC options
options.epsilon = 1e-6;
options.P_inlier = 1-1e-4;
options.sigma = sigma;
options.validateMSS_fun = @validateMSS_homography;
options.est_fun = @estimate_homography;
options.man_fun = @error_homography;
options.Ps = 1./scores;

% options.mode = 'MSAC';
options.mode = 'PROSAC';

options.notify_iters = [];
options.fix_seed = false;
options.reestimate = true;
options.stabilize = false;

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

legend('Estimate Inliers', 'Data Points')

subplot(1,2,2)
hold on
plot(X1_map(1, results.CS), X1_map(2, results.CS), 'sg', 'MarkerFaceColor', 'g')
plot(X2(1, :), X2(2, :), '+r')

axis equal tight
xlabel('x');
ylabel('y');

legend('Estimate Inliers', 'Data Points')
