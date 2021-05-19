% Supporting material to:
% Chen, L. Y., Oparina, E., Powdthavee, N., and Srisuma, S. (2021). 
% "Robust Ranking of Happiness Outcomes: A Median Regression Perspective". 

% Estimation of the ordinal discrete choice median regression model

% y     : vector of individual responses
% x     : (n by k) matrix of covariate data of which 
%         the first column should contain data of 
%         the specific regressor with respect to which 
%         scale normalization is imposed
%         Note that x should not contain the intercept term.
% w     : vector of sampling weights 
% J     : number of response categories
clear all
clc
rng(1234,'twister');

% importing data
copsdata = importdata('GSS_working_even.csv');
data = copsdata.data;

% selecting 500 observations from each year
data = [];
for i = 1:19
    Yr = [1972 1974	1976 1978 1980 1982 1984 1986 1988 1990 1991 1993 1994 1996 1998 2000 2002 2004 2006];
    qq = copsdata.data(copsdata.data(:,27)==Yr(i),:);
    if size(qq)>0
        Y = datasample(qq,500,1,'Replace',false);
    else Y =[];
    end
        data = [data; Y];
end

clear Yr;

% defining variables
y = data(:,1);
x = data(:,2:25);
w = data(:,26); % set to 1 for equal weights
J = 3;

% defining estimation options 
T = 0; % time limit for MIO estimation, set to 0 for no limit
N = 10^4; % node limit for MIO estimation, set to 0 for no limit
beta0 = 1; % beta coefficient of the specific regressor
tau_sp = 5; % tuning parameter for bound consrtuction
[n,k] = size(x);

% defining estimation space
[logitse] = xlsread('logitse.xlsx');
bnd_logit = [-logitse(:,2) logitse(:,2)]*tau_sp + logitse(:,1);
[probitse] = xlsread('probitse.xlsx');
bnd_probit = [-probitse(:,2) probitse(:,2)]*tau_sp + probitse(:,1);
bnd0 = [min([bnd_probit(:,1) bnd_logit(:,1)],[],2) max([bnd_probit(:,2) bnd_logit(:,2)],[],2)];
radi = (bnd0(:,2)-bnd0(:,1))/2;
guess = (logitse(:,1) + probitse(:,1))/2; % set to 0 for no initial guess
clear logitse probitse;
% model estimation
[bhat,obj_v,gap,rtime,ncount]  = ordered_response_LAD(y,x,w,J,beta0,N,T,bnd0,guess);
clear guess;

% saving the results
save ('mio_res.mat');


