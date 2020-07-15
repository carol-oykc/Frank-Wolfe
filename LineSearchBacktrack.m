function alpha =  LineSearchBacktrack(X, d, c, Q, alpha_max)
% Backtracking Armijo Linesearch from  in direction d with parameter c1
% to make big enough improvement on the function value

% Armijo condition: f(X+alpha*d) <= f(X) + c1*alpha*g(X)'*d

% X: the current point
% d: search direction
% Q: Hessian matrix of the quadratic function
% c: the coefficients of primary variables
% alpha_max: the maximum step size

% parameters to be used in the line search
tau = 0.5;
alpha0 = 0.99*alpha_max;
c1 = 0.0001;

f0 = c'*X + 0.5*X'*Q*X;    % initial value
g0 = c + Q*X; % initial gradient

alpha = alpha0;
% evaluate function value at xk+alpha*d
X1 = X + alpha*d;
f1 = c'*X1 + 0.5*X1'*Q*X1;

% start loop (if not enough reduction)
while (f0 -f1 < -c1*alpha*g0'*d)
   % reduce alpha and evaluate function at new point
   alpha = alpha*tau;
   X1 = X + alpha*d;
   f1 = c'*X1 + 0.5*X1'*Q*X1;
end
