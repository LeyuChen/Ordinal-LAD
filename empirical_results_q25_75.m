% Supporting material to:
% Chen, L. Y., Oparina, E., Powdthavee, N., and Srisuma, S. (2022). 
% "Parametric and Semiparametric Median Ranking of Discrete Ordinal Outcomes". 

% Estimation of the ordinal discrete choice median regression model

% y     : vector of individual responses
% x     : (n by k) matrix of covariate data of which 
%         the first column should contain data of 
%         the specific regressor with respect to which 
%         scale normalization is imposed
%         Note that x should not contain the intercept term.
% w     : vector of sampling weights 
% J     : number of response categories

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Q25

clear all
clc
seed = 1234;
rng(seed,'twister');

% importing data
copsdata = importdata('GSS_working_even.csv');
data = copsdata.data;

m = size(copsdata.data,2); %
n = size(copsdata.data,1); % 

% defining variables
data = data(:,1:end-1);
m = m - 1;
y = data(:,1);
x = data(:,2:m-2);
w = data(:,m-1); % set to 0 for equal weights
J = 3;

% defining estimation options 
T = 0; % time limit for MIO estimation, set to 0 for no limit
N = 10^4; % node limit for MIO estimation, set to 0 for no limit
beta0 = 1; % beta coefficient of the specific regressor
tau_sp = 4; % tuning parameter for bound consrtuction 
tau = 0.25; % estimated quantile
[n,k] = size(x);

% defining estimation space
[logitse] = xlsread('logitse.xlsx');
bnd_logit = [-logitse(:,2) logitse(:,2)]*tau_sp + logitse(:,1);
[probitse] = xlsread('probitse.xlsx');
bnd_probit = [-probitse(:,2) probitse(:,2)]*tau_sp + probitse(:,1);
bnd0 = [min([bnd_probit(:,1) bnd_logit(:,1)],[],2) max([bnd_probit(:,2) bnd_logit(:,2)],[],2)];
radi = (bnd0(:,2)-bnd0(:,1))/2;
guess = (logitse(:,1) + probitse(:,1))/2; % set to 0 for no initial guess

% model estimation
[bhat,obj_v,gap,rtime,ncount]  = ordered_response_LAD(y,x,w,J,beta0,N,T,bnd0,tau,guess);

% diagnostics
bound_est = abs(bnd0-bhat);
sh_bound = sum(sum(bound_est==0))/(size(bound_est,1)); % share of estimates that hit the boundary
fprintf('Share of estimates that hit the boundary')
disp(sh_bound)

% saving the results
outp = [gap; obj_v; rtime; rtime/60/60; sh_bound; bhat]
b_name = sprintf("beta_%d.mat",tau*100);
save (b_name, 'outp');

fname = sprintf("mio_res_%d.mat",tau*100);
save (fname);

%% CI estimation for the ordinal discrete choice median regression model

rng(1,'twister');

% defining bootstrap options 
alpha = 0.05; % significance level of CI
boot_rep = 10^3; % number of bootstrap replications
tau_b = 4; % allows to expand the space for CI estimation, if 1 - the radius of the spaces is equal
sampling = 1; % 0 - uniform samling, 1 - uniform sampling from each year (replicates the paper results)

T = 0; % time limit for MIO estimation, set to 0 for no limit  
N = 10^6; % node limit for MIO estimation, set to 0 for no limit
[n,k] = size(x); 
guess = bhat; % set to 0 for no initial guess

% constructing confidence intervals
boot_m = max(floor(n^(1/3)),(k+J-2)*3);
bnd = [-radi*tau_b radi*tau_b] +bhat;

[CI, bhat_boot, boot_m_py] =CI_ordinal_LAD(y,x,w,J,beta0,bnd,bhat,boot_m,boot_rep,alpha,N,T,sampling,tau,guess); % store the estimated CI

% diagnostics
sh_bound = (sum(sum(bhat_boot==bnd(:,1))) + sum(sum(bhat_boot==bnd(:,2 )))) /(size(bhat_boot,1)*size(bhat_boot,2)); % share of estimates that hit the boundary
s_bound_coef = (sum(bhat_boot==bnd(:,1),2) + sum(bhat_boot==bnd(:,2),2))/boot_rep; % number of estimates on the boundary for each coef
fprintf('Share of estimates that hit the boundary')
disp(sh_bound)

