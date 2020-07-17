% generage the problem in one code
M_s = 1; % M_s increase, s increase, the corresponding components of c increase, the number of iterations increase
M_s1 = 1; % M_s1 increase, s1 increase, the corresponding components of c decrease, the number of iterations increase
M_lamda = 1; % M_lamda increase, lamda increase, all the components of c decrease, but it will not influence the number of iterations
M_A = 1; % This will not influence the results
M_D = 1; % M_D increase, Q decrease, c increase, the number of iterations increase

% Maximum number of iterations
kmax = 10000000;

n = 25; % the dimension of X

% the accuracy
E = linspace(-1,-5,5);

% The number of zeros of optimal solution for box constraint
X_box = [0.5, 0.25; 0.25, 0.5; 0.25, 0.25; 0.25, 0; 0, 0.25; 0, 0; 1, 0];

% The number of zeros of optimal solution for unit simplex constraint
X_unit = [n-1,round(0.75*n),round(0.5*n),round(0.25*n),0];

Dns = [0, 1/3, 2/3];

a = 1;

j = 0; 
result = zeros(5000,9);
X0_loc = strings([5000,1]);

for constraint = [0,1]
    rng(123)
    for seed = randperm(1000,10)  
        for e = 10.^E
            for Dn0 = round(Dns*n) 
                
                % Box constraint
                if (constraint==0)
                    for i = 1:7
                        Xn0 = round(X_box(i,1)*n);
                        Xn1 = round(X_box(i,2)*n);
                        
                        
                        % Generate the problem
                        [X_opt,Q,c,X0_ave,X0_good,X0_bad] = generate_prob(n,Xn0,Xn1,M_s,M_lamda,M_A,Dn0,M_D,M_s1,constraint,seed);
                        
                        for variant = [0,1]   
                            for step_rule = [1,2]
                                
                                if (Xn0+Xn1==0)
                                    X0s = [X0_ave,X0_bad];
                                else
                                    X0s = [X0_ave, X0_good, X0_bad];
                                end
                                for X0 = X0s
                                    
                                    tic
                                    
                                    [X,fval,k] = frank_wolfe(X_opt,Q,c,X0,e,kmax,variant,step_rule,constraint,a);
                                    
                                    j = j+1
                                    
                                    result(j,1) = constraint;
                                    result(j,2) = seed;
                                    result(j,3) = e;
                                    result(j,4) = Dn0;
                                    result(j,5) = Xn0;
                                    result(j,6) = Xn1;
                                    result(j,7) = variant;
                                    result(j,8) = step_rule;
                                    result(j,9) = k;
                                    result(j,10) = toc;
                                    
                                    if (X0 == X0_ave)
                                        X0_loc(j) = 2;
                                    elseif (X0 == X0_good)
                                        X0_loc(j) = 1;
                                    else
                                        X0_loc(j) = 3;
                                    end
                                    
                                    
                                end
                            
                            end
                        end
                        
                        
                    end
                    
                % Unit simplex
                else
                    for Xn0 = X_unit
                        % Generate the problem
                        [X_opt,Q,c,X0_ave,X0_good,X0_bad] = generate_prob(n,Xn0,Xn1,M_s,M_lamda,M_A,Dn0,M_D,M_s1,constraint,seed);
                        
                        for variant = [0,1]                            
                            for step_rule = [1,2]
                                if (Xn0==0)
                                    X0s = [X0_ave,X0_bad];
                                else
                                    X0s = [X0_ave, X0_good, X0_bad];
                                end
                                for X0 = X0s
                                    
                                    tic
                                    
                                    [X,fval,k] = frank_wolfe(X_opt,Q,c,X0,e,kmax,variant,step_rule,constraint,a);
                                    
                                    j = j+ 1
                                    result(j,1) = constraint;
                                    result(j,2) = seed;
                                    result(j,3) = e;
                                    result(j,4) = Dn0;
                                    result(j,5) = Xn0;
                                    result(j,6) = 0;
                                    result(j,7) = variant;
                                    result(j,8) = step_rule;
                                    result(j,9) = k;
                                    result(j,10) = toc;
                                    
                                    if (X0 == X0_ave)
                                        X0_loc(j) = 2;
                                    elseif (X0 == X0_good)
                                        X0_loc(j) = 1;
                                    else
                                        X0_loc(j) = 3;
                                    end
                                    
                                end
                            
                            end
                        end
                    end
                    
                end
                
            end 
        end

    end
    
    
end

names = ["constraint","seed", "accuracy", "Dn0","Xn0","Xn1","variant","step_rule","number_of_iterations","running_time"];
table1 = table(result(:,1),result(:,2),result(:,3),result(:,4),result(:,5),result(:,6),result(:,7),result(:,8),result(:,9),result(:,10),'VariableNames',names);
X0_name = ("X0_location");
table2 = table(X0_loc,'VariableNames',X0_name);

result_table = [table1, table2];
writetable(result_table,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\result.csv')

