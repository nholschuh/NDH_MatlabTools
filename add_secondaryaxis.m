function add_secondaryaxis(x_or_y_string,values,label,label_color,log_or_linear,static_or_dynamic)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Adds a secondary label to a given plot

%%
b2 = get(gcf,'children');
if length(b2) > 1;
    b = b2(1);
else
    b = b2;
end


if exist('label_color') == 0
    label_color = 'blue';
end
if exist('label') == 0
    label = '';
end
if exist('log_or_linear') == 0
    log_or_linear = 'linear';
end
if exist('static_or_dynamic') == 0
    static_or_dynamic = 'manual';
else
    if static_or_dynamic == 1;
        static_or_dynamic = 'manual';
    elseif static_or_dynamic == 2;
        static_or_dynamic = 'auto';
    end
end


if x_or_y_string == 'y';
    
    x_axis_positions = get(b,'XTick');
    if iscell(x_axis_positions) == 1
        x_axis_positions = x_axis_positions{1};
    end
    ydir_info = get(b,'YDir');
    if iscell(ydir_info) == 1
        ydir_info = ydir_info{1};
    end    
    
    tick_positions = get(b,'YTick');
    if iscell(tick_positions) == 1
        tick_positions = tick_positions{1};
    end
    
    ticks = length(tick_positions)-1;
    
    start = min(values);
    stop = max(values);
    
    spacing = (stop-start)/ticks;
    
    
    a = axes('YAxisLocation','right','YColor',label_color,'YTick',round([start:spacing:stop]*100)/100,'YTickMode',static_or_dynamic,'YLim',[start stop],'YGrid','on','XTick',x_axis_positions,'XTickMode','auto','XLim',[min(x_axis_positions) max(x_axis_positions)],'Color','none','YDir',ydir_info,'YScale',log_or_linear);    
    ylabel(label)
    linkaxes([a b2],'x')
    
elseif x_or_y_string == 'x';
    
    y_axis_positions = get(b,'YTick');
    if iscell(y_axis_positions) == 1
        y_axis_positions = y_axis_positions{1};
    end    
    xdir_info = get(b,'YDir');
    if iscell(xdir_info) == 1
        xdir_info = xdir_info{1};
    end        
    
    
    tick_positions = get(b,'XTick');
    if iscell(tick_positions) == 1
        tick_positions = tick_positions{1};
    end
    ticks = length(tick_positions)-1;
    
    start = min(values);
    stop = max(values);
    
    spacing = (stop-start)/ticks;
    
    
    a = axes('XAxisLocation','top','XColor',label_color,'XTick',round([start:spacing:stop]*100)/100,'XTickMode',static_or_dynamic,'XLim',[start stop],'XGrid','on','YTick',y_axis_positions,'YTickMode','auto','YLim',[min(y_axis_positions) max(y_axis_positions)],'Color','none','XDir',xdir_info,'XScale',log_or_linear);    
    xlabel(label)
    linkaxes([a b2],'y')

end