% saving the results
ci_name = sprintf("ci_%d.mat",tau*100);
save (ci_name, 'CI');
fname_b = sprintf("mio_res_b_%d.mat",tau*100);
save (fname_b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Q75
clear all
clc
seed = 1234;
rng(seed,'twister');

% importing data
copsdata = importdata('GSS_working_even.csv');
data = copsdata.data;

m = size(copsdata.data,2); 
n = size(copsdata.data,1); 

% defining variables
data = data(:,1:end-1);
m = m - 1;
y = data(:,1);
x = data(:,2:m-2);
w = data(:,m-1); % set to 0 for equal weights
J = 3;

% defining estimation options 
T = 0; % time limit for MIO estimation, set to 0 for no limit
N = 10^4; % node limit for MIO estimation, set to 0 for no limit
beta0 = 1; % beta coefficient of the specific regressor
tau_sp = 4; % tuning parameter for bound consrtuction 
tau = 0.75; % estimated quantile
[n,k] = size(x);

% defining estimation space
[logitse] = xlsread('logitse.xlsx');
bnd_logit = [-logitse(:,2) logitse(:,2)]*tau_sp + logitse(:,1);
[probitse] = xlsread('probitse.xlsx');
bnd_probit = [-probitse(:,2) probitse(:,2)]*tau_sp + probitse(:,1);
bnd0 = [min([bnd_probit(:,1) bnd_logit(:,1)],[],2) max([bnd_probit(:,2) bnd_logit(:,2)],[],2)];
radi = (bnd0(:,2)-bnd0(:,1))/2;
guess = (logitse(:,1) + probitse(:,1))/2; % set to 0 for no initial guess

% model estimation
[bhat,obj_v,gap,rtime,ncount]  = ordered_response_LAD(y,x,w,J,beta0,N,T,bnd0,tau,guess);

% diagnostics
bound_est = abs(bnd0-bhat);
sh_bound = sum(sum(bound_est==0))/(size(bound_est,1)); % share of estimates that hit the boundary
fprintf('Share of estimates that hit the boundary')
disp(sh_bound)

% saving the results
outp = [gap; obj_v; rtime; rtime/60/60; sh_bound; bhat]
b_name = sprintf("beta_%d.mat",tau*100);
save (b_name, 'outp');

fname = sprintf("mio_res_%d.mat",tau*100);
save (fname);

%% CI estimation for the ordinal discrete choice median regression model

rng(1,'twister');

% defining bootstrap options 
alpha = 0.05; % significance level of CI
boot_rep = 10^3; % number of bootstrap replications
tau_b = 4; % allows to expand the space for CI estimation, if 1 - the radius of the spaces is equal
sampling = 1; % 0 - uniform samling, 1 - uniform sampling from each year (replicates the paper results)

T = 0; % time limit for MIO estimation, set to 0 for no limit  
N = 10^6; % node limit for MIO estimation, set to 0 for no limit
[n,k] = size(x); 
guess = bhat; % set to 0 for no initial guess

% constructing confidence intervals
boot_m = max(floor(n^(1/3)),(k+J-2)*3);
bnd = [-radi*tau_b radi*tau_b] +bhat;

[CI, bhat_boot, boot_m_py] =CI_ordinal_LAD(y,x,w,J,beta0,bnd,bhat,boot_m,boot_rep,alpha,N,T,sampling,tau,guess); % store the estimated CI

% diagnostics
sh_bound = (sum(sum(bhat_boot==bnd(:,1))) + sum(sum(bhat_boot==bnd(:,2 )))) /(size(bhat_boot,1)*size(bhat_boot,2)); % share of estimates that hit the boundary
s_bound_coef = (sum(bhat_boot==bnd(:,1),2) + sum(bhat_boot==bnd(:,2),2))/boot_rep; % number of estimates on the boundary for each coef
fprintf('Share of estimates that hit the boundary')
disp(sh_bound)

% saving the results
ci_name = sprintf("ci_%d.mat",tau*100);
save (ci_name, 'CI');
fname_b = sprintf("mio_res_b_%d.mat",tau*100);
save (fname_b);
