function cmap = gmt_to_matlab_colormap(filein,keep_proportions,interp_flag,plotter)
% Function that reads in gmt colormap file and applies it within matlab. If
% you supply an integer value, you can use one of the predefined gmt
% colormaps:
% 1 - Elevation
% 2 - Velocity (Linear)
% 3 - Velocity (Log)
% 4 - Rainbow
% 5 - Modified Jet


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This will generate a figure with the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% resulting colormap
if exist('plotter') == 0
    plotter = 0;
end

if exist('interp_flag') == 0
    interp_flag = 1;
    interp_num = 255;
else
    if length(interp_flag) == 1
        interp_num = 255;
    else
        interp_num = interp_flag(2);
    end
end

if isnumeric(filein) == 1
    if filein == 1
        filein = [OnePath,'GMT_Code/colormaps/elevation.cpt'];
        keep_proportions_temp = 1;
    elseif filein == 2
        filein =  [OnePath,'GMT_Code/colormaps/velocity_linear_continuous.cpt'];
    elseif filein == 3
        filein =  [OnePath,'GMT_Code/colormaps/velocity_log_discrete.cpt'];
        keep_proportions_temp = 1;
    elseif filein == 4
        filein =  [OnePath,'GMT_Code/colormaps/thickness_rainbow.cpt'];
        keep_proportions_temp = 1;
    elseif filein == 5
        filein =  [OnePath,'GMT_Code/colormaps/jet_ndh.cpt'];
        keep_proportions_temp = 1;
    end
end

if exist('keep_proportions') == 0 & exist('keep_proportions_temp') == 0
    keep_proportions = 0;
elseif exist('keep_proportions') == 0 & exist('keep_proportions_temp') == 1
    keep_proportions = keep_proportions_temp;
end

fid = fopen(filein);
data = textscan(fid,'%s','Delimiter','\n');

include_rows = [];

for i = 1:length(data{1})
    if max(isstrprop(data{1}{i},'alpha')) == 0 & length(data{1}{i}) > 8
        include_rows = [include_rows; i];
    end
end

fclose(fid);
colors = dlmread(filein,'\t',[min(include_rows)-1 0 max(include_rows)-1 7]);

final_c = [];
if colors(2:4) ~= colors(6:8)
    final_c = [colors(1,2:4)];
    index = [colors(1)];
end

for i = 1:length(colors(:,1))
    final_c = [final_c; colors(i,6:8)];
    index = [index; colors(i,5)];
end

if keep_proportions == 1
    new_c_axis = linspace(min(index),max(index),interp_num);
    
    c1 = interp1(index,final_c(:,1),new_c_axis);
    c2 = interp1(index,final_c(:,2),new_c_axis);
    c3 = interp1(index,final_c(:,3),new_c_axis);
    
    cmap = [c1' c2' c3']/255;
else
    if interp_flag == 1
        new_c_axis = linspace(0,1,interp_num);
        old_c_axis = [0:1:length(final_c(:,1))-1]/(length(final_c(:,1))-1);
        c1 = interp1(old_c_axis,final_c(:,1),new_c_axis);
        c2 = interp1(old_c_axis,final_c(:,2),new_c_axis);
        c3 = interp1(old_c_axis,final_c(:,3),new_c_axis);    
        cmap = [c1' c2' c3']/255;
    else
        cmap = final_c/255;
    end
end

colormap(cmap);
caxis([min(index) max(index)])

%%%%%%% Plot the colormap
if plotter == 1
    figure()
    for i = 1:length(cmap(:,1))
        fill([0 1 1 0 0],[i-1 i-1 i i i-1],cmap(i,1:3));
        hold all

    end
    xlim([0 3])
    ylim([0 i])
end
end




