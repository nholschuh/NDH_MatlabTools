%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot_FullDataMap
%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

files = dir('*.mat');
type = [1 3  2 3 3 1 4 4 4 6 1 0 0 2 1 1 1];
keep = [1 1 1 1 0 1 0 1 0 1 1 0 0 1 1 1 1];
ds_sd =[3 3 3 1 3 3 3 3 3 0 3 3 3 3 0 9 9];
l_p =  [1 0 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1];   %lines 1 or points 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% types:
% 1 - UTIG (HiCARS)
% 2 - BAS (PASIN)
% 3 - Old Data (Mixed Systems, including SPRI)
% 4 - CReSIS
% 5 - Ground Data
% 6 - Chinese


opts = find(keep);
files = files(opts);
type = type(opts);

colors = [color_call('maroon'); ...
    color_call('darkorange'); ...
    color_call('midnightblue'); ...
    color_call('royalblue'); ...
    color_call('darkgreen')];

colors = [0 76 112; ...
    0 147 209; ...
    242 99 95; ...
    244 208 12; ...
    190 185 181; ...
    224 160 37]/255;

cv = 100;
colors = [cv cv cv; ...
    cv cv cv; ...
    cv cv cv; ...
    cv cv cv; ...
    cv cv cv; ...
    cv cv cv/255;


hold off
Antarctic_Imagery(4,'a',0,0,0,1,0,0);
hold all
plot(0,0,'Color',colors(1,:))
plot(0,0,'Color',colors(2,:))
plot(0,0,'Color',colors(3,:))
plot(0,0,'Color',colors(4,:))
plot(0,0,'Color',colors(5,:))
plot(0,0,'Color',colors(5,:))

ds = 100;

ds_opt = 2;
%%%%%%%%%%%% 1 - Naive downsampling based on data spacing
%%%%%%%%%%%% 2 - Reduced Line Complexity

total_x = cell(length(files),1);
total_y = cell(length(files),1);

for i = 1:length(files)
    
    load(files(i).name)
    
    
    if exist('x') == 1
        
        if exist('mission_ids') == 0
            mission_ids = ones(size(x));
        end
        
        if length(mission_ids) ~= length(x)
            mission_ids = ones(size(x));
        end
        
        if type(i) == 3
            temp_x = [];
            temp_y = [];
            misids = unique(mission_ids);
            for j = 1:length(misids)
                inds = find(mission_ids == misids(j));
                dv = median(distance_vector(x(inds),y(inds),1),'omitnan');
                if dv < 10
                    ds = 100;
                elseif dv < 50
                    ds = 20;
                elseif dv < 100
                    ds = 10;
                elseif dv < 200
                    ds = 2;
                elseif dv < 500
                    ds = 1;
                else
                    ds = 1;
                end
                temp_x = [temp_x; x(inds(1:ds:end))];
                temp_y = [temp_y; y(inds(1:ds:end))];
            end
            x = temp_x;
            y = temp_y;
        else
            dv = median(distance_vector(x,y,1),'omitnan');
            if dv < 10
                ds = 100;
            elseif dv < 50
                ds = 20;
            elseif dv < 100
                ds = 10;
            elseif dv < 200
                ds = 2;
            elseif dv < 500
                ds = 1;
            else
                ds = 1;
            end
            x = x(1:ds:end);
            y = y(1:ds:end);
        end
        
        if ds_opt == 1 | l_p(i) == 0;
            plot(x,y,'.','Color',colors(type(i),:),'MarkerSize',0.5)
            total_x{i} = x;
            total_y{i} = y;
        else
            rl = reduce_linecomplexity([x(1:ds:end) y(1:ds:end)],5,ds_sd(i),0);
            plot(rl(:,1),rl(:,2),'Color',colors(type(i),:))
            total_x{i} = rl(:,1);
            total_y{i} = rl(:,2);
        end
    end
    %%%%%%%%%%%%%%%%%%% For the two different data types
    if exist('data') == 1
        dv = median(distance_vector(data(:,1),data(:,2),1),'omitnan');
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
        
        if ds_opt == 1 | l_p(i) == 0;
            plot(data(1:ds:end,1),data(1:ds:end,2),'.','Color',colors(type(i),:),'MarkerSize',1)
            total_x = [data(1:ds:end,1)];
            total_y = [data(1:ds:end,2)];
        else
            rl = reduce_linecomplexity([data(1:ds:end,1) data(1:ds:end,2)],5,ds_sd(i),0);
            plot(rl(:,1),rl(:,2),'Color',colors(type(i),:))
            total_x{i} = [rl(:,1)];
            total_y{i} = [rl(:,2)];
            total_type(i) = type(i);
        end
    end
    
    
    hold all
    disp(['Completed file ',num2str(i),' of ',num2str(length(files))])
    clearvars -except files i total* ds_opt colors type l_p ds_sd
end 
% 1 - UTIG (HiCARS)
% 2 - BAS (PASIN)
% 3 - Old Data (Mixed Systems, including SPRI)
% 4 - CReSIS
% 5 - Chinese
legend({'UTIG','BAS','Pre B2 Data','CReSIS','Ground','Chinese'})
axis equal
axis off
set(gcf,'Color','white')













