function ph = scatter_wmeta(varargin)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This allows you to plot 2D data from a normal line plot, but when data
% are selected, it will provide info for an additional attribute provided
% in the third position of the function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x - x coordinates to plot
% y - y coordinates to plot
% s - size variable
% c - color variable
% +args - anything that follows x and y in a normal plot command 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fh = gcf;

clims = caxis;
cmap = colormap;

cval = varargin{4};
colorind = ceil((cval-min(cval))*(length(cmap(:,1))-1)/range(cval))+1;
colorind(find(colorind > 64)) = 64;
colors = cmap(colorind,:);

if length(varargin) == 4
    ph = scatter(varargin{1},varargin{2},varargin{3},colors);
else
   ph = scatter(varargin{1},varargin{2},varargin{3},colors,varargin{5});
end

sz = size(varargin{4});
if length(varargin{3}) == 1
    if sz(1) > sz(2)
        set(ph,'UserData',[ones(size(varargin{4}))*varargin{3} varargin{4}]);
    else
        set(ph,'UserData',[ones(size(varargin{4}'))*varargin{3} varargin{4}']);
    end
else
    if sz(1) > sz(2)
        set(ph,'UserData',[varargin{3} varargin{4}]);
    else
        set(ph,'UserData',[varargin{3}' varargin{4}']);
    end
end

caxis([min(cval) max(cval)])
colorbar


dcm = datacursormode(fh);
datacursormode on;
set(dcm, 'updatefcn', @myfunction);
end



function output_txt = myfunction(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
output_txt = {['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end

%%%%%%%%%%%%%%%% Here we add in the additional text
marker_ind = obj.Cursor.DataIndex;

output_txt{end+1} = ['Size: ',num2str(obj.Host.UserData(marker_ind,1))];
output_txt{end+1} = ['Color: ',num2str(obj.Host.UserData(marker_ind,2))];

%%%%%%%%%%%%%%%% Here we add in the additional text
marker_ind = obj.Cursor.DataIndex;

end
