%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot_by_PlaneType
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files = dir('2*.mat');
total = [];
DC8 = [];
P3 = [];
TO = [];
Basler = [];


for i = 1:length(files)
    
    load(files(i).name);
    
            dv = median(distance_vector(Data_Vals2(:,1),Data_Vals2(:,2),1),'omitnan')
        if dv < 10
            ds = 100;
        elseif dv < 50
            ds = 20;
        elseif dv < 100
            ds = 10;
        elseif dv < 200
            ds = 5;
        elseif dv < 500
            ds = 2;
        else
            ds = 1;
        end
        
        if str_contain(files(i).name,'P3') == 1
            P3 = [P3; Data_Vals2(1:ds:end,1:2)];
        elseif str_contain(files(i).name,'DC8') == 1
            DC8 = [DC8; Data_Vals2(1:ds:end,1:2)];
        elseif str_contain(files(i).name,'TO') == 1
            TO = [TO; Data_Vals2(1:ds:end,1:2)];
        elseif str_contain(files(i).name,'Basler') == 1
            Basler = [Basler; Data_Vals2(1:ds:end,1:2)];
        end
        total = [total; Data_Vals2(1:ds:end,1:2)];
        
end


%%
figure(1);
hold off
plot(total(:,1),total(:,2),'.','MarkerSize',1,'Color',[0.7 0.7 0.7]);
groundingline(1);
plot(DC8(:,1),DC8(:,2),'.','MarkerSize',2,'Color',color_call('darkblue'));
maximize
axis equal


figure(2);
hold off
plot(total(:,1),total(:,2),'.','MarkerSize',1,'Color',[0.7 0.7 0.7]);
groundingline(1);
plot(P3(:,1),P3(:,2),'.','MarkerSize',2,'Color',color_call('darkblue'));
plot(TO(:,1),TO(:,2),'.','MarkerSize',2,'Color',color_call('darkblue'));
plot(Basler(:,1),Basler(:,2),'.','MarkerSize',2,'Color',color_call('darkblue'));
maximize 
axis equal


