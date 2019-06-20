function [selected inside_index not_selected outside_index] = select_points_corners(Data,xcol,ycol)
% Provides a graphical selection tool for the data. Select two opposite
% corners and all the data that falls within the box defined by them will
% be extracted.

hold all
plot(Data(:,xcol),Data(:,ycol),'.','Color','black')

vertices = graphical_selection(2);

maxx = max(vertices(:,1));
minx = min(vertices(:,1));
maxy = max(vertices(:,2));
miny = min(vertices(:,2));




inside_index = find(Data(:,xcol) <= maxx & Data(:,xcol) >= minx & Data(:,ycol) <= maxy & Data(:,ycol) >= miny);

outside_index = 1:length(Data(:,1));
outside_index(inside_index) = [];

selected = Data(inside_index,:);
not_selected = Data(outside_index,:);

% for i = 1:length(Data(:,1))
%         if Data(i,xcol) <= maxx & Data(i,xcol) >= minx
%             if Data(i,ycol) <= maxy & Data(i,ycol) >= miny
%                 insidedata(counter1,:) = Data(i,:);
%                 counter1 = counter1+1;
%                 signal = 1;
%             end
%         end
%         if signal == 99
%             outsidedata(counter2,:) = Data(i,:);
%             counter2 = counter2+1;
%         end
%         signal = 99;
% end


plot(Data(:,xcol),Data(:,ycol),'.','color','black')
hold all
plot(vertices(:,1),vertices(:,2),'Color','black')
plot(selected(:,xcol),selected(:,ycol),'o','Color','red')


end

