function caxis_local
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
%%
xl = get(gca,'xlim');
yl = get(gca,'ylim');

present_plots = get(gca,'Children');


for i = 1:length(present_plots)
    
    if length(present_plots(i).Type) == 5
        if present_plots(i).Type == 'image'
            cinfo = present_plots(i).CData;
            xaxis = linspace(present_plots(i).XData(1),present_plots(i).XData(end),length(cinfo(1,:)));
            xaxis = xaxis(1:end-1)+(xaxis(2)-xaxis(1))/2;
            yaxis = linspace(present_plots(i).YData(1),present_plots(i).YData(end),length(cinfo(:,1)));
            yaxis = yaxis(1:end-1)+(yaxis(2)-yaxis(1))/2;
            
            dix = find(xaxis > xl(1) & xaxis < xl(2));
            diy = find(yaxis > yl(1) & yaxis < yl(2));
            
            c_opts = present_plots(i).CData(diy,dix);
            c_opts(isnan(c_opts)) = mean(mean(c_opts));
            
            caxis([min(min(c_opts)) max(max(c_opts))]);
            break
        end
    elseif length(present_plots(i).Type) == 7
        if present_plots(i).Type == 'scatter'
            di = find(present_plots(i).XData > xl(1) & present_plots(i).XData < xl(2) & ...
                present_plots(i).YData > yl(1) & present_plots(i).YData < yl(2));
            
            if length(di) > 0
                caxis([min(present_plots(i).CData(di)) max(present_plots(i).CData(di))]);
            end            
            
        elseif present_plots(i).Type == 'surface'
            ri = find(present_plots(i).YData > yl(1) & present_plots(i).YData < yl(2));
            ci = find(present_plots(i).XData > xl(1) & present_plots(i).XData < xl(2));
            caxis([min(min(present_plots(i).CData(ri,ci))) max(max(present_plots(i).CData(ri,ci)))]);
        end
    end
end


