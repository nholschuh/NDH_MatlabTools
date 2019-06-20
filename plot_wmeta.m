function ph = plot_wmeta(varargin)
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
% additional selectable value - This can be a vector, a string, or a cell
%       array of values that will display when x/y coordinates are selected
% +args - anything that follows x and y in a normal plot command 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fh = gcf;
if length(varargin) > 3
    ph = plot(varargin{[1:2 4:end]});
else
    ph = plot(varargin{1:2});
end

if length(varargin{3}) == 1 & length(varargin{3}) ~= length(varargin{1})
    set(ph,'UserData',repmat(varargin{3},length(varargin{1}),1));
else
    set(ph,'UserData',varargin{3});
end

dcm = datacursormode(fh);
datacursormode on
set(dcm, 'updatefcn', @myfunction)
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

if isstr(obj.Host.UserData) == 1
    output_txt(end+1:end+2) = {[' '],['Value: ',obj.Host.UserData(marker_ind)]};
elseif iscell(obj.Host.UserData) == 1
    output_txt(end+1:end+2) = {[' '],['Value: ',obj.Host.UserData{marker_ind}]};
else
    output_txt(end+1) = {[' ']};
    for i = 1:length(obj.Host.UserData(1,:));
        output_txt(end+1) = {['Value',num2str(i),': ',num2str(obj.Host.UserData(marker_ind,i))]};
    end
end

end
