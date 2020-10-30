df = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\df.csv','ReadVariableNames',true);

n = 25;
% the accuracy
E = linspace(-1,-5,5);

% The number of zeros of optimal solution for box constraint
X_box = [0,0.25,0.5,0.75,1];

% The number of zeros of optimal solution for unit simplex constraint
X_unit = [n-1,round(0.75*n),round(0.5*n),round(0.25*n),0];
X_sum = sum(X_unit);

Dns = round([2/3, 1/3, 0]*n);

X0s = [1,2,3];

j = 0;

for constraint = [0,1]
    if constraint == 0
        for e = 10.^E
            i = 0;
            f = figure('Position',[2000,2000,2000,2000]);
            j = j+1;
            for  Dn0 = Dns                
                for X0_location = X0s
                    i = i + 1;
                   for variant = [0,1]
                      for step_rule = [1,2]
                          plot_table = df(table2array(df(:,'Dn0'))==Dn0 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'variant'))==variant & table2array(df(:,'step_rule'))==step_rule & table2array(df(:,'accuracy'))==e , :);
                          x_axis = table2array(plot_table(:,'Xn0_1'));
                          y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                          y_axis2 = table2array(plot_table(:,'mean_running_time'));
                          
                          [xx,ind]=sort(x_axis);
                          yy1=y_axis1(ind);
                          yy2=y_axis2(ind);
                          
                          sp(2*i-1) = subplot(3,6,2*i-1);
                          plot(xx,y_axis1)
                          ylabel("The number of iterations")
                          hold on
                   
                          sp(2*i) = subplot(3,6,2*i);
                          plot(xx,y_axis2)
                          ylabel("Running time")
                          hold on
                               
                      end                          
                                         
                   end
                                                        
                end
                
            end
            
            % subplots. Position is [left bottom width height]
            % Column title
            spPos = cat(1,sp([1 3 5]).Position);
            titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
            annotation('textbox','Position',[spPos(1,1)-0.03 spPos(1,2)-0.04 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
            annotation('textbox','Position',[spPos(2,1)-0.03 spPos(2,2)-0.04 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
            annotation('textbox','Position',[spPos(3,1)-0.03 spPos(3,2)-0.04 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})
            
            % Row title
            spPosy = cat(1,sp([1 7 13]).Position);
            titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',15};
            annotation('textbox','Position',[-0.05 0.5*(spPosy(1,2)+spPosy(2,2)) 0.3 0.3],'String','17',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(2,2)+spPosy(3,2)) 0.3 0.3],'String','8',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*spPosy(3,2) 0.3 0.3],'String','0',titleSettings{:})
            
            %annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})
            
            suplabel('The dimension of the face that contains a optimal point');
            suplabel('The number of zero Eigen values','y');
            %legend(sp(18),{'variant=1','variant=2','variant=3','variant=4'},'Location','northeast')
            suplabel(['constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
            saveas(gcf,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\opt0_', num2str(j) ,'.png'])
        end
    else
        for e = 10.^E
            i = 0;
            f = figure('Position',[2000,2000,2000,2000]);
            j = j+1;
            for  Dn0 = Dns                
                for X0_location = X0s
                    i = i + 1;
                   for variant = [0,1]
                      for step_rule = [1,2]
                          plot_table = df(table2array(df(:,'Dn0'))==Dn0 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'variant'))==variant & table2array(df(:,'step_rule'))==step_rule & table2array(df(:,'accuracy'))==e , :);
                          x_axis = table2array(plot_table(:,'Xn0_1'));
                          y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                          y_axis2 = table2array(plot_table(:,'mean_running_time'));
                          
                          [xx,ind]=sort(x_axis);
                          yy1=y_axis1(ind);
                          yy2=y_axis2(ind);
                          
                          sp(2*i-1) = subplot(3,6,2*i-1);
                          plot(xx,y_axis1)
                          ylabel("The number of iterations")
                          hold on
                   
                          sp(2*i) = subplot(3,6,2*i);
                          plot(xx,y_axis2)
                          ylabel("Running time")
                          hold on
                               
                      end                          
                                         
                   end
                                                        
                end
                
            end
            
            % subplots. Position is [left bottom width height]
            % Column title
            spPos = cat(1,sp([1 3 5]).Position);
            titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
            annotation('textbox','Position',[spPos(1,1)-0.03 spPos(1,2)-0.04 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
            annotation('textbox','Position',[spPos(2,1)-0.03 spPos(2,2)-0.04 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
            annotation('textbox','Position',[spPos(3,1)-0.03 spPos(3,2)-0.04 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})
            
            % Row title
            spPosy = cat(1,sp([1 7 13]).Position);
            titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',15};
            annotation('textbox','Position',[-0.05 0.5*(spPosy(1,2)+spPosy(2,2)) 0.3 0.3],'String','17',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(2,2)+spPosy(3,2)) 0.3 0.3],'String','8',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*spPosy(3,2) 0.3 0.3],'String','0',titleSettings{:})
            
            %annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})
            
            suplabel('The dimension of the face that contains a optimal point');
            suplabel('The number of zero Eigen values','y');
            %legend(sp(18),{'variant=0,stepsize rule=1','variant=0,stepsize rule=2','variant=1,stepsize rule=1','variant=1,stepsize rule=2'},'Location','northeast')
            suplabel(['constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
            saveas(gcf,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\opt0_', num2str(j) ,'.png'])
        end
    end
        
end

