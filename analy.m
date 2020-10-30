% Calculate the average value of twenty different seed cases
result = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\result.csv','ReadVariableNames',true);
data = grpstats(result,{'constraint','accuracy','Dn0','Xn0','Xn1','Xn0_1','variant','step_rule','X0_location'},'mean','DataVars',{'number_of_iterations','running_time'});
writetable(data,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\data.csv')


% For the same dimension of optimal face, explore the effect of Xn0
d2 = removevars(data,'Xn1');
Xn0_effect = unstack(d2,{'mean_number_of_iterations','mean_running_time'},'Xn0');

A1 = max(table2array(Xn0_effect(:,9:14)),[],2)-min(table2array(Xn0_effect(:,9:14)),[],2);
Xn0_effect.iteration_diff = A1;
Xn0_effect.iteration_percent = Xn0_effect.iteration_diff./max(table2array(Xn0_effect(:,9:14)),[],2);

A2 = max(table2array(Xn0_effect(:,15:20)),[],2)-min(table2array(Xn0_effect(:,15:20)),[],2);
Xn0_effect.time_diff = A2;
Xn0_effect.time_percent = Xn0_effect.time_diff./max(table2array(Xn0_effect(:,15:20)),[],2);

writetable(Xn0_effect,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\Xn0_effect.csv')

% X0_effect: average difference for each variable
Xn0_group_cons = grpstats(Xn0_effect,'constraint','mean','DataVars',{'iteration_percent','time_percent'});
writetable(Xn0_group_cons,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\Xn0_ana.xlsx','Sheet',1,'Range','A1:D3')
Xn0_group_Dn0 = grpstats(Xn0_effect,'Dn0','mean','DataVars',{'iteration_percent','time_percent'});
writetable(Xn0_group_Dn0,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\Xn0_ana.xlsx','Sheet',1,'Range','A4:D7')
Xn0_group_Xn0_1 = grpstats(Xn0_effect,'Xn0_1','mean','DataVars',{'iteration_percent','time_percent'});
writetable(Xn0_group_Xn0_1,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\Xn0_ana.xlsx','Sheet',1,'Range','A8:D14')
Xn0_group_variant = grpstats(Xn0_effect,'variant','mean','DataVars',{'iteration_percent','time_percent'});
writetable(Xn0_group_variant,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\Xn0_ana.xlsx','Sheet',1,'Range','A15:D17')
Xn0_group_step_rule = grpstats(Xn0_effect,'step_rule','mean','DataVars',{'iteration_percent','time_percent'});
writetable(Xn0_group_step_rule,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\Xn0_ana.xlsx','Sheet',1,'Range','A18:D20')
Xn0_group_X0_location = grpstats(Xn0_effect,'X0_location','mean','DataVars',{'iteration_percent','time_percent'});
writetable(Xn0_group_X0_location,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\Xn0_ana.xlsx','Sheet',1,'Range','A21:D24')


% average data
df = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\result.csv');
df = removevars(df,{'Xn0','Xn1'});
df = grpstats(df,{'constraint','accuracy','Dn0','variant','step_rule','X0_location','Xn0_1'},'mean','DataVars',{'number_of_iterations','running_time'});
writetable(df,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version7\df.csv')


% % Explore the effect of optimal point
% df = removevars(df,'GroupCount');
% optimal_point = unstack(df,{'mean_number_of_iterations','mean_running_time'},'Xn0_1');
% writetable(optimal_point,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\optimal_point.csv')
