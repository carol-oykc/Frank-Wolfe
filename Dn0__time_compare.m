for n = [25, 50, 100, 200]
    % To determine if we need to scale the data
    s = 0;
    
    df = readtable(['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\df.csv'],'ReadVariableNames',true);
    
    % Get the min and max value of each group
    scale_constraint = zeros(6,1);
    scale_accuracy = zeros(6,1);
    scale_min_iter = zeros(6,1);
    scale_max_iter = zeros(6,1);
    scale_min_time = zeros(6,1);
    scale_max_time = zeros(6,1);
    p = 0;
    for constraint = [0 1]
        for e = [0.01 0.001 0.0001]
            p = p + 1;
            scale_data = df(table2array(df(:,'constraint'))==constraint & table2array(df(:,'accuracy'))==e , :);
            scale_constraint(p) = constraint;
            scale_accuracy(p) = e;
            scale_min_iter(p) = min(scale_data.mean_number_of_iterations);
            scale_max_iter(p) = max(scale_data.mean_number_of_iterations);
            scale_min_time(p) = min(scale_data.mean_running_time);
            scale_max_time(p) = max(scale_data.mean_running_time);
        end
    end
    scale_table = table(scale_constraint,scale_accuracy,scale_min_iter,scale_max_iter,scale_min_time,scale_max_time);
    
    writetable(scale_table,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\scale_table.csv'])

    if (s == 1)
        % Scale the data group by constraints and accuracy
        G = grouptransform(df(:,{'constraint','accuracy','mean_number_of_iterations','mean_running_time'}),{'constraint','accuracy'},'rescale');

        df.mean_number_of_iterations = G.mean_number_of_iterations;
        df.mean_running_time = G.mean_running_time;
    end
    % % Scale all together
    % df.mean_number_of_iterations = rescale(df.mean_number_of_iterations);
    % df.mean_running_time = rescale(df.mean_running_time);

    % the accuracy
    E = linspace(-2,-4,3);

    % The number of zeros of optimal solution for box constraint
    X_box = round([1,0.75,0.5,0.25,0]*n);

    % The number of zeros of optimal solution for unit simplex constraint
    X_unit = [n-1,round(0.75*n),round(0.5*n),round(0.25*n),0];

    Dns = round([0, 1/3, 2/3]*n);

    X0s = [1,2,3];

    j = 0;

    y1 = zeros(3,1);
    y2 = zeros(3,1);

    for constraint = [0 1]
        if constraint == 0
            for e = 10.^E            
                i = 0;
                j = j+1;
                
                f = figure('Position',[1500,1500,1500,1500]);
                for  Xn0_1 = X_box 
                    for X0_location = X0s
                        i = i + 1;
                        m=0;

                        if ((X0_location ==1) && (Xn0_1==0 || Xn0_1 ==n))
                            continue;
                        end

                       for variant = [0,1]
                           for step_rule = [1,2]
                               m=m+1;
                               plot_table = df(table2array(df(:,'Xn0_1'))==Xn0_1 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'variant'))==variant & table2array(df(:,'step_rule'))==step_rule & table2array(df(:,'accuracy'))==e , :);
                               x_axis = table2array(plot_table(:,'Dn0'));
                               y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                               y_axis2 = table2array(plot_table(:,'mean_running_time'));

                               [xx,ind]=sort(x_axis);
                               yy1=y_axis1(ind);
                               yy2=y_axis2(ind);

                               if ((X0_location ==1) && (Xn0_1==0 || Xn0_1 ==n))
                                   y1(:,m) = zeros(3,1);
                                   y2(:,m) = zeros(3,1);
                               else
                                   y1(:,m) = yy1;
                                   y2(:,m) = yy2;
                               end

                           end

                       end
                       
                       
%                        sp1(i) = subplot(5,3,i);
%                        b1 = bar(y1);
% 
                       % min and max group by constraint and accuracy
                       ylim_min_iter = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_min_iter;
                       ylim_max_iter = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_max_iter;
                       ylim_min_time = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_min_time;
                       ylim_max_time = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_max_time;

%                        % plot(xx,yy1)
%                        ylabel("k")
%                        xlabel('$\lambda_0$','interpreter','latex')
% 
%                        % Scale the data
%                        if (s == 1)
%                            ylim([0 1])
%                        % not scale the data
%                        else
%                            ylim([ylim_min_iter ylim_max_iter])
%                            %ylim([0 1010])
%                        end

%                        xticklabels({'0', 'n/3' ,'2n/3'})
                       
                       sp2(i) = subplot(5,3,i);
                       b2 = bar(y2);

                       %plot(xx,yy2)
                       ylabel("t")
                       xlabel('$\lambda_0$','interpreter','latex')
                       % Scale the data
                       if (s == 1)
                           ylim([0 1])
                       % not scale the data
                       else
                           ylim([ylim_min_time ylim_max_time])
                           %ylim([0 0.03])
                       end
                       xticklabels({'0', 'n/3' ,'2n/3'})

                    end

                end

