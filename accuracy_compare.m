df = readtable('C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version4\df.csv','ReadVariableNames',true);

% df.variants(df.variant==0&df.step_rule==1) = 1;
% df.variants(df.variant==0&df.step_rule==2) = 2;
% df.variants(df.variant==1&df.step_rule==1) = 3;
% df.variants(df.variant==1&df.step_rule==2) = 4;

%writetable(df,'C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version3\variant_compare.csv')


n = 100;
% the accuracy
E = linspace(-2,-4,3);

% The number of zeros of optimal solution for box constraint
X_box = round([1,0.75,0.5,0.25,0]*n);

% The number of zeros of optimal solution for unit simplex constraint
X_unit = [n-1,round(0.75*n),round(0.5*n),round(0.25*n),0];

Dns = round([0, 1/3, 2/3]*n);

X0s = [1,2,3];

j = 0;

for constraint = [0]
    if constraint == 0
        for Dn0 = Dns
            i = 0;
            f = figure('Position',[2000,2000,2000,2000]);
            j = j+1;
            for  Xn0_1 = X_box
                
                for X0_location = X0s
                    i = i + 1;
                    A={'aa','bb','ccc','ddd'};
                    m = 0;
                   for variant = [0 1] 
                       for step_rule = [1,2]
                           m = m+1;
                           plot_table = df(table2array(df(:,'Dn0'))==Dn0 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'Xn0_1'))==Xn0_1 & table2array(df(:,'variant'))==variant & table2array(df(:,'step_rule'))==step_rule, :);
                           x_axis = table2array(plot_table(:,'accuracy'));
                           y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                           %y_axis2 = table2array(plot_table(:,'mean_running_time'));
                       
                           x_axis = -log10(x_axis);
                           y_axis1 = log10(y_axis1);
                       
                           [xx,ind]=sort(x_axis);
                           yy1=y_axis1(ind);
                           %yy2=y_axis2(ind);
                           
                           if ((X0_location ==1) && (Xn0_1==0 || Xn0_1 ==100))
                               xx = zeros(3,1);
                               yy1 = zeros(3,1);
                               yy2 = zeros(3,1);
                           end
                       
                           p=fittype('poly1');

                           fm=fit(xx,yy1,p);
                           coef = fm.p1;
                           sp(i) = subplot(5,3,i);
                           if (variant==0 && step_rule ==1)
                               plot(fm,yy1,xx);
                               set(gcf,'color','b')
                           elseif (variant==0 && step_rule==2)
                               plot(fm,yy1,xx);
                               set(gcf,'color','r')
                           elseif (variant==1 && step_rule==1)
                               plot(fm,yy1,xx);
                               set(gcf,'color','k')
                           else
                               plot(fm,yy1,xx);
                               set(gcf,'color','y')
                           end
                           %plot(fm,yy1,xx)                       
                           ylabel("-log10(accuracy)")
                           xlabel('log10(# of iterations)')
                           
                           STR = ['coef=',num2str(round(coef,4))];
                           A(m)=cellstr(STR);
                           
                           hold on
                   
%                        sp(2*i) = subplot(5,6,2*i);
%                        plot(xx,y_axis2)
%                        ylabel("Running time")
%                        xlabel('variant')
%                        hold on   
                       
                       end
                   end
                   legend(A,'Location','eastoutside')
                                                                           
                end
                
            end
            
            % subplots. Position is [left bottom width height]
            % Column title
            spPos = cat(1,sp([13 14 15]).Position);
            titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',15};
            annotation('textbox','Position',[spPos(1,1)-0.01 -0.31 0.3 0.3],'String','Good starting point',titleSettings1{:})
            annotation('textbox','Position',[spPos(2,1)-0.01 -0.21 0.3 0.3],'String','Average starting point',titleSettings1{:})
            annotation('textbox','Position',[spPos(3,1)-0.01 -0.21 0.3 0.3],'String','Bad starting point',titleSettings1{:})
            
            % Row title
            spPosy = cat(1,sp([1 4 7 10 14]).Position);
            titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
            annotation('textbox','Position',[-0.05 0.5*(spPosy(1,2)+spPosy(2,2))-0.15 0.3 0.3],'String','100%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(2,2)+spPosy(3,2))-0.15 0.3 0.3],'String','75%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(3,2)+spPosy(4,2))-0.15 0.3 0.3],'String','50%',titleSettings{:})
            annotation('textbox','Position',[-0.05 0.5*(spPosy(4,2)+spPosy(5,2))-0.15 0.3 0.3],'String','25%',titleSettings{:})
            annotation('textbox','Position',[-0.05 -0.1 0.3 0.3],'String','0%',titleSettings{:})
            
            %annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})
            
            suplabel('The location of starting point');
            suplabel('The dimension of optimal face that contains an optimal point','y');
            legend(sp(13),{'variant 1','variant 2','variant 3','variant 4'},'Location','west')
            suplabel(['constraint=',num2str(constraint),'  Dn0=',num2str(Dn0),]  ,'t');
            saveas(gcf,['C:\Users\s1964667\OneDrive - University of Edinburgh\summer project\final_result\version4\variant_', num2str(j) ,'.png'])
            
            delete(f)
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

