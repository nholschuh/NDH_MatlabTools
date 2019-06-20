%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   THE FOLLOWING THINGS ARE REQUIRED IN PARENT SCRIPT
%
%
%    plotnum = 1
%    xmin = 
%    xmax = 
%    ymin = 
%    ymax = 
%    xrange = xmax-xmin;
%    yrange = ymax-ymin;
%
%    zoominfactor =                     %Value between 0-1
%    zoomoutfactor = 1/zoominfactor
%
% contour_storage = []
% 
% i = 1;
% start = 1;
% temp = zeros(1,3);
% 
% while i == 1
%     temp = zeros(1,3);
%     subplot(1,2,1)
%     [temp(1),temp(2),temp(3)] = ginput(1);
%     contour_storage(i,:) = temp;
%     ContourPicker_KeyFunctions      %Tool set for zooming, next line
%     i = i+1;
% end
% if i > 1
%     while contour_storage(i-1,3) ~= 113
%         if contour_storage(i-1,3) == 110
%             contour_storage(i-1,:) = [0 0 10];
%             start = i;
%         end
%        
%         temp = zeros(1,3);
%         [temp(1),temp(2),temp(3)] = ginput(1);
%         contour_storage(i,:) = temp;
% 
%         ContourPicker_KeyFunctions;
%         
%         i = i+1;
%     end
% end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if temp(3) == 122             % Developing a zoom command (z key)
    if temp(1)-zoominfactor*xrange > xmin
        if temp(1) + zoominfactor*xrange < xmax
            x1 = temp(1) - zoominfactor*xrange;
            x2 = temp(1) + zoominfactor*xrange;
        else
            x1 = xmax - 2*zoominfactor*xrange;
            x2 = xmax;
        end
    else
        xrange
        zoominfactor
        temp(1)
        temp(1)-zoominfactor*xrange
        xmin
        x1 = xmin;
        x2 = xmin + 2*zoominfactor*xrange;
    end
    if temp(2)-zoominfactor*yrange > ymin
        if temp(2) + zoominfactor*yrange < ymax
            y1 = temp(2)-zoominfactor*yrange;
            y2 = temp(2)+zoominfactor*yrange;
        else
            y1 = ymax - 2*zoominfactor*yrange;
            y2 = ymax;
        end
    else
        y1 = ymin;
        y2 = ymin + 2*zoominfactor*yrange;
    end
    xrange = zoominfactor*xrange;
    yrange = zoominfactor*yrange;
    
    if plotnum == 1
        xlim([x1 x2])
        ylim([y1 y2])
    end
    if plotnum == 2
        subplot(1,2,1)
        xlim([x1 x2])
        ylim([y1 y2])
        subplot(1,2,2)
        xlim([x1 x2])
        ylim([y1 y2])
    end
    i = i-1;
end

if temp(3) == 90             % Developing a zoom out command (Z key)
    if temp(1)-zoomoutfactor*xrange > xmin
        if temp(1) + zoomoutfactor*xrange < xmax
            x1 = temp(1) - zoomoutfactor*xrange;
            x2 = temp(1) + zoomoutfactor*xrange;
        else
            x1 = xmax - 2*zoomoutfactor*xrange;
            x2 = xmax;
        end
    else
        x1 = xmin;
        x2 = xmin + 2*zoomoutfactor*xrange;
    end
    if temp(2)-zoomoutfactor*yrange > ymin
        if temp(2) + zoomoutfactor*yrange < ymax
            y1 = temp(2)-zoomoutfactor*yrange;
            y2 = temp(2)+zoomoutfactor*yrange;
        else
            y1 = ymax - 2*zoomoutfactor*yrange;
            y2 = ymax;
        end
    else
        y1 = ymin;
        y2 = ymin + 2*zoomoutfactor*yrange;
    end
    xrange = zoomoutfactor*xrange;
    yrange = zoomoutfactor*yrange;
    if plotnum == 1
        xlim([x1 x2])
        ylim([y1 y2])
    end
    if plotnum == 2
        subplot(1,2,1)
        xlim([x1 x2])
        ylim([y1 y2])
        subplot(1,2,2)
        xlim([x1 x2])
        ylim([y1 y2])
    end
    i = i-1;
end


if temp(3) == 109    %Build a Max Zoom out function for m key
    if plotnum == 1
        xlim([xmin xmax])
        ylim([ymin ymax])
    end
    if plotnum == 2
        subplot(1,2,1)
        xlim([xmin xmax])
        ylim([ymin ymax])
        subplot(1,2,2)
        xlim([xmin xmax])
        ylim([ymin ymax])
    end
    xrange = (xmax-xmin)/2;
    yrange = (ymax-ymin)/2;
    i = i-1;
end

if temp(3) == 99        %Build a centering function for the c key
    if temp(1)-xrange > xmin
        if temp(1) + xrange < xmax
            x1 = temp(1) - xrange;
            x2 = temp(1) + xrange;
        else
            x1 = xmax - xrange;
            x2 = xmax;
        end
    else
        x1 = xmin;
        x2 = xmin + xrange;
    end
    if temp(2)-yrange > ymin
        if temp(2) + yrange < ymax
            y1 = temp(2)-yrange;
            y2 = temp(2)+yrange;
        else
            y1 = ymax - 2*yrange;
            y2 = ymax;
        end
    else
        y1 = ymin;
        y2 = ymin + 2*yrange;
    end
    if plotnum == 1
        xlim([x1 x2])
        ylim([y1 y2])
    end
    if plotnum == 2
        subplot(1,2,1)
        xlim([x1 x2])
        ylim([y1 y2])
        subplot(1,2,2)
        xlim([x1 x2])
        ylim([y1 y2])
    end
    i = i-1;
end

if temp(3) == 117    %Build an undo function for the u key
    i = i-2
    delete(cline);
    clear cline;
    if plotnum == 1
        cline = plot(contour_storage(start:(i),1),contour_storage(start:(i),2),'Color','black','LineWidth',2);
    end
    if plotnum == 2
        delete(c2line);
        clear c2line;
        subplot(1,2,1)
        cline = plot(contour_storage(start:(i),1),contour_storage(start:(i),2),'Color','black','LineWidth',2);
        subplot(1,2,2)
        c2line = plot(contour_storage(start:(i),1),contour_storage(start:(i),2),'Color','black','LineWidth',2);
    end
end

if temp(3) == 1           % If the selection was using the mouse button
    if i > 1
        if exist('cline','var') == 1
            if contour_storage(i-1,3) ~= 10
                delete(cline);
                clear cline;
            end
        end
    end
    if i > 1
        if exist('c2line','var') == 1
            if contour_storage(i-1,3) ~= 10
                delete(c2line);
                clear c2line;
            else
                clear c2line
            end
        end
    end
    if plotnum == 1
        cline = plot(contour_storage(start:(i),1),contour_storage(start:(i),2),'Color','black','LineWidth',2);
    end
    if plotnum == 2
        subplot(1,2,1)
        cline = plot(contour_storage(start:(i),1),contour_storage(start:(i),2),'Color','black','LineWidth',2);
        subplot(1,2,2)
        c2line = plot(contour_storage(start:(i),1),contour_storage(start:(i),2),'Color','black','LineWidth',2);
    end
end