%                 % subplots. Position is [left bottom width height]
%                 % Column title
%                 spPos = cat(1,sp1([10,14,15]).Position);
%                 titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
%                 annotation('textbox','Position',[spPos(1,1)-0.03 -0.23 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
%                 annotation('textbox','Position',[spPos(2,1)-0.03 -0.23 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
%                 annotation('textbox','Position',[spPos(3,1)-0.03 -0.23 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})
%                 
%                 % Row title
%                 spPosy = cat(1,sp1([2 4 7 10 14]).Position);
%                 titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(1,2)+spPosy(2,2))-0.1 0.3 0.3],'String','n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(2,2)+spPosy(3,2))-0.1 0.3 0.3],'String','75%n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(3,2)+spPosy(4,2))-0.1 0.3 0.3],'String','50%n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(4,2)+spPosy(5,2))-0.1 0.3 0.3],'String','25%n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 -0.1 0.3 0.3],'String','0',titleSettings{:})
%                 
%                 suplabel('The location of starting point');
%                 suplabel('the number of active constraints','y');
%                 lgd = legend(sp1(2),{'variant 1','variant 2','variant 3','variant 4'},'Location','east');
%                 lp = get(lgd,'Position');
%                 set( lgd,'Position',[lp(1)-0.3,lp(2),lp(3),lp(4)]);
%                 suplabel(['n=',num2str(n),' constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
%                 if (s==1)
%                     saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_iter_scale_', num2str(j) ,'.png'])
%                 else
%                     saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_iter_unscale_', num2str(j) ,'.png'])
%                 end
                
                spPos = cat(1,sp2([10,14,15]).Position);
                titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[spPos(1,1)-0.03 -0.23 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(2,1)-0.03 -0.23 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(3,1)-0.03 -0.23 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})
                
                spPosy = cat(1,sp2([2 4 7 10 14]).Position);
                titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[-0.065 0.5*(spPosy(1,2)+spPosy(2,2))-0.15 0.3 0.3],'String','n',titleSettings{:})
                annotation('textbox','Position',[-0.065 0.5*(spPosy(2,2)+spPosy(3,2))-0.15 0.3 0.3],'String','0.75n',titleSettings{:})
                annotation('textbox','Position',[-0.065 0.5*(spPosy(3,2)+spPosy(4,2))-0.15 0.3 0.3],'String','0.5n',titleSettings{:})
                annotation('textbox','Position',[-0.065 0.5*(spPosy(4,2)+spPosy(5,2))-0.15 0.3 0.3],'String','0.25n',titleSettings{:})
                annotation('textbox','Position',[-0.065 -0.1 0.3 0.3],'String','0',titleSettings{:})

                annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})

                suplabel('The location of starting point');
                suplabel('the number of active constraints','y');
                lgd = legend(sp2(2),{'variant 1','variant 2','variant 3','variant 4'},'Location','east');
                lp = get(lgd,'Position');
                set( lgd,'Position',[lp(1)-0.3,lp(2),lp(3),lp(4)]);
                suplabel(['n=',num2str(n),' constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
                if (s==1)
                    saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_time_scale_', num2str(j) ,'.png'])
                else
                    saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_time_unscale_', num2str(j) ,'.png'])
                end
                delete(gcf)
            end
        else
            for e = 10.^E
                % Get the maximum and minimum value of the scale data
                scale_data = df(table2array(df(:,'constraint'))==constraint & table2array(df(:,'accuracy'))==e , :);
                scale_min = min(scale_data.mean_number_of_iterations);
                scale_max = max(scale_data.mean_number_of_iterations);

                i = 0;
                f = figure('Position',[1500,1500,1500,1500]);
                j = j+1;
                for  Xn0_1 = X_unit
                    for X0_location = X0s
                        i = i + 1;
                        m=0;

                        if ((X0_location ==1) && (Xn0_1==0 || Xn0_1 ==n-1))
                            continue;
                        end

                       for variant = [0,1]
                           for step_rule = [1,2]
                               m=m+1;
                               plot_table = df(table2array(df(:,'Xn0_1'))==Xn0_1 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'variant'))==variant & table2array(df(:,'step_rule'))==step_rule & table2array(df(:,'accuracy'))==e , :);
                               x_axis = table2array(plot_table(:,'Dn0'));
                               y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                               y_axis2 = table2array(plot_table(:,'mean_running_time'));

                               [xx,ind]=sort(x_axis);
                               yy1=y_axis1(ind);
                               yy2=y_axis2(ind);

                               if ((X0_location ==1) && (Xn0_1==0 || Xn0_1 ==n-1))
                                   y1(:,m) = zeros(3,1);
                                   y2(:,m) = zeros(3,1);
                                   continue;
                               else
                                   y1(:,m) = yy1;
                                   y2(:,m) = yy2;
                               end

                           end

                       end

                       % min and max group by constraint and accuracy
                       ylim_min_iter = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_min_iter;
                       ylim_max_iter = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_max_iter;
                       ylim_min_time = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_min_time;
                       ylim_max_time = scale_table(scale_table.scale_constraint==constraint & scale_table.scale_accuracy==e,:).scale_max_time;

                       
