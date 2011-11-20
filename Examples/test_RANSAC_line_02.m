% NAME:
% test_RANSAC_line_02.m
%
% DESC:
% test to estimate the parameters of a line using real data

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load LineData

% set RANSAC options
options.epsilon = 1e-6;
options.P_inlier = 0.99;
options.sigma = 1;
options.est_fun = @estimate_line;
options.man_fun = @error_line;
options.mode = 'MSAC';
options.Ps = [];
options.notify_iters = [];
options.min_iters = 100;
options.fix_seed = false;
options.reestimate = true;
options.stabilize = false;

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
ind = results.CS;
plot(X(1, ind), X(2, ind), '.g')
plot(X(1, ~ind), X(2, ~ind), '.r')
xlabel('x')
ylabel('y')
title('RANSAC results for 2D line estimation')
legend('Inliers', 'Outliers')
axis equal tight


