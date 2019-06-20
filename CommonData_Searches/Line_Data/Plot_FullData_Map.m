%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot_FullDataMap
%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

files = dir('*.mat');
files = files([1:6 8:11 13]);

hold off
ds = 100;

total_x = [];
total_y = [];

for i = 1:length(files)
    
    load(files(i).name)
    
    if exist('x') == 1
        dv = median(distance_vector(x,y,1),'omitnan')
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
      
        
        plot(x(1:ds:end),y(1:ds:end),'.','Color',color_call('darkblue'),'MarkerSize',1)
        total_x = [total_x; x(1:ds:end)];
        total_y = [total_y; y(1:ds:end)];
    end
    
    if exist('data') == 1
        dv = median(distance_vector(data(:,1),data(:,2),1),'omitnan')
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
        
        plot(data(1:ds:end,1),data(1:ds:end,2),'.','Color',color_call('darkblue'),'MarkerSize',1)
        total_x = [total_x; data(1:ds:end,1)];
        total_y = [total_y; data(1:ds:end,2)];
    end
   
    hold all
    disp(['Completed file ',num2str(i),' of ',num2str(length(files))])
    clearvars -except files i total*
end