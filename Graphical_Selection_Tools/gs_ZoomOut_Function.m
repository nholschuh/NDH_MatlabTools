if temp(3) == 90             % Developing a zoom out command (Z key)
    x1 = max([xmin temp(1)-zoomoutfactor*xrange/2]);
    x2 = min([xmax temp(1)+zoomoutfactor*xrange/2]);
    
    y1 = max([ymin temp(2)-zoomoutfactor*yrange/2]);
    y2 = min([ymax temp(2)+zoomoutfactor*yrange/2]);
%     
%     if x2-x1 < xrange | y2-y1 > yrange
%         if temp(1)-xmin < xmax-temp(1)
%             x1 = xmin;
%             x2 = min([xmax xmin+zoomoutfactor*xrange]);
%         else
%             x1 = max([xmin xmax-zoomoutfactor*xrange]);
%             x2 = xmax;
%         end
%         if temp(2)-ymin < ymax-temp(2)
%             y1 = ymin;
%             y2 = min([ymax ymin+zoomoutfactor*xrange]);
%         else
%             y1 = max([ymin ymax-zoomoutfactor*xrange]);
%             y2 = ymax;
%         end
%     end
%     
%     xlim([x1 x2])
%     ylim([y1 y2])
xlim([xmin xmax])
ylim([ymin ymax])
    
    i = i-1;
end

if temp(3) == 105       % Recover to initial zoom
    xlim([xr_init])
    ylim([yr_init])
    
    i = i-1;
    
end