function [final_lines line_inds] = reduce_linecomplexity(lines,bearing_thresh,plotter)

%%%%% This determines if you've provided a single line or a cell array
%%%%% containing many lines
if iscell(lines) == 0
    lines = {lines};
    doubleflag = 1;
else
    doubleflag = 0;
end

if exist('plotter') == 0
    plotter = 0;
end

if exist('bearing_thresh') == 0
    bearing_thresh = 5;
end

for i = 1:length(lines)
    b{i} = segment_bearing(lines{i}(1:end-1,:),lines{i}(2:end,:)); % Compute the line direction
    b{i}(end+1) = b{i}(end);
    
    ind = 1; %Initiate the reduced complexity algorithm
    
    lc = 2; %Line counter, for indecies in the reduced complexity line
    fl{i}(1,:) = [lines{i}(ind,:)]; %Final Line, the object storing the reduced complexity line
    fl_ind{i}(1) = 1;
    
    while ind < length(b{i})
        tb = b{i}(ind:end) - b{i}(ind);
        inds = find(abs(tb) > bearing_thresh); %Find when the bearing changes by more than the threshold
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
        