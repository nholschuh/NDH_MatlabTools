function widen_figure(fraction_to_widen);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This takes a current figure window and adds width in the horizontal
% dimension.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% percent_to_widen - either a 1 or 2 value vector, indicating how much to
% add to each side (in terms of percent), or how much to add to left and
% how much to add to right.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

figpos = get(gcf,'Position');
axpos = get(gca,'Position');

pixel_percent = figpos(3);

if length(fraction_to_widen) == 1 & fraction_to_widen(1) ~= -1
    add_percent = [fraction_to_widen fraction_to_widen];
elseif length(fraction_to_widen) == 2
    add_percent = fraction_to_widen;
else
    add_percent = [-axpos(1) -1*(1-axpos(1)-axpos(3))];
end


new_figpos = figpos;
new_figpos(1) = new_figpos(1)-pixel_percent*add_percent(1);
new_figpos(3) = new_figpos(3)+pixel_percent*add_percent(1)+pixel_percent*add_percent(2);

if fraction_to_widen ~= -1
new_axpos = axpos;
new_axpos(1) = (axpos(1)+add_percent(1))/(1+add_percent(1)+add_percent(2));
new_axpos(3) = new_axpos(3)/(1+add_percent(1)+add_percent(2));
else
new_axpos = axpos;
new_axpos(1) = 0;
new_axpos(3) = 1;    
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
    original_pixel = figpos(1)+figpos(3)*cpos(1);
    new_pixel_width = new_figpos(3);
    final_pixel = original_pixel - new_figpos(1);
    
    original_width = figpos(3)*cpos(3);
    new_width = original_width/new_pixel_width;
       
    
    cpos_final = cpos;
    cpos_final(1) = final_pixel/new_figpos(3);
    cpos_final(3) = new_width;
    
    
    set(cs(c_num),'Position',cpos_final)
end

end






