% NAME:
% test_RANSAC_homography.m
%
% DESC:
% test to estimate the parameters of an homography


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2008 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU LGPL.
% Please refer to the files COPYING and COPYING.LESSER for more information.


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
options.mode = 'MLESAC';
options.Ps = [];
options.notify_iter = [];
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

% generate an homography
L = 512;
X1 = L*rand(2, 4) - L/2;
X2 = X1 + 0.1*L*rand(2, 4);
H = HomographyDLT(X1, X2);

% generate a set of points correspondences
Ni = round(p*N);
No = N-Ni;

% inliers
X1i = L*rand(2, Ni) - L/2;
X2i = homo2cart(H*cart2homo(X1i));

% outliers
X1o = 512*randn(2, No);
X2o = 512*randn(2, No);

X1 = [X1i X1o];
X2 = [X2i X2o];

% scrample (just in case...)
[dummy ind] = sort(rand(1, N));
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