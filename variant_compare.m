df = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\df2.csv','ReadVariableNames',true);

% df.variants(df.variant==0&df.step_rule==1) = 1;
% df.variants(df.variant==0&df.step_rule==2) = 2;
% df.variants(df.variant==1&df.step_rule==1) = 3;
% df.variants(df.variant==1&df.step_rule==2) = 4;

%writetable(df,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\variant_compare.csv')


n = 25;
% the accuracy
E = linspace(-1,-5,5);

% The number of zeros of optimal solution for box constraint
X_box = [25 19 12 6 0];

% The number of zeros of optimal solution for unit simplex constraint
X_unit = [n-1,round(0.75*n),round(0.5*n),round(0.25*n),0];

Dns = round([0, 1/3, 2/3]*n);

X0s = [1,2,3];

j = 0;

for constraint = [0]
    if constraint == 0
        for e = 10.^E
            i = 0;
            f = figure('Position',[500,500,500,500]);
            j = j+1;
            for  Xn0_1 = X_box   
                for Dn0 = Dns
                    i = i + 1;
                   for X0_location = X0s                      
                       plot_table = df(table2array(df(:,'Dn0'))==Dn0 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'Xn0_1'))==Xn0_1 & table2array(df(:,'accuracy'))==e , :);
                       x_axis = table2array(plot_table(:,'variants'));
                       y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                       y_axis2 = table2array(plot_table(:,'mean_running_time'));
                          
                       [xx,ind]=sort(x_axis);
                       yy1=y_axis1(ind);
                       yy2=y_axis2(ind);
                          
                       sp(2*i-1) = subplot(5,6,2*i-1);
                       if (X0_location==1)
                           plot(xx,y_axis1,'b')
                       elseif (X0_location==2)
                           plot(xx,y_axis1,'r')
                       else
                           plot(xx,y_axis1,'k')
                       end                           
                       ylabel("# of iterations")
                       xlabel('variant')
                       hold on
                   
                       sp(2*i) = subplot(5,6,2*i);
                       if (X0_location==1)
                           plot(xx,y_axis2,'b')
                       elseif (X0_location==2)
                           plot(xx,y_axis2,'r')
                       else
                           plot(xx,y_axis2,'k')
                       end
                       ylabel("Running time")
                       xlabel('variant')
                       hold on                                                         
                   end
                   
                                                                           
                end
                
            end
            
            % subplots. Position is [left bottom width height]
            % Column title
            spPos = cat(1,sp([25 27 29]).Position);
            titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',15};
            annotation('textbox','Position',[spPos(1,1)-0.01 -0.21 0.3 0.3],'String','0',titleSettings1{:})
            annotation('textbox','Position',[spPos(2,1)-0.01 -0.21 0.3 0.3],'String','1/3',titleSettings1{:})
            annotation('textbox','Position',[spPos(3,1)-0.01 -0.21 0.3 0.3],'String','2/3',titleSettings1{:})
            
            % Row title
            spPosy = cat(1,sp([1 7 13 19 25]).Position);
            titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
            annotation('textbox','Position',[-0.05 0.5*(spPosy(1,2)+spPosy(2,2))-0.15 0.3 0.3],'String','100%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(2,2)+spPosy(3,2))-0.15 0.3 0.3],'String','75%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(3,2)+spPosy(4,2))-0.15 0.3 0.3],'String','50%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(4,2)+spPosy(5,2))-0.15 0.3 0.3],'String','25%',titleSettings{:})
            annotation('textbox','Position',[-0.05 -0.1 0.3 0.3],'String','0%',titleSettings{:})
            
            %annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})
            
            suplabel('The number of zero Eigen values');
            suplabel('The dimension of optimal face that contains an optimal point','y');
            legend(sp(18),{'Good Starting point','Average starting point','Bad starting point'},'Location','northeast')
            suplabel(['constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
            saveas(gcf,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\variant0_', num2str(j) ,'.png'])
            
            %delete(f)
        end
    else
        for e = 10.^E
            i = 0;
            f = figure('Position',[2000,2000,2000,2000]);
            j = j+1;
            for  Xn0_1 = X_unit  
                for Dn0 = Dns
                    i = i + 1;
                   for X0_location = X0s                      
                       plot_table = df(table2array(df(:,'Dn0'))==Dn0 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'Xn0_1'))==Xn0_1 & table2array(df(:,'accuracy'))==e , :);
                       x_axis = table2array(plot_table(:,'variants'));
                       y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                       y_axis2 = table2array(plot_table(:,'mean_running_time'));
                          
                       [xx,ind]=sort(x_axis);
                       yy1=y_axis1(ind);
                       yy2=y_axis2(ind);
                          
                       sp(2*i-1) = subplot(5,6,2*i-1);
                       if (X0_location==1)
                           plot(xx,y_axis1,'b')
                       elseif (X0_location==2)
                           plot(xx,y_axis1,'r')
                       else
                           plot(xx,y_axis1,'k')
                       end                           
                       ylabel("# of iterations")
                       hold on
                   
                       sp(2*i) = subplot(5,6,2*i);
                       if (X0_location==1)
                           plot(xx,y_axis2,'b')
                       elseif (X0_location==2)
                           plot(xx,y_axis2,'r')
                       else
                           plot(xx,y_axis2,'k')
                       end
                       ylabel("Running time")
                       hold on                                                         
                   end
                   
                                                                           
                end
                
            end
            
            % subplots. Position is [left bottom width height]
            % Column title
            spPos = cat(1,sp([25 27 29]).Position);
            titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',15};
            annotation('textbox','Position',[spPos(1,1)-0.01 -0.21 0.3 0.3],'String','0',titleSettings1{:})
            annotation('textbox','Position',[spPos(2,1)-0.01 -0.21 0.3 0.3],'String','1/3',titleSettings1{:})
            annotation('textbox','Position',[spPos(3,1)-0.01 -0.21 0.3 0.3],'String','2/3',titleSettings1{:})
            
            % Row title
            spPosy = cat(1,sp([1 7 13 19 25]).Position);
            titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
            annotation('textbox','Position',[-0.05 0.5*(spPosy(1,2)+spPosy(2,2))-0.15 0.3 0.3],'String','100%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(2,2)+spPosy(3,2))-0.15 0.3 0.3],'String','75%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(3,2)+spPosy(4,2))-0.15 0.3 0.3],'String','50%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(4,2)+spPosy(5,2))-0.15 0.3 0.3],'String','25%',titleSettings{:})
            annotation('textbox','Position',[-0.05 -0.1 0.3 0.3],'String','0%',titleSettings{:})
            
            %annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})
            
            suplabel('The number of zero Eigen values');
            suplabel('The dimension of optimal face that contains an optimal point','y');
            % legend(sp(18),{'Good Starting point','Average starting point','Bad starting point'},'Location','northeast')
            suplabel(['constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
            saveas(gcf,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\variant0_', num2str(j) ,'.png'])
            
            delete(f)
        end
    end
        
end

