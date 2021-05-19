
% function input :
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
% N     : the node limit specified for early termination of the MIO solver
% T     : the time limit specified for early termination of the MIO solver
% bnd   : (k+J-2) matrix where the first and second columns  
%         respectively store the lower and upper bounds 
%         of the unknown parameters. The last (J-1) rows of bnd corresponds to
%         the bounds of threshold parameters. 
% guess : initial guess

% function output :
% bhat  : (k+J-2) dimensional vector of the estimates for the unknown coefficients
%         The first (k-1) elements correspond to the regression coefficient
%         estimates and the remaining (J-1) elements correspond to the threshold
%         parameter estimates.
% val   : the value of objective function upon termination
% gap   : the MIO optimization gap value in case of early termination
%         gap = 0 ==> optimal solution is found within the time limit
% rtime : the time used by the MIO solver in the estimation procedure
% ncount: the number of branch-and-bound nodes used by the MIO solver in the estimation procedure

function [bhat,val,gap,rtime,ncount] = ordered_response_LAD(y,x,w,J,beta0,N,T,bnd,guess)

n=length(y);
k=size(x,2)-1;
num_ind = n*(J-1);
num_para = k+J-1;
bhat=zeros(num_para,1);
gap=0; rtime=0; ncount=0;

model.sense = '<';
model.modelsense = 'min';

model.lb = [zeros(num_ind,1); bnd(:,1)];
model.ub = [ones(num_ind,1); bnd(:,2)];

d=zeros(n,J-1);

if sum(guess ~= 0)>0
for j=1:J-1
    d(:,j) = (beta0*x(:,1) + x(:,2:end)*guess(1:k))<=guess(k+j);
end
model.start = [d(:); guess];
end

if sum(w==0)==1
 w = ones(n,1);
end

% 'B' : int code 66
% 'C' : int code 67
model.vtype = char([66*ones(1,num_ind) 67*ones(1,num_para)]); 

tol=1e-6;
params.outputflag = 0; 
params.OptimalityTol=tol;
params.FeasibilityTol=tol;
params.IntFeasTol=tol;

if T > 0
params.TimeLimit=T;  % set termination rule based on time limit
end

if N > 0
params.NodeLimit=N;  % set termination rule based on node limit
end

y_diff=(abs(repmat(y,1,J-1)-(1:(J-1)))-abs(repmat(y,1,J-1)-(2:J))).*w;     
       
model.obj = [y_diff(:);zeros(num_para,1)]/n; 
clear y_diff;


miobnd=zeros(num_ind,1);
for j=1:J-1
miobnd((j-1)*n+1:(j-1)*n+n)=miobnd_fn([x -ones(n,1)],beta0,bnd([1:k k+j],:));
end
miobnd_bar = miobnd+tol;

diag_m = diag(miobnd);
diag_mbar = diag(miobnd_bar);
xtemp = repmat(x(:,2:end),J-1,1);
temp = zeros(num_ind,J-1);
mtemp = zeros(J-2,J-1);
ztemp=zeros(n*(J-2),num_ind);

for j=1:J-1
temp((j-1)*n+1:(j-1)*n+n,j)=-1;
if j<=J-2
mtemp(j,j)=1; mtemp(j,j+1)=-1;
ztemp((j-1)*n+1:(j-1)*n+n,(j-1)*n+1:(j+1)*n)=[eye(n) -eye(n)];
end
end

temp1 = [diag_m xtemp temp];
temp2 = [-diag_mbar -xtemp -temp];
temp3 = [zeros(J-2,num_ind+k) mtemp];
temp4 = [ztemp zeros(n*(J-2),num_para)];

clear diag_m diag_mbar xtemp temp mtemp ztemp;
model.A = sparse([temp1;temp2;temp3;temp4]);
clear temp1 temp2 temp3 temp4;

model.rhs = [miobnd*(1-tol)-repmat(beta0*x(:,1),J-1,1);-tol*miobnd_bar+repmat(beta0*x(:,1),J-1,1);zeros((n+1)*(J-2),1)];
clear miobnd miobnd_bar;


try
    result = gurobi(model, params);
    bhat=result.x(num_ind+1:num_ind+num_para);
    val=result.objval;
    gap=(val-result.objbound);
    rtime=result.runtime;
    ncount=result.nodecount;
    fprintf('Optimization returned status: %s\n', result.status);
   
catch gurobiError
    fprintf('Error reported\n');
end

end

