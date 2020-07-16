function [X_opt,Q,c,X0_ave,X0_good,X0_bad] = generate_prob(n,Xn0,Xn1,M_s,M_lamda,M_A,Dn0,M_D,M_s1,constraint,seed)
% This function uses KKT conditions to generate a positive semidefinite quadratic
% function with unit simplex constraint or box constraint

% The quadratic problem with unit simplex constraint: 
% min 0.5*X'*Q*X + c'*X
% s.t e'*X = 1
%       X >= 0 

% KKT conditions for unit simplex:
% Q*X + c - lamda*e - s = 0
%                  e'*X = 1
%                   xj >= 0 for j = 1,2...n
%                   sj >= 0 for j = 1,2...n
%                 xj*sj = 0 for j = 1,2...n

% Box constraint: 
% s.t 0 <= X <= 1
% The box constraint can be separated into two constraints:
% X - 1 <= 0
%    -X <= 0

% KKT conditions for box constraint:
% Q*X + c + s1 - s = 0
%           xj - 1 <= 0 for j = 1,2...n
%               xj >= 0 for j = 1,2...n
%              s1j >= 0 for j = 1,2...n
%               sj >= 0 for j = 1,2...n
%        (xj-1)*s1j = 0 for j = 1,2...n
%             xj*sj = 0 for j = 1,2...n

% Output: 
% Q: Hessian matrix of the quadratic function
% c: the coefficients of primary variables, this is a column vector
% X_opt: the optimal solution
% X_opt = [x1,x2,...xn]
% e = [1,1,...,1]', n dimensions
% lamda: lagrangian multiplier for the constraint e'*X=1
% s: lagrangian multiplier for the constraints X >= 0
% s1: lagrangian multiplier for the constraint X - 1 <= 0

% Input:
% n: the dimension of X
% Xn0: the number of zeros of the optimal solution X. Box constraint:
%      0 <= Xn0 <= n; Unit simplex: 0<= Xn0 <= n-1. This can determine the
%      location of the optimal point
% Xn1: the number of ones of the optimal solution X for box constraint: 0 <=
%      Xn1 <= n
% M_s: the upper bound of s
% M_lamda: the upper bound of lamda
% M_s1: the upper bound of s1
% Dn0: the number of zero eigen values of the diagonal matrix D
% M_D: the upper bound of the components of diagonal matrix D
% constraint: the box constraint will be used if it's 0, the unit simplex
%             constraint will be used if it's 1.

rng('default')
rng(seed);
% Determine the optimal solution: there are xn0 zero components and n-xn0
% non-zero components in X
X_opt = zeros(n,1);

switch constraint
    % Box constraint: randomly choose zeros and ones and positive numbers
    % between [0,1]
    case 0
        % Generate n-xn0-xn1 random positive numbers between [0,1]
        nonzero_X = rand(n-Xn0-Xn1,1);
        
        % Randomly choose the indices of those non-zero components
        ind_nonzero = randperm(n,n-Xn0-Xn1);
        
        % Randomly choose the indices of ones
        diff = setdiff(1:n,ind_nonzero);
        ind_one = diff(randperm(size(diff,2),Xn1));
        
        X_opt(ind_nonzero) = nonzero_X;
        X_opt(ind_one) = 1;
    
    case 1
        %  Unit simplex: e'*X = 1
        % Generate n-xn0 random positive numbers between [0,1] with
        % the sum of 1
        nonzero_X = rand(n-Xn0,1);
        nonzero_X = nonzero_X/sum(nonzero_X);
        
        % Randomly choose the indices of those non-zero components
        ind_nonzero = randperm(n,n-Xn0);
        
        X_opt(ind_nonzero) = nonzero_X;
        
end

% Generate s
s = zeros(n,1);
% If xj=0, sj will be a random positive number between [0,M_s]
ind_zero = (X_opt <= 1e-6); % the indices of zero components of X
s(ind_zero) = M_s*rand(1,sum(ind_zero));

switch constraint
    % Box constraint
    case 0
        % Generate s1
        s1 = zeros(n,1);
        % If xj-1=0, s1j will be a random positive number between [0,M_s1]
        ind_one = (X_opt >= 1-(1e-6)); % the indices of components of X that equal to 1
        s1(ind_one) = M_s1*rand(1,sum(ind_one));
    
    % Unit simplex
    case 1
        % Generate lamda between [-M_lamda,M_lamda]
        lamda = 2*M_lamda*rand() - M_lamda;
end


rng(seed + 10)
% Generate a positive seimdefinite matrix Q
% Generate a orthogonal matrix U
A = 2*M_A*rand(n)-M_A; % a random matrix with components between [-M_A,M_A]
[U,~] = qr(A); % QR decomposition to obtain a n*n orthogonal matrix U

% Generate the diagonal matrix D with Dn0 zero eigen values
d = zeros(1,n);
ind_D = randperm(n,n-Dn0); % the indices of non-zero eigen values of D
d(ind_D) = M_D*rand(n-Dn0,1);
D = diag(d);

% Generate Q
Q = U*D*U';


% Generate c
switch constraint
    % Box constraint
    case 0
        c = s - s1 - Q*X_opt;

    % Unit simplex
    case 1
        e = ones(n,1);
        c = s + lamda*e - Q*X_opt;
end


% Generate the starting point
switch constraint
    % Box constraint
    case 0
        % Average stearting point
        X0_ave = (1/2)*ones(n,1);

        % Good starting point: located on the same face of the optimal point
        X0_good = zeros(n,1);
        X0_good(ind_one) = 1;
        % Generate n-xn0-xn1 random positive numbers between [0,1]
        nonzero_X0 = rand(n-Xn0-Xn1,1);
        X0_good(ind_nonzero) = nonzero_X0;

        % Bad starting point: far from the optimal point
        if (Xn0 == 0)            
            [opt_min,opt_min_ind] = min(X_opt);
            [opt_max,opt_max_ind] = max(X_opt);
            if opt_min <= 1-opt_max
                X0_bad(opt_min_ind) = round(opt_min);
            else
                X0_bad(opt_max_ind) = round(opt_max);
            end
            
        else
            X0_bad = ones(n,1);
            X0_bad(ind_one) = 0;
            % Generate n-xn0-xn1 random positive numbers between [0,1]
            nonzero_X0 = rand(n-Xn0-Xn1,1);
            X0_bad(ind_nonzero) = nonzero_X0;
        end
        
    % Unit simplex constraint
    case 1
        % Average starting point
        X0_ave = (1/n)*ones(n,1);
        
        % Good starting point: located on the same face of the optimal point
        X0_good = zeros(n,1);
        % Generate n-xn0 random positive numbers between [0,1]
        nonzero_X0 = rand(n-Xn0,1);
        nonzero_X0 = nonzero_X0/sum(nonzero_X0);
        X0_good(ind_nonzero) = nonzero_X0;
        
        % Bad starting poin
        X0_bad = zeros(n,1);
        % Generate n-xn0 random positive numbers between [0,1]
        if (Xn0 >0)
            nonzero_X0 = rand(Xn0,1);
            nonzero_X0 = nonzero_X0/sum(nonzero_X0);
            ind_zero = setdiff(1:n,ind_nonzero);
            X0_bad(ind_zero) = nonzero_X0;
        else
            [~,opt_min] = min(X_opt);
            X0_bad(opt_min) = 1;
            
        end
        
end

end