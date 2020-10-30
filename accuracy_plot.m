%statarray = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\group2.csv');
%statarray = grpstats(statarray,{'constraint','accuracy','Dn0','variant','step_rule','X0_location','Xn0_1'},'mean','DataVars',{'numberofiterations','runningtime'});
%writetable(statarray,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\group3.csv')

n = 25;
% the accuracy
E = linspace(-1,-4,4);

% The number of zeros of optimal solution for box constraint
X_box = [0.5, 0.25; 0.25, 0.5; 0.25, 0.25; 0.25, 0; 0, 0.25; 0, 0; 1, 0];

% The number of zeros of optimal solution for unit simplex constraint
X_unit = [n-1,round(0.75*n),round(0.5*n),round(0.25*n),0];

Dns = [0, 1/3, 2/3];

X0s = [1,2,3];

j = 0;

for Dn0 = Dns(1)
    for constraint = [0]
        if constraint == 0
            for variant = [0,1]            
                for Xn0_1 = [0,6]
                   for X0_location = X0s
                       i=0;
                      for step_rule = [1,2,3,4]
                          i=i+1;
                          j = j+1;
                          plot_table = statarray(table2array(statarray(:,'Dn0'))==Dn0 & table2array(statarray(:,'constraint'))==constraint & table2array(statarray(:,'X0_location'))==X0_location & table2array(statarray(:,'variant'))==variant & table2array(statarray(:,'Xn0_1'))==Xn0_1 & table2array(statarray(:,'step_rule'))==step_rule , :);
                          x_axis = table2array(plot_table(:,'accuracy'));
                          y_axis1 = table2array(plot_table(:,'mean_numberofiterations'));
                          y_axis2 = table2array(plot_table(:,'mean_runningtime'));
                          
                          [xx,ind]=sort(x_axis);
                          yy1=y_axis1(ind);
                          yy2=y_axis2(ind);
                          
                          xx = -log10(xx);
                          yy1 = log10(yy1);
                          
                          p=fittype('poly1');
                          f=fit(yy1,xx,p);
                          coef = f.p1;
                          subplot(2,2,i)
                          h1 = plot(f,yy1,xx);

                          yticks([1 2 3 4])
                          %xticklabels({'pre-determined step size','exact line search','Backtracking','Bisection'})
                          xlabel("log10(The number of iterations)")
                          ylabel("-log10(Accuracy)")
                          title(['step size rule: ',num2str(step_rule)])
                          legend('data',['fitted curve coefficient=',num2str(coef)])
                          
                      end
                      suptitle(['Dn0=',num2str(Dn0),' constraint=',num2str(constraint),' X0 location=',num2str(X0_location),' variant=',num2str(variant),' Xn0-1=',num2str(Xn0_1)])
                      saveas(gcf,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\cons1_', num2str(j) ,'.png'])
                          
                      delete(h1)
                                            
                   end
                end
            end
        else
            for Xn0 = X_unit
                for e = 10.^E
                   for variant = [0,1]
                      for step_rule = [1,2,3,4]
                          j = j+1;
                          plot_table = statarray(table2array(statarray(:,'Dn0'))==Dn0 & table2array(statarray(:,'constraint'))==constraint & table2array(statarray(:,'Xn0'))==Xn0 & table2array(statarray(:,'variant'))==variant & table2array(statarray(:,'step_rule'))==step_rule & table2array(statarray(:,'accuracy'))==e,:);
                          x_axis = table2array(plot_table(:,'X0_location'));
                          y_axis1 = table2array(plot_table(:,'mean_numberofiterations'));
                          y_axis2 = table2array(plot_table(:,'mean_runningtime'));
                          
                          [xx,ind]=sort(x_axis);
                          yy1=y_axis1(ind);
                          yy2=y_axis2(ind);
                          
                          yyaxis left
                          h1 = plot(xx,yy1);
                          %xticks([1 2 3])
                          %xticklabels({'good location','average location','bad location'})                         
                          %xlabel("The location of initial point")
                          ylabel("The number of iterations")
                          %title(['Dn0=',num2str(Dn0),' constraint=',num2str(constraint),' Xn0=',num2str(Xn0),' variant=',num2str(variant),' accuracy=',num2str(e),' stepsize rule=',num2str(step_rule)])
                          %saveas(h1,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\cons1_', num2str(j) ,'_1.png'])
                          %delete(h1)
                          
                          yyaxis right
                          h1 = plot(xx,yy2);
                          xticks([1 2 3])
                          xticklabels({'good location','average location','bad location'})
                          xlabel("The location of initial point")
                          ylabel("Running time")
                          title(['Dn0=',num2str(Dn0),' constraint=',num2str(constraint),' Xn0=',num2str(Xn0),' variant=',num2str(variant),' accuracy=',num2str(e),' stepsize rule=',num2str(step_rule)])
                          legend('Number of iterations','Running time')
                          saveas(h1,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\cons1_', num2str(j) ,'_2.png'])
                          delete(h1) 
                          
                      end
                                        
                   end
                end
            end
        end
    end
end


