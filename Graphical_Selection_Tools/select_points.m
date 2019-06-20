function [selected inside_index not_selected outside_index] = select_points(Data,xcol,ycol)
%allows you to subset a dataset based on drawn value boundaries
hold all
plot(Data(:,xcol),Data(:,ycol),'.','Color','black')


vertices = graphical_selection(1);

newdata = [];
counter = 1;

maxx = max(vertices(:,1));
minx = min(vertices(:,1));
maxy = max(vertices(:,2));
miny = min(vertices(:,2));

for i = 1:length(Data(:,1))
    if Data(i,xcol) <= maxx & Data(i,xcol) >= minx
        if Data(i,ycol) <= maxy & Data(i,ycol) >= miny
            newdata(counter,:) = Data(i,:);
            newindecies(counter) = i;
            counter = counter+1;
        end
    end
end


insidevec = within_ndh(newdata,xcol,ycol,vertices);

counter1 = 1;
counter2 = 1;
insidedata = [];
outsidedata = [];
inside_index = [];
outside_index = [];


for i = 1:length(newdata(:,1))
    if insidevec(i) == 1
        insidedata(counter1,:) = newdata(i,:);
        inside_index(counter1) = newindecies(i);
        counter1 = counter1+1;
    else
        outsidedata(counter2,:) = newdata(i,:);
        outside_index(counter2) = newindecies(i);
        counter2 = counter2+1;
    end
end

plot(Data(:,xcol),Data(:,ycol),'.','color','black')
hold all
plot(vertices(:,1),vertices(:,2),'Color','black')
plot(insidedata(:,xcol),insidedata(:,ycol),'o','Color','red')

selected = insidedata;
not_selected = outsidedata;

end
