function heighten_figure(percent_to_heighten);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This takes a current figure window and adds width in the horizontal
% dimension.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% percent_to_heighten - either a 1 or 2 value vector, indicating how much to
% add to each side (in terms of percent), or how much to add to left and
% how much to add to right.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

figpos = get(gcf,'Position');
axpos = get(gca,'Position');


if length(percent_to_heighten) == 1 & percent_to_heighten ~= -1
    add_percent = [percent_to_heighten percent_to_heighten];
elseif length(percent_to_heighten) == 2
    add_percent = percent_to_heighten;
else
    add_percent = [-axpos(2) -1*(1-axpos(2)-axpos(4))];
end

pixel_percent = figpos(3);

new_figpos = figpos;
new_figpos(2) = new_figpos(2)-pixel_percent*add_percent(1);
new_figpos(4) = new_figpos(4)+pixel_percent*add_percent(1)+pixel_percent*add_percent(2);

if percent_to_heighten ~= -1
    new_axpos = axpos;
    new_axpos(2) = (axpos(2)+add_percent(1))/(1+add_percent(1)+add_percent(2));
    new_axpos(4) = new_axpos(4)/(1+add_percent(2)+add_percent(2));
else
    new_axpos = axpos;
    new_axpos(2) = 0;
    new_axpos(4) = 1;
end

set(gcf,'Position',new_figpos);
set(gca,'Position',new_axpos);


%%%%%%% Reposition any colorbars
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

if exist('cpos') ~= 0
    original_pixel = figpos(2)+figpos(4)*cpos(1);
    new_pixel_width = new_figpos(4);
    final_pixel = original_pixel - new_figpos(2);
    
    original_width = figpos(4)*cpos(4);
    new_width = original_width/new_pixel_width;
       
    
    cpos_final = cpos;
    cpos_final(2) = final_pixel/new_figpos(4);
    cpos_final(4) = new_width;
    
    
    set(cs(c_num),'Position',cpos_final)
end

end






