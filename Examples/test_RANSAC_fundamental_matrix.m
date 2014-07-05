% NAME:
% test_RANSAC_fundamental_matrix.m
%
% DESC:
% test to estimate the fundamental matrix from a set of 2D point
% correspondences

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load FundamentalMatrixData 

% set RANSAC options
options.epsilon = 1e-6;
options.P_inlier = 0.99;
options.sigma = 2;
options.est_fun = @estimate_fundamental_matrix;
options.man_fun = @error_fundamental_matrix;
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
indCS = find(results.CS);
figure
hold on;
for n = 1:size(X, 2)
	plot([X(1,n) X(3,n)],[X(2,n),X(4,n)],'y','LineWidth',2)
end
for n = 1:numel(indCS)
	plot([X(1,indCS(n)) X(3,indCS(n))],[X(2,indCS(n)),X(4,indCS(n))],'r','LineWidth',1)
end;
xlabel('x')
ylabel('y')
axis ij equal
grid on
title('Point correspondences (red satisfy the epipolar constraint)')




