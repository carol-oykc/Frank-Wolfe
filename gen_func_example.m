M_s = 1; % M_s increase, s increase, the corresponding components of c increase, the number of iterations increase
M_s1 = 1; % M_s1 increase, s1 increase, the corresponding components of c decrease, the number of iterations increase
M_lamda = 1; % M_lamda increase, lamda increase, all the components of c decrease, but it will not influence the number of iterations
M_A = 1; % This will not influence the results
M_D = 1; % M_D increase, Q decrease, c increase, the number of iterations increase

n = 25;
Xn0 = 13;
Xn1 = 8;
Dn0 = 0; % determine pos def or pos semidef

seed = 697;
% constraint: the box constraint will be used if it's 0, the unit simplex
%             constraint will be used if it's 1.
constraint = 1;

[X_opt,Q,c,X0_ave,X0_good,X0_bad] = generate_prob(n,Xn0,Xn1,M_s,M_lamda,M_A,Dn0,M_D,M_s1,constraint,seed);

X0 = X0_bad;

kmax = 10000000;

% variant: the classical FW will be used if it's 0; the FW with away steps will be used if it's 1
variant  = 1;
% step_rule: 1(prespecified), 2(exact line search), 3(Armijo), 4(Wolfe)
step_rule = 2;

% If a=0, we will explore the convergence of the algorithm, if a=1. we will
% explore the relationship between the accuracy and the performance of the
% algorithm
a = 0;

if (a==0)
    e = 0.1;
    [X,fval,k] = frank_wolfe(X_opt,Q,c,X0,e,kmax,variant,step_rule,constraint,a);

else
    % Explore the relationship between the accuracy and the number of
    % iterations
    knum = zeros(5,1);
    ttime = zeros(5,1);
    E = linspace(-1,-5,5);
    m = 0;
    for e = 10.^E
        m = m+1;
        tic
        
        [X,fval,k] = frank_wolfe(X_opt,Q,c,X0,e,kmax,variant,step_rule,constraint,a);
        
        knum(m) = k-1;
        
        ttime(m) = toc;
    end
    
    % Plot the relationship between accuracy and the num of iterations
    plot(-E,log10(knum),'k');
    xlabel("-log10(Accuracy)");
    ylabel("log10(The number of iterations)");
    
    % Build a table to show the relationship between the accuracy and the
    % performance of the algorithm
    accuracy = (10.^E)';
    running_time = ttime;
    num_iter = knum;
    table(accuracy,running_time, num_iter)
end