%df = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\acc.csv','ReadVariableNames',true);

%U = unstack(df,'log10_iterations_','e');

U = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\accuracy.csv','ReadVariableNames',true);

x = [ones(336,1) 2*ones(336,1) 3*ones(336,1) 4*ones(336,1) 5*ones(336,1)]';
y = table2array(U(:,7:11))';
coe = (y\x)';

U.coe = coe;
writetable(U,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\accuracy_final.csv')
