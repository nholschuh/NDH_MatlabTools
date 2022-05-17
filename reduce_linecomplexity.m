function [final_lines line_inds] = reduce_linecomplexity(lines,bearing_thresh,distance_sd_thresh,plotter)
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This function will both attempt to subdivide data into separate lines, as
% well as reduce the number of provided points to capture the essence of
% the profile data without needing to store all tine individual values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lines - 
% bearing_thresh - 
% distance_sd_thresh - 
% plotter - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% final_lines - 
% line_inds - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%% This determines if you've provided a single line or a cell array
%%%%% containing many lines
if iscell(lines) == 0
    lines = {lines};
    doubleflag = 1;
else
    doubleflag = 0;
end

if exist('bearing_thresh') == 0
    bearing_thresh = 5;
end

if exist('distance_sd_thresh') == 0
    distance_sd_thresh = 4;
end

if exist('plotter') == 0
    plotter = 0;
end

for i = 1:length(lines)
    
    if distance_sd_thresh > 0
        %%%%%%%%%%% This triggers the line separating component of the
        %%%%%%%%%%% algorithm
        dist = distance_vector(lines{i}(:,1),lines{i}(:,2),1);
        mv = mean(dist);
        std_v = std(dist);
        nan_inds = find(dist > mv+std_v*distance_sd_thresh);
        nan_counter = 0;
        nan_vec = ones(size(lines{i}(1,:)))*NaN;
        %%%%%%%% Add in a NaN after all of the points that exceed your std
        %%%%%%%% thresh
        for j = 1:length(nan_inds)
            lines{i} = [lines{i}(1:nan_inds(j)+nan_counter,:); nan_vec; lines{i}(nan_inds(j)+nan_counter+1:end,:)];
            nan_counter = nan_counter+1;
        end
    end
    
    
    %%%%%%%%%%%%%% Now we start to reduce complexity
    b{i} = segment_bearing(lines{i}(1:end-1,:),lines{i}(2:end,:)); % Compute the line direction
    b{i}(end+1) = b{i}(end);
    
    if isnan(b{i}(1)) == 0
        ind = 1; %Initiate the reduced complexity algorithm
    else
        tind = find(isnan(b{i}) == 0);
        ind = tind(1);
    end
    
    lc = 2; %Line counter, for indecies in the reduced complexity line
    fl{i}(1,:) = [lines{i}(ind,:)]; %Final Line, the object storing the reduced complexity line
    fl_ind{i}(1) = 1;
    
    while ind < length(b{i})
        
        %%%%%%%%%%%% here we have to exclude the inds implying a line
        %%%%%%%%%%%% starts with a nan
        if isnan(b{i}(ind))
            
            %%%%%%%%%% Here we introduce a NaN, and then add the first
            %%%%%%%%%% non-nan subsequent value into the line
            fl{i}(lc,:) = NaN;
            ind = ind+1;
            fl_ind{i}(lc) = ind;
            lc = lc+1;
            
            inds = find(isnan(b{i}(ind:end)) == 0);            
            
            %%%%%%%%%%% This if statement deals with a trailing NaN,
            %%%%%%%%%%% otherwise include the point following the NaN.
            if length(inds) > 0            
            ind = inds(1)+ind;
            fl{i}(lc,:) = lines{i}(ind,:);
            fl_ind{i}(lc) = ind;
            lc = lc+1;
            end
        
        else
            
            tb = b{i}(ind:end) - b{i}(ind);
            inds = find(abs(tb) > bearing_thresh | isnan(tb)); %Find when the bearing changes by more than the threshold
            
            if length(inds) == 0
                inds_target = length(b{i}(ind:end));
            else
                inds_target = inds(1);
            end
            
            ind = ind+inds_target-1;
            fl{i}(lc,:) = lines{i}(ind,:);
            fl_ind{i}(lc) = ind;
            lc = lc+1;
        end
    end
end

if plotter
    for i = 1:length(lines)
        plot(lines{i}(:,1),lines{i}(:,2),'o','Color','blue','MarkerFaceColor','blue')
        hold all
        plot(fl{i}(:,1),fl{i}(:,2),'o-','Color','red')
    end
end

if doubleflag == 1
    final_lines = fl{1};
    line_inds = fl_ind{1};
else
    final_lines = fl;
    line_inds = fl_ind;
end

end
        