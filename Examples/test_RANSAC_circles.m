% NAME:
% test_RANSAC_circles.m
%
% DESC:
% test to estimate the parameters of a circle. This examples illustrates
% also how to pass parameters to the estimation and error functions

close all
clear 
% clc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% radii of the circles
radii = [0.1, 0.2, 0.3];
% center of the circles
xc = [0.5, 0.4, 0.6];
yc = [0.8, 0.5, 0.3];
% number of points on the circles
n_p = [20 30 40];
% total number of outliers
n_o = 100;
% noise
sigma = 0.01;
% the circle to identify
n_c_star = 3;

% set RANSAC options
options.epsilon = 1e-6;
options.P_inlier = 1-1e-4;
options.sigma = sigma;
options.est_fun = @estimate_circle;
options.man_fun = @error_circle;
options.mode = 'MSAC';
options.Ps = [];
options.notify_iters = [];
options.min_iters = 100;
options.fix_seed = false;
options.reestimate = true;
options.stabilize = false;

% here we set theradius of the circle that we want to detect
options.parameters.radius = radii(n_c_star);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make it pseudo-random
% seed = 34545;
% rand('twister', seed);
% randn('state', seed);

X = rand(2, n_o);

for n_c = 1:numel(radii)
    phi = 2*pi*rand(1, n_p(n_c));    
    x = xc(n_c)+radii(n_c)*cos(phi);
    y = yc(n_c)+radii(n_c)*sin(phi);
    C = [x;y] + sigma*randn(2,n_p(n_c));
    X = [X C];
end

% scramble (just in case...)
[dummy, ind] = sort(rand(1, size(X,2)));
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
plot(X(1,:), X(2, :), '+r');
plot(X(1,results.CS), X(2, results.CS), 'sg');
xlabel('x');
ylabel('y');
axis equal tight
grid on

phi = linspace(-pi,pi,128);

x_c = results.Theta(1) + radii(n_c_star)*cos(phi);
y_c = results.Theta(2) + radii(n_c_star)*sin(phi);
plot([x_c x_c(1)], [y_c y_c(1)], 'g', 'LineWidth', 2)

x_c = xc(n_c_star) + radii(n_c_star)*cos(phi);
y_c = yc(n_c_star) + radii(n_c_star)*sin(phi);
plot([x_c x_c(1)], [y_c y_c(1)], '--b', 'LineWidth', 1)

title('Green is RANSAC estimate, blue is ground truth')
