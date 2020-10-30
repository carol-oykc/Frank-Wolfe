% statarray = grpstats(result,{'constraint','accuracy','Dn0','Xn0','Xn1','Xn0_1','variant','step_rule','X0_location'},'mean','DataVars',{'numberofiterations','runningtime'});
% writetable(statarray,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\group.csv')

x = [2 4 7 2 4 5 2 5 1 4]';
y = [2 4 7 2 4 5 2 5 1 4]';
z = [1 1 2 1 1 1 1 1 1 1]';
q = [1 1 1 3 3 3 3 3 3 3]';

h = plot(x,y);
saveas(h,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\p1.png')
delete(h)

h = plot(x,q);
saveas(h,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\p2.png')