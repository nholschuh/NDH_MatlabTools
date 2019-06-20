function colorlock
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
%% Finds the most recently plotted image and locks in its color structure.

childs = get(gca,'Children');
for i = 1:length(childs)
    if length(childs(i).Type) == 5
        if childs(i).Type == 'image'
            ci = i;
            break
        end
    elseif length(childs(i).Type) == 7
        if childs(i).Type == 'surface'
            ci_delete = i;
            break
        end
    end
end

if exist('ci') == 0
    fr = getframe(gca);
    NCData = fr.cdata;
    xv_axis = get(gca,'XLim');
    yv_axis = get(gca,'YLim');
    xv = xv_axis;
    yv = yv_axis;
    yinf = get(gca,'YDir');
    
    if length(yinf) == 6
        NCData(:,:,1) = flipud(NCData(:,:,1));
        NCData(:,:,2) = flipud(NCData(:,:,2));
        NCData(:,:,3) = flipud(NCData(:,:,3));
    end
    
    if exist('ci_delete')
        delete(childs(ci_delete));
    end
else
    
    xv = childs(ci).XData;
    yv = childs(ci).YData;
    [CData colors] = get_colormap_and_index;
    NCData = ind2rgb(CData,colors);
    xv_axis = get(gca,'XLim');
    yv_axis = get(gca,'YLim');
    yinf = get(gca,'YDir');
    
    delete(childs(ci));
end


imagesc(xv,yv,NCData);
xlim(xv_axis)
ylim(yv_axis)
set(gca,'YDir',yinf)


end





