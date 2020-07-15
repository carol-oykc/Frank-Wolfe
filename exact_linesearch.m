function alpha=exact_linesearch(X,d,c,Q,alpha_max)
% This function gives a step size with exact line search algorithm

% X: the current point
% d: the search direction
% Q: Hessian matrix of the quadratic function
% c: the coefficients of primary variables
% alpha_max: maximum step size

% The lower and upper bound of alpha and the corresponding function
% values
alphas = [0, alpha_max];
funcs = zeros(2,1);
for i = 1:2
    alpha = alphas(i);
    funcs(i) = func(alpha,X,d,c,Q);
end

% if func is not strictly convex
if (d'*Q*d <=0)
    [~,min_index] = min(funcs);
    alpha = alphas(min_index);

% if func is strictly convex
else
    faxis = -(c'*d + X'*Q*d)/(d'*Q*d);
    if (0<= faxis) && (faxis <= alpha_max)
        alpha = faxis;
    else
        [~,min_index] = min(funcs);
        alpha = alphas(min_index);
    end
end
end

function f=func(alpha,X,d,c,Q)
% This function gives the function value at the next point

% alpha: the step size
% X: the current point
% d: the descent direction
% Q: Hessian matrix of the quadratic function
% c: the coefficients of primary variables

f = c'*(X + alpha*d) + 0.5*(X + alpha*d)'*Q*(X + alpha*d);
% = c'*X + 0.5*X'*Q*X + (c'*d + X'*Q*d)*alpha + 0.5*d'*Q*d*alpha^2
end
