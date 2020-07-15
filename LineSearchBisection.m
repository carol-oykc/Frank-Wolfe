function alpha =  LineSearchBisection(X, d, c, Q, alpha_max)
% Bisection Wolfe Linesearch from xk in direction d with parameters c1, c2
% to make big improvement, and to make sure that the new point is not too
% close to the old point.

% Armijo condition: f(X+alpha*d) <= f(X) + c1*alpha*g(X)'*d
% Curvature condition: g(X+alpha*d)'*d >= c2*g(X)'*d

% X: the current point
% d: search direction
% Q: Hessian matrix of the quadratic function
% c: the coefficients of primary variables
% alpha_max: the maximum step size

% parameters to be used in the line search
c1 = 0.0001;
c2 = 0.99;
% initial trial stepsize
alpha = 0.99*alpha_max;

% initial interval
alphal = 0;
alphau = alpha_max;

f0 = c'*X + 0.5*X'*Q*X;    % initial value
g0 = c + Q*X; % initial slope

% found is an indicator that is set to 1 once both conditions are satisfied
found = 0;

% start loop
while (found==0)
    X1 = X + alpha*d;
    f1 = c'*X1 + 0.5*X1'*Q*X1;    % value at new trial point
    g1 = c + Q*X1; % slope at new trial point
   % test Armijo condition
   if (f1 > f0 + c1*alpha*g0'*d) 

      alphau = alpha;
      alpha = 0.5*(alphal + alphau);
  
   % test curvature condition
   elseif (g1'*d<c2*g0'*d)  
      alphal = alpha;
      if (alphau > 1e10)
         alpha = 2*alphal;
      else
         alpha = 0.5*(alphal+alphau);
      end

   else
     found = 1;
   end
   
   if (alphau - alphal <= 1e-6)
       return
   end
end