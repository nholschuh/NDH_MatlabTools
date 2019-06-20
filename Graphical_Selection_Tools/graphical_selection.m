function [vertices output_inds associated_vals] = graphical_selection(line_params,locking_flag,additional_input_prompt)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Allows you to select points on the currently plotted figure through a
% graphical selection tool
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% line_params - 1: black line, width 2
%               2: red star
%               3: blue star connected with line
%
% locking_flag -
%
%%%%%%%%%%%%%%%%%%
%%%% Picker Notes
%   z - zoom in
%   Z - zoom out
%   c - center
%   u - undo last pick
%   left click - pick
%   F - force pick (pick EXACTLY - not on preexisting line) (in locking_flag mode)
%   f - force pick 2 (pick the nearest point but don't select intermediates
%   i - force pick to an interpolated point between two adjacent points on the line
%   n - NaN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

hold all

if exist('locking_flag') == 0
    locking_flag = 0;
end

if exist('additional_input_prompt') == 0
    additional_input_prompt = 0;
end
if additional_input_prompt == 0;
    associated_vals = [];
end

%%%%%%%%%%%%%%%%%%%%%%%% This will force picks onto existing lines present
%%%%%%%%%%%%%%%%%%%%%%%% on the plot
if locking_flag == 1
    cs = get(gca,'Children');
    for i = 1:length(cs)
        if length(cs(i).Type) == 4
            if cs(i).Type == 'line';
                lockline = [cs(i).XData' cs(i).YData'];
                break
            end
        end
    end
end


if exist('line_params') == 0
    default_lineparam_value = 1;
elseif isstr(line_params) == 0
    default_lineparam_value = line_params;
end

% Initializes default plot styles (although any styles can be provided as a
% string in the variable 'line_params'
if default_lineparam_value == 1
    line_params = ['''LineWidth'',2,''Color'',''black'''];
elseif default_lineparam_value == 2
    line_params = ['''*'',''Color'',''red'''];
elseif default_lineparam_value == 3
    line_params = ['''*-'',''Color'',''blue'''];
elseif exist('default_lineparam_value') == 0
    if exist('line_params') == 0
        line_params = ['''*'',''Color'',''red'''];
    end
end

if locking_flag == 1
    line_params = ['''o-'',''Color'',[0.5 0.5 0.5],''LineWidth'',2,''MarkerSize'',1'];
end

temp = get(gca);

hold all

xmin = temp.XLim(1);
xmax = temp.XLim(2);
ymin = temp.YLim(1);
ymax = temp.YLim(2);

xr_init = [xmin xmax];
yr_init = [ymin ymax];

xrange = xmax-xmin;
yrange = ymax-ymin;

zoominfactor = 0.8;
zoomoutfactor = 1/zoominfactor;

output_storage = [];
output_inds = [];

i = 1;
start = 1;
temp = zeros(1,3);

%%%%%%%%%%%%%%% Here we initialize the storage of data 
while i == 1
    temp = zeros(1,3);
    [temp(1),temp(2),temp(3)] = ginput_ndh;
    
    if locking_flag == 1 & temp(3) ~= 70
        [start_ind output_storage(i,1:2)] = find_nearest_xy(lockline,temp(1:2));
        output_storage(i,3) = temp(3);
        locking_inds = start_ind;
        output_inds = start_ind;
    else
        output_storage(i,:) = temp;
        if locking_flag == 1
            temp(3) = 1;
            locking_inds = find_nearest_xy(lockline,temp(1:2));
            output_inds(i) = NaN;            
        end        
    end
    
    if locking_flag == 1
        num_keeps = 1;
    end
    
    xs = get(gca,'XLim');
    ys = get(gca,'YLim');
    xrange = abs(diff(xs));
    yrange = abs(diff(ys));
    
    gs_ZoomIn_Function;
    gs_ZoomOut_Function;
    gs_Centering_Function;
    gs_Select_Undo_Function;
    i = i+1;
end

if i > 1
    while i < 2 ||(output_storage(i-1,3) ~= 113 & output_storage(i-1,3) ~= 81)
 
        %%%%%%%%%%%%%% Deals with a case where someone spams the u key
        if i < 2
            i = 1;
        end
        
        temp = zeros(1,3);
        [temp(1),temp(2),temp(3)] = ginput_ndh(1);
        
        if i == 1 %%%%%%%%%%%%% For the case where the user has undo-ed back to the
            %%%%%%%%%%%%% start of the line
            if locking_flag == 1 & temp(3) ~= 70
                [start_ind output_storage(i,1:2)] = find_nearest_xy(lockline,temp(1:2));
                output_storage(i,3) = temp(3);
                locking_inds = start_ind;
                output_inds = start_ind;
            else
                output_storage(i,:) = temp;
                if locking_flag == 1
                    temp(3) = 1;
                    locking_inds = find_nearest_xy(lockline,temp(1:2));
                    output_inds(i) = NaN;
                end
            end
            
            if locking_flag == 1
                num_keeps = 1;
            end
        elseif locking_flag == 1 & temp(3) == 1
            %%%%%%%%%%%%% Find the nearest point to the next selection, and
            %%%%%%%%%%%%% pull out the data from the lockline that is
            %%%%%%%%%%%%% related
            
            [start_ind] = find_nearest_xy(lockline,temp(1:2));
            locking_inds = [locking_inds start_ind];
            if locking_inds(1) > locking_inds(2);
                keeps = flipud(lockline(locking_inds(2):locking_inds(1),:));
                keep_inds = fliplr(locking_inds(2):locking_inds(1));
                
            else
                keeps = lockline(locking_inds(1):locking_inds(2),:);
                keep_inds = locking_inds(1):locking_inds(2);
            end
            num_keeps = length(keeps(:,1))-1;
            output_storage(i-1:i-1+num_keeps,1:2) = keeps;
            output_storage(i-1:i-1+num_keeps,3) = temp(3);
            output_inds(i-1:i-1+num_keeps) = keep_inds;
            
            locking_inds = locking_inds(2);
            i = i-1+num_keeps;
        elseif locking_flag == 1 & temp(3) == 70 %%% The "F" case
            temp(3) = 1;
            locking_inds = find_nearest_xy(lockline,temp(1:2));
            output_storage(i,:) = temp;
            output_inds(i) = NaN;
            num_keeps = 1;
            
        elseif locking_flag == 1 & temp(3) == 102 %%% The "f" case
            temp(3) = 1; 
            [locking_inds temp(1:2)] = find_nearest_xy(lockline,temp(1:2));
            output_storage(i,:) = temp;
            output_inds(i) = locking_inds;
            num_keeps = 1;
                
        elseif locking_flag == 1 & temp(3) == 105 %%% The "i" case
            temp(3) = 1; 
            o_select = temp(1:2);
            [locking_inds temp(1:2)] = find_nearest_xy(lockline,temp(1:2));
            d1 = pointdistance(o_select,lockline(locking_inds-1,:));
            d2 = pointdistance(o_select,lockline(locking_inds+1,:));
            if d1 < d2
                cur_d = pointdistance(lockline(locking_inds-1,:),lockline(locking_inds,:));
                output_storage(i,1) = interp1([0,1],lockline(locking_inds-1:locking_inds,1),d1/cur_d);
                output_storage(i,2) = interp1([0,1],lockline(locking_inds-1:locking_inds,2),d1/cur_d);
            else
                cur_d = pointdistance(lockline(locking_inds,:),lockline(locking_inds+1,:));
                output_storage(i,1) = interp1([0,1],lockline(locking_inds:locking_inds+1,1),1-d2/cur_d);
                output_storage(i,2) = interp1([0,1],lockline(locking_inds:locking_inds+1,2),1-d2/cur_d);
            end
            
            output_inds(i) = NaN;
            num_keeps = 1;          
            
        else %%%%%%%% Normal, non-locking picking
            output_storage(i,:) = temp;
        end
        
        
        xs = get(gca,'XLim');
        ys = get(gca,'YLim');
        xrange = abs(diff(xs));
        yrange = abs(diff(ys));
        
        gs_ZoomIn_Function;
        gs_ZoomOut_Function;
        gs_Centering_Function;
        gs_Select_Undo_Function;
        
        %%%%%%% Deal with the case where the previous action was not a
        %%%%%%% pick (most likely an undo)
        if locking_flag == 1 & temp(3) ~= 1 & i > 0
            [locking_inds] = find_nearest_xy(lockline,output_storage(i,1:2));
        end
        
        if max(temp(3) == [1 70 102 117 85 122 90 99 113 81 105 110]) == 1
            %%%%%%%%%[ click  F  f   u   U  z   Z  c  Q      i   n]
            i = i+1;
        else
            warning('Not a valid key-press');
        end
        
    end
end


if output_storage(i-1,3) ~= 81
    close all
end

vertices = output_storage(1:(length(output_storage(:,1))-1),[1 2]);

if additional_input_prompt == 1
    associated_vals = associated_vals(1:length(vertices(:,1)),:);
end

end

