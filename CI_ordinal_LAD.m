
% CI estimation for the ordinal discrete choice median regression model
% y     : vector of individual responses
% x     : (n by k) matrix of covariate data of which 
%         the first column should contain data of 
%         the specific regressor with respect to which 
%         scale normalization is imposed
%         Note that x should not contain the intercept term.
% w     : vector of sampling weights 
% J     : number of response categories
% beta0 : the coefficient taking value either 1 or -1 to normalize the 
%         scale for the first covariate      
% bnd   : (k+J-2) matrix where the first and second columns  
%         respectively store the lower and upper bounds 
%         of the unknown parameters. The last (J-1) rows of bnd corresponds to
%         the bounds of threshold parameters. 
% bhat  : (k+J-2) dimensional vector of the computed MIO estimates for the unknown coefficients
%         The first (k-1) elements correspond to the regression coefficient
%         estimates and the remaining (J-1) elements correspond to the threshold
%         parameter estimates.
% boot_m : the value for m in the m-out-of-n bootstrap procedure
% boot_rep : the number of bootstrap repetitions
% alpha : nominal CI coverage is (1-alpha)
% N     : the node limit specified for early termination of the MIO solver
% T     : the time limit specified for early termination of the MIO solver
% sampling : 0 - uniform samling, 1 - uniform sampling from each year (replicates the paper results)
% guess : initial guess

% function output :
% CI : the estimated CI for each coefficient
% bhat_boot : estimated parameter vector for each bootstrap sample

function [CI bhat_boot] = CI_ordinal_LAD(y,x,w,J,beta0,bnd,bhat,boot_m,boot_rep,alpha,N,T,sampling,guess)

[n,k] = size(x);
critical_value = zeros(k+J-2,2); rate = n^(-1/3);

% uniform index
if sampling == 0
ind = unidrnd(n,boot_m,boot_rep); 
% index uniform within year group
else
ind = [];
boot_m_py = [];
ind_temp = find(sum(x(:,7:24),2)==0);
boot_m_py = ceil(sum(sum(x(:,7:24),2)==0)/n*boot_m);

ind = ind_temp(unidrnd(size(ind_temp,1),boot_m_py,boot_rep)); % for omitted 1972
for ii = 7:24 % for 1974 to 2006
   boot_m_py_temp = ceil(sum(sum(x(:,ii)==1))/n*boot_m);
   boot_m_py = [boot_m_py; boot_m_py_temp];
   ind_temp = find(x(:,ii)==1);
   ind = [ind; ind_temp(unidrnd(size(ind_temp,1), boot_m_py_temp,boot_rep))] ;
end
end

bhat_boot = zeros(k+J-2,boot_rep);
gap=zeros(boot_rep,1); rtime=zeros(boot_rep,1); ncount=zeros(boot_rep,1);

for i=1:boot_rep
disp(['bootstrap repetition:' num2str(i)]);
[bhat_boot(:,i),~,gap(i),rtime(i),ncount(i)]  = ordered_response_LAD(y(ind(:,i)),x(ind(:,i),:),w(ind(:,i)),J,beta0,N,T,bnd,guess);
end

temp = (boot_m^(1/3))*(bhat_boot - bhat); 
critical_value = quantile(temp,[alpha/2 1-alpha/2],2);
CI = [bhat-rate*critical_value(:,2) bhat-rate*critical_value(:,1)];
end