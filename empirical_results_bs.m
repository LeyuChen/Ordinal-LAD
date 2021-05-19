% Supporting material to:
% Chen, L. Y., Oparina, E., Powdthavee, N., and Srisuma, S. (2021). 
% "Robust Ranking of Happiness Outcomes: A Median Regression Perspective". 

% Confidence Interval estimation for the ordinal discrete choice median regression model

clear all
clc
rng(1,'twister');

load('mio_res.mat', 'y','x','w', 'bhat', 'radi', 'J', 'beta0');

% defining bootstrap options 
alpha = 0.05; % significance level of CI
boot_rep = 10^3; % number of bootstrap replications
tau_b = 3; % allows to expand the space for CI estimation, if 1 - the radius of the spaces is equal
sampling = 1; % 0 - uniform samling, 1 - uniform sampling from each year (replicates the paper results)

T = 0; % time limit for MIO estimation, set to 0 for no limit  
N = 10^6; % node limit for MIO estimation, set to 0 for no limit
[n,k] = size(x); 
guess = bhat; % set to 0 for no initial guess

% constructing confidence intervals
boot_m = max(floor(n^(1/3)),(k+J-2)*3);
bnd = [-radi*tau_b radi*tau_b] +bhat;

[CI, bhat_boot] =CI_ordinal_LAD(y,x,w,J,beta0,bnd,bhat,boot_m,boot_rep,alpha,N,T,sampling,guess); % store the estimated CI

% saving the results
save("mio_res_bs.mat")
