for n = [100]

    df = readtable(['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\df.csv'],'ReadVariableNames',true);

    ind0 = df.mean_number_of_iterations==0;
    df.mean_number_of_iterations(ind0) = 1;

    % Scale the data
    df.mean_number_of_iterations = log10(df.mean_number_of_iterations);
    df.mean_running_time = log10(df.mean_running_time);
    df.accuracy = -log10(df.accuracy);

    % the accuracy
    E = linspace(-2,-4,3);

    % The number of zeros of optimal solution for box constraint
    X_box = round([1,0.75,0.5,0.25,0]*n);

    % The number of zeros of optimal solution for unit simplex constraint
    X_unit = [n-1,round(0.75*n),round(0.5*n),round(0.25*n),0];

    % The number of zero eigenvalues
    Dns = round([0, 1/3, 2/3]*n);

    % The location of starting point
    X0s = [3,2,1];

    j = 0;

    y1 = zeros(3,1);
    y2 = zeros(3,1);

    for constraint = [0,1]
        if constraint == 0
            for Dn0 = Dns
                i = 0;
                f = figure('Position',[2000,2000,2000,2000]);
                j = j+1;
                for  Xn0_1 = X_box 
                    for X0_location = X0s
                        i = i + 1;
                        m=0;
                        ax = axes();
                       for variant = [0,1]
                           for step_rule = [1,2]
                               m=m+1;
                               plot_table = df(table2array(df(:,'Xn0_1'))==Xn0_1 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'variant'))==variant & table2array(df(:,'step_rule'))==step_rule & table2array(df(:,'Dn0'))==Dn0 , :);
                               x_axis = table2array(plot_table(:,'accuracy'));
                               y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                               y_axis2 = table2array(plot_table(:,'mean_running_time'));

                               [xx,ind]=sort(x_axis);
                               yy1=y_axis1(ind);
                               yy2=y_axis2(ind);

                               if ((X0_location ==1) && (Xn0_1==0 || Xn0_1 ==n))
                                   xx = [2 3 4]';
                                   y1(:,m) = zeros(3,1);
                                   y2(:,m) = zeros(3,1);
                               else
                                   y1(:,m) = yy1;
                                   y2(:,m) = yy2;
                               end

                               f = fit(xx,y1(:,m),'poly1');
                               coef = f.p1;
                               sp(i) = subplot(5,3,i);

                               if (variant==0 && step_rule ==1)
                                   pl=plot(f,xx,y1(:,m));
                                   ylim([0 6])
                                   set(pl,'color','b')
                               elseif (variant==0 && step_rule==2)
                                   p2=plot(f,xx,y1(:,m));
                                   ylim([0 6])
                                   set(p2,'color','r')
                               elseif (variant==1 && step_rule==1)
                                   p3=plot(f,xx,y1(:,m));
                                   ylim([0 6])
                                   set(p3,'color','k')
                               else
                                   p4=plot(f,xx,y1(:,m));
                                   ylim([0 6])
                                   set(p4,'color','y')
                               end

                               %plot(f,xx,y1(:,m))
                               xlabel("-log10($\epsilon$)",'interpreter','latex')
                               ylabel('log10(k)')

                               STR = ['variant',num2str(m),' coef=',num2str(round(coef,4))];
                               A(m)=cellstr(STR);

                               hold on

                           end

                       end
                       
                       legend([pl(2),p2(2),p3(2),p4(2)],A,'Location','eastoutside')                                     

                    end

                end

                % subplots. Position is [left bottom width height]
                % Column title
                spPos = cat(1,sp([13 14 15]).Position);
                titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[spPos(1,1)-0.03 -0.24 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(2,1)-0.03 -0.24 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(3,1)-0.03 -0.24 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})

                % Row title
                spPosy = cat(1,sp([1 4 7 10 13]).Position);
                titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[-0.06 0.5*(spPosy(1,2)+spPosy(2,2))-0.13 0.3 0.3],'String','n',titleSettings{:})
                annotation('textbox','Position',[-0.06 0.5*(spPosy(2,2)+spPosy(3,2))-0.13 0.3 0.3],'String','75%n',titleSettings{:})
                annotation('textbox','Position',[-0.06 0.5*(spPosy(3,2)+spPosy(4,2))-0.13 0.3 0.3],'String','50%n',titleSettings{:})
                annotation('textbox','Position',[-0.06 0.5*(spPosy(4,2)+spPosy(5,2))-0.13 0.3 0.3],'String','25%n',titleSettings{:})
                annotation('textbox','Position',[-0.06 -0.13 0.3 0.3],'String','0',titleSettings{:})

                %annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})

                suplabel('The location of starting point');
                suplabel('The number of active constraints','y');
                if (Dn0==0)
                    stitle = suptitle(['n=',num2str(n),' constraint=',num2str(constraint),'  $\lambda_0$=0']);
                elseif (round(Dn0) == round(n/3))
                    stitle = suptitle(['n=',num2str(n),' constraint=',num2str(constraint),'  $\lambda_0$=n/3']);
                else
                    stitle = suptitle(['n=',num2str(n),' constraint=',num2str(constraint),'  $\lambda_0$=2n/3']);
                end
                set(stitle,'Interpreter','latex')
                saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\acc_scaleline_', num2str(j) ,'.png'])

                delete(gcf)
            end
        else
            for Dn0 = Dns
                i = 0;
                f = figure('Position',[2000,2000,2000,2000]);
                j = j+1;
                for  Xn0_1 = X_unit
                    for X0_location = X0s
                        i = i + 1;
                        m=0;
                        ax = axes();
                       for variant = [0,1]
                           for step_rule = [1,2]
                               m=m+1;
                               plot_table = df(table2array(df(:,'Xn0_1'))==Xn0_1 & table2array(df(:,'constraint'))==constraint & table2array(df(:,'X0_location'))==X0_location & table2array(df(:,'variant'))==variant & table2array(df(:,'step_rule'))==step_rule & table2array(df(:,'Dn0'))==Dn0 , :);
                               x_axis = table2array(plot_table(:,'accuracy'));
                               y_axis1 = table2array(plot_table(:,'mean_number_of_iterations'));
                               y_axis2 = table2array(plot_table(:,'mean_running_time'));

                               [xx,ind]=sort(x_axis);
                               yy1=y_axis1(ind);
                               yy2=y_axis2(ind);

                               if ((X0_location ==1) && (Xn0_1==0 || Xn0_1 ==n-1))
                                   xx = [2 3 4]';
                                   y1(:,m) = zeros(3,1);
                                   y2(:,m) = zeros(3,1);
                               else
                                   y1(:,m) = yy1;
                                   y2(:,m) = yy2;
                               end

                               f = fit(xx,y1(:,m),'poly1');
                               coef = f.p1;
                               sp(i) = subplot(5,3,i);

                               if (variant==0 && step_rule ==1)
                                   pl=plot(f,xx,y1(:,m));
                                   ylim([0 4])
                                   set(pl,'color','b')
                               elseif (variant==0 && step_rule==2)
                                   p2=plot(f,xx,y1(:,m));
                                   ylim([0 4])
                                   set(p2,'color','r')
                               elseif (variant==1 && step_rule==1)
                                   p3=plot(f,xx,y1(:,m));
                                   ylim([0 4])
                                   set(p3,'color','k')
                               else
                                   p4=plot(f,xx,y1(:,m));
                                   ylim([0 4])
                                   set(p4,'color','y')
                               end

                               %plot(f,xx,y1(:,m))
                               xlabel("-log10($\epsilon$)",'interpreter','latex')
                               ylabel('log10(k)')

                               STR = ['variant',num2str(m),' coef=',num2str(round(coef,4))];
                               A(m)=cellstr(STR);

                               hold on

                           end

                       end

                       %ax.Legend(1:2:end) = []; % <---- remove the legend for data points
                       legend([pl(2),p2(2),p3(2),p4(2)],A,'Location','eastoutside')

                    end

                end

                % subplots. Position is [left bottom width height]
                % Column title
                spPos = cat(1,sp([13 14 15]).Position);
                titleSettings1 = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[spPos(1,1)-0.03 -0.24 0.3 0.3],'String','Good Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(2,1)-0.03 -0.24 0.3 0.3],'String','Average Starting Point',titleSettings1{:})
                annotation('textbox','Position',[spPos(3,1)-0.03 -0.24 0.3 0.3],'String','Bad Starting Point',titleSettings1{:})

                % Row title
                spPosy = cat(1,sp([1 4 7 10 13]).Position);
                titleSettings = {'HorizontalAlignment','center','EdgeColor','none','FontSize',10};
                annotation('textbox','Position',[-0.06 0.5*(spPosy(1,2)+spPosy(2,2))-0.13 0.3 0.3],'String','n',titleSettings{:})
                annotation('textbox','Position',[-0.06 0.5*(spPosy(2,2)+spPosy(3,2))-0.13 0.3 0.3],'String','75%n',titleSettings{:})
                annotation('textbox','Position',[-0.06 0.5*(spPosy(3,2)+spPosy(4,2))-0.13 0.3 0.3],'String','50%n',titleSettings{:})
                annotation('textbox','Position',[-0.06 0.5*(spPosy(4,2)+spPosy(5,2))-0.13 0.3 0.3],'String','25%n',titleSettings{:})
                annotation('textbox','Position',[-0.06 -0.13 0.3 0.3],'String','0',titleSettings{:})

                %annotation('textbox','Position',[spPos(2,1) spPos(2,2) 0.3 0.3],'String',['constraint=',num2str(constraint),'  accuracy=',num2str(e)],titleSettings1{:})

                suplabel('The location of starting point');
                suplabel('The number of active constraints','y');
                if (Dn0==0)
                    stitle = suptitle(['n=',num2str(n),' constraint=',num2str(constraint),'  $\lambda_0$=0']);
                elseif (round(Dn0) == round(n/3))
                    stitle = suptitle(['n=',num2str(n),' constraint=',num2str(constraint),'  $\lambda_0$=n/3']);
                else
                    stitle = suptitle(['n=',num2str(n),' constraint=',num2str(constraint),'  $\lambda_0$=2n/3']);
                end
                set(stitle,'Interpreter','latex')
                saveas(gcf,['C:\Users\MATE BOOK\OneDrive\summer project\summer project\final_result\version',num2str(n),'\acc_scaleline_', num2str(j) ,'.png'])

                delete(gcf)
            end
        end
    end
end
