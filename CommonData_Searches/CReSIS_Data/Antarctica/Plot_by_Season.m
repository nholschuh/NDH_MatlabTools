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

        total = [total; Data_Vals2(1:ds:end,1:2)];
        
end

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
        
        hold off
        plot(total(:,1),total(:,2),'.','Color',[0.5 0.5 0.5],'MarkerSize',1);
        hold all
        groundingline(1)
        plot(Data_Vals2(1:ds:end,1),Data_Vals2(1:ds:end,2),'.','Color',color_call('darkblue'),'MarkerSize',2);
        maximize
        axis equal
        title(files(i).name)
        pdf_ndh(files(i).name(1:end-4),0)
    
end


