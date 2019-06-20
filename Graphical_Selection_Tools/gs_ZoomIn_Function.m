if temp(3) == 122             % Developing a zoom command (z key)
    x1 = max([xmin temp(1)-zoominfactor*xrange/2]);
    x2 = min([xmax temp(1)+zoominfactor*xrange/2]);
    
    y1 = max([ymin temp(2)-zoominfactor*yrange/2]);
    y2 = min([ymax temp(2)+zoominfactor*yrange/2]);
    
    if (x2-x1)/(y2-y1) ~= xrange/yrange
        n_yrange = (x2-x1)/xrange*yrange;
        if temp(2)-n_yrange/2 < ymin
            y1 = ymin;
            y2 = ymin+n_yrange;
        elseif temp(2)+n_yrange/2 > ymax
            y1 = ymax-n_yrange;
            y2 = ymax;
        else
            y1 = temp(2)-n_yrange/2;
            y2 = temp(2)+n_yrange/2;
        end
        
    end
    
    xlim([x1 x2])
    ylim([y1 y2])
    
    i = i-1;
end


if temp(3) == 46             % Developing a shift right command
    x1 = max([xmin max(xlim)]);
    x2 = min([xmax 2*max(xlim)-min(xlim)]);
    
    y1 = max([ymin temp(2)-zoominfactor*yrange/2]);
    y2 = min([ymax temp(2)+zoominfactor*yrange/2]);
    
    if (x2-x1)/(y2-y1) ~= xrange/yrange
        n_yrange = (x2-x1)/xrange*yrange;
        if temp(2)-n_yrange/2 < ymin
            y1 = ymin;
            y2 = ymin+n_yrange;
        elseif temp(2)+n_yrange/2 > ymax
            y1 = ymax-n_yrange;
            y2 = ymax;
        else
            y1 = temp(2)-n_yrange/2;
            y2 = temp(2)+n_yrange/2;
        end
        
    end
    
    xlim([x1 x2])
    ylim([y1 y2])
    
    i = i-1;
end

if temp(3) == 44             % Developing a shift right command
    x1 = max([xmin min(xlim)]);
    x2 = min([xmax 2*min(xlim)-max(xlim)]);
    
    y1 = max([ymin temp(2)-zoominfactor*yrange/2]);
    y2 = min([ymax temp(2)+zoominfactor*yrange/2]);
    
    if (x2-x1)/(y2-y1) ~= xrange/yrange
        n_yrange = (x2-x1)/xrange*yrange;
        if temp(2)-n_yrange/2 < ymin
            y1 = ymin;
            y2 = ymin+n_yrange;
        elseif temp(2)+n_yrange/2 > ymax
            y1 = ymax-n_yrange;
            y2 = ymax;
        else
            y1 = temp(2)-n_yrange/2;
            y2 = temp(2)+n_yrange/2;
        end
        
    end
    
    xlim([x1 x2])
    ylim([y1 y2])
    
    i = i-1;
end