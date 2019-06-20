function colorbar_ndh(axis_label,nowidth_flag,width_frac,height_frac,bottom_top_frac,seperation_frac)
% (C) Nick Holschuh - Penn State University - 2017 (Nick.Holschuh@gmail.com)
% This plots a colorbar with adjusted width, spacing, and properties.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% axis_label - The Total Axis label plotted to the right of the bar
% nowidth_flag - If there should be no width adjustment to the original
%                   plot [1]
% width_frac - The fraction of the original colorbar width to plot
% height_frac - The fraction of the original height to plot
% bottom_top_frac - Vertical position along the figure for the colorbar to
%                   plot [0 - Bottom aligned up to 1 - Top aligned];
% seperation_frac - whether or not to separate the colorbar further by a
%                   fractional amount from the plot
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('nowidth_flag') == 0
    nowidth_flag = 1;
end

if exist('width_frac') == 0
    width_frac = 1;
end

if exist('height_frac') == 0
    height_frac = 1;
end

if exist('bottom_top_frac') == 0
    bottom_top_frac = 0;
end

if exist('seperation_frac') == 0
    seperation_frac = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here we get the initial position of the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% axes, as well as the position
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% post-addition of colorbar, and the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% position of the colorbar
pos1 = get(gca,'Position');
ccs = colorbar;
ylabel(ccs,axis_label)
pos2 = get(gca,'Position');

cs = get(gcf,'Children');

for i = 1:length(cs)
    if length(cs(i).Type) == 8
        if cs(i).Type == 'colorbar';
            cpos = get(cs(i),'Position');
            c_num = i;
            break
        end
    end
end

cpos_final = cpos;

%%% pos2 - main axis positions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This is the correction required to shift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% everything back to its position
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% pre-colorbar addition
if nowidth_flag == 1
  
    sep = cpos(1)-(pos2(1)+pos2(3));
    set(gca,'Position',pos1);
    
    cpos_final(1) = pos1(1)+pos1(3)+abs(sep)*seperation_frac;
end

cpos_final(3) = cpos_final(3)*width_frac;

vert_range = cpos_final(4)*(1-height_frac);
cpos_final(4) = cpos_final(4)*height_frac;

    cpos_final(2) = cpos(2)+bottom_top_frac*vert_range;

set(cs(c_num),'Position',cpos_final)


end