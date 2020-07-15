function alpha=max_step(X,d)
% This function helps to get the maximum feasible step size of away steps,
% the new point X+alpha*d shuold also located in the feasible region

% X: the current point
% d: search direction

neg = find(d < -1e-6); % be careful about zeros
pos = find(d > 1e-6);

% all the components in X should satisfy 0 <= X+alpha*d <= 1 
lb_alpha = min((-X(neg))./d(neg));
ub_alpha = min((1-X(pos))./d(pos));
alpha = min([lb_alpha,ub_alpha]);

end