%                        sp1(i) = subplot(5,3,i);
%                        b1 = bar(y1);
% 
%                        % plot(xx,yy1)
%                        ylabel("k")
%                        xlabel('$\lambda_0$','interpreter','latex')
%                        % Scale the data
%                        if (s == 1)
%                            ylim([0 1])
%                        % not scale the data
%                        else
%                            ylim([ylim_min_iter ylim_max_iter])
%                            %ylim([0 100])
%                        end
%                        xticklabels({'0', 'n/3' ,'2n/3'})
% 

                       sp2(i) = subplot(5,3,i);
                       b2 = bar(y2);

                       %plot(xx,yy2)
                       ylabel("t")
                       xlabel('$\lambda_0$','interpreter','latex')
                       % Scale the data
                       if (s == 1)
                           ylim([0 1])
                       % not scale the data
                       else
                           ylim([ylim_min_time ylim_max_time])
                           %ylim([0 0.03])
                       end
                       xticklabels({'0', 'n/3' ,'2n/3'})

                    end

                end

%                 % subplots. Position is [left bottom width height]
%                 % Column title
%                 spPos = cat(1,sp1([10,14,15]).Position);
%                 titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
%                 annotation('textbox','Position',[spPos(1,1)-0.03 -0.23 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
%                 annotation('textbox','Position',[spPos(2,1)-0.03 -0.23 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
%                 annotation('textbox','Position',[spPos(3,1)-0.03 -0.23 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})
%                 
%                 % Row title
%                 spPosy = cat(1,sp1([2 4 7 10 14]).Position);
%                 titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(1,2)+spPosy(2,2))-0.1 0.3 0.3],'String','n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(2,2)+spPosy(3,2))-0.1 0.3 0.3],'String','75%n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(3,2)+spPosy(4,2))-0.1 0.3 0.3],'String','50%n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 0.5*(spPosy(4,2)+spPosy(5,2))-0.1 0.3 0.3],'String','25%n',titleSettings{:})
%                 annotation('textbox','Position',[-0.06 -0.1 0.3 0.3],'String','0',titleSettings{:})
%                 
%                 suplabel('The location of starting point');
%                 suplabel('the number of active constraints','y');
%                 lgd = legend(sp1(2),{'variant 1','variant 2','variant 3','variant 4'},'Location','east');
%                 lp = get(lgd,'Position');
%                 set( lgd,'Position',[lp(1)-0.3,lp(2),lp(3),lp(4)]);
%                 suplabel(['n=',num2str(n),' constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
%                 if (s==1)
%                     saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_iter_scale_', num2str(j) ,'.png'])
%                 else
%                     saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_iter_unscale_', num2str(j) ,'.png'])
%                 end
                
                spPos = cat(1,sp2([10,14,15]).Position);
                titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[spPos(1,1)-0.03 -0.23 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(2,1)-0.03 -0.23 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(3,1)-0.03 -0.23 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})
                
                spPosy = cat(1,sp2([2 4 7 10 14]).Position);
                titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[-0.065 0.5*(spPosy(1,2)+spPosy(2,2))-0.15 0.3 0.3],'String','n-1',titleSettings{:})
                annotation('textbox','Position',[-0.065 0.5*(spPosy(2,2)+spPosy(3,2))-0.15 0.3 0.3],'String','0.75n',titleSettings{:})
                annotation('textbox','Position',[-0.065 0.5*(spPosy(3,2)+spPosy(4,2))-0.15 0.3 0.3],'String','0.5n',titleSettings{:})
                annotation('textbox','Position',[-0.065 0.5*(spPosy(4,2)+spPosy(5,2))-0.15 0.3 0.3],'String','0.25n',titleSettings{:})
                annotation('textbox','Position',[-0.065 -0.1 0.3 0.3],'String','0',titleSettings{:})

                annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})

                suplabel('The location of starting point');
                suplabel('the number of active constraints','y');
                lgd = legend(sp2(2),{'variant 1','variant 2','variant 3','variant 4'},'Location','east');
                lp = get(lgd,'Position');
                set( lgd,'Position',[lp(1)-0.3,lp(2),lp(3),lp(4)]);
                suplabel(['n=',num2str(n),' constraint=',num2str(constraint),'  accuracy=',num2str(e),]  ,'t');
                if (s==1)
                    saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_time_scale_', num2str(j) ,'.png'])
                else
                    saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\Dn0_time_unscale_', num2str(j) ,'.png'])
                end
                delete(gcf)
            end
        end
    end
end
