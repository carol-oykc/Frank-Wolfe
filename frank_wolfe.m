function [X,fval,k] = frank_wolfe(X_opt,Q,c,X0,e,kmax,variant,step_rule,constraint,a)
% This is a function that implements the Frank Wolfe algorithm and 
% its variants, including the classical FW and FW with away steps with two
% different step size rules (well-studied step size and exact line search), 
% to solve the quadratic problem with box constraint or unit simplex constraint

% min c'*x + 0.5*x'*Q*x   
% box constrain: s.t low bound <= x <= upper bound
% unit simplex constraint: s.t x1+x2+...+xn = 1, xi>=0 for all i

% X_opt: the optimal point for the given problem
% Q: Hessian matrix of the quadratic function
% c: the coefficients of primary variables, this is a column vector
% X0: initial point, a column vector
% e: the accuracy
% kmax: maximum number of iterations
% variant: the classical FW will be used if it's 0; the FW with
%          away steps will be used if it's 1
% step_rule: the pre-specified step size rule of 2/(k+2) will be used if it's 1; the
%            exact line search will be used if it's 2
% constraint: the box constraint will be used if it's 0, the unit simplex
%             constraint will be used if it's 1.
% a: if a=0, we will explore the convergence of the algorithm and output
%    the convergence plot, if a=1, we will,explore the relationship between
%    the accuracy and the performance of the algorithm

% Initialization
X = X0;
n = size(X0,1);
k = 0; % the number of iterations
fval = c'*X + 0.5*X'*Q*X;

% the optimal value
f_opt = c'*X_opt + 0.5*X_opt'*Q*X_opt;

% To record the iterations
% Store the trail points in xpath
xpath = zeros(kmax+1,n);
xpath(1,:) = X ; 
% Store the function value in fpath
fpath = zeros(kmax+1,1);
fpath(1) = fval;
% Store the step size in alphapath
alphapath = zeros(kmax+1,1);
alphapath(1) = 0;

while (k <= kmax)
    y = zeros(n,1); % the solution of the linear approximation, the best vertice
    v = zeros(n,1); % the worst vertice
    
    g = c + Q*X; % the gradient of the function
    
    % The original Frank Wolfe algorithm
    switch constraint
        % Box constraint
        case 0
            % Solve the linear approximation according to the sign of the
            % coefficients
            % y is the solution of the linear approximation, the best
            % vertice
            neg = find(g < 0);
            pos = find(g >= 0);
            y(neg) = 1;
            y(pos) = 0;
            
        % Unit simplex constraint
        case 1
            % Get the first minimum component of g and set the
            % corresponding component of y to be 1
            [~,min_ind] = min(g);
            y(min_ind) = 1;
    end
    
    % Descent direction
    d = y - X;
    alpha_max = 1;
    
    % Choose the FW with away steps
    if (variant == 1) 
        switch constraint
            
            % Box constraint
            case 0
                % v is the worst vertice
                v(neg) = 0;
                v(pos) = 1;
        
                % Find the vertices that can not be used by away step
                % Fixing the components that are upper or lower bound and just
                % looking for the vertices for which the corresponding components
                % that are not the upper or lower bound
                xl = (X <= 1e-6); % close enough to the lower bound 0
                xu = (X >= 1 - 1e-6); % close enough to the upper bound 1
                v(xl) = 0;
                v(xu) = 1;

            % Unit simplex
            case 1
                % Find the positive components of X and the maximum of the
                % corresponding g
                pos_x = find(X >= 1e-6);
                [~,max_ind] = max(g(pos_x));
                v(pos_x(max_ind)) = 1;
        end
        
        % Choose the descent direction
        if (-g'*(y-X) <= -g'*(X-v))
            d = X-v;
            alpha_max = max_step(X,d);
            
        end
    end
    
    % The stopping criterion: FW gap is small enough
    if (abs(g'*d) <= e)
        break
    
    else
        % Choose the step size rule
        switch step_rule
            case 1
                % prespecified step size
                alphak = 2/(k+3);
                
            case 2
                % exact line search
                alphak = exact_linesearch(X,d,c,Q,alpha_max);
                
        end
        

        % alpha should not be larger than the maximum step size
        alphak = min(alphak,alpha_max);
        
        % Make step
        X = X + alphak*d;
        fval = c'*X + 0.5*X'*Q*X;
        k=k+1;
        
        % Update the path
        xpath(k+1,:) = X;
        fpath(k+1) = fval;
        alphapath(k+1) = alphak;
    end
end

% Record the optimal solution
xpath(k+2,:) = X_opt;
fpath(k+2) = f_opt;

if (a ==0)
    % plot the function value
    figure(1)
    plot(1:k+1,fpath(1:k+1),"k");
    xlabel("The number of iterations")
    ylabel("The value of the function")

    % Build a table to show the iterations
    iterate = (0:k+1)';
    Xk = xpath(1:k+2,:);
    function_value = fpath(1:k+2);
    step_size = alphapath(1:k+2);
    table(iterate,step_size, Xk,function_value)
    
    % plot the contour
    if (n == 2)
        figure(2)
        f = @(x1,x2) c(1)*x1 + c(2)*x2 + 0.5*Q(1,1)*x1^2 + 0.5*Q(2,2)*x2^2 + 0.5*(Q(2,1)+Q(1,2))*x1*x2;
        fcontour(f,[0 1 0 1]);
        hold on
        plot(Xk(:,1),Xk(:,2),'-',"Marker",".");
    end
end

end