% NAME:
% test_RANSAC_RDhomography.m
%
% DESC:
% test to estimate the parameters of an homography plus radial distortion

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of points
N = 300;
% inilers percentage
p = 1.00;
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
X2 = X1 + 0.001*L*randn(2, 4);
H = HomographyDLT(X1, X2);

% generate a set of points correspondences
Ni = round(p*N);
No = N-Ni;

% inliers
X1ui = L*randn(2, Ni) - L/2;
X2ui = homo2cart(H*cart2homo(X1ui));

% add the radial distortion
kappa1 = 0;
kappa2 = 0;
O1 = [0;0];
O2 = [0;0];

rho1 = sum( (X1ui - repmat(O1, 1, Ni)).^2, 1 );
rho2 = sum( (X2ui - repmat(O2, 1, Ni)).^2, 1 );

X1i = zeros(2, Ni, 'single');
X2i = zeros(2, Ni, 'single');
for h = 1:2
    X1i(h, :) = X1ui(h, :) + kappa1*rho1.*(X1ui(h, :) - repmat(O1(h), 1, Ni));
    X2i(h, :) = X2ui(h, :) + kappa2*rho2.*(X2ui(h, :) - repmat(O2(h), 1, Ni));
end;

% outliers
X1o = L*rand(2, No) - L/2;
X2o = L*rand(2, No) - L/2;

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
%X = [X1; X2];
% run RANSAC
%[results, options] = RANSAC(X, options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;

subplot(1,2,1)
hold on
plot(X1ui(2, :), X1ui(1, :), '.g');
plot(X1i(2, :), X1i(1, :), 'or');
xlabel('y');
ylabel('x');

subplot(1,2,2)
hold on
plot(X2ui(2, :), X2ui(1, :), '.g');
plot(X2i(2, :), X2i(1, :), 'or');
xlabel('y');
ylabel('x');
