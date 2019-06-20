function [selected not_selected] = graphical_selection_within_corners(Data,xcol,ycol)
% Provides a graphical selection tool for the data

figure1 = figure(1);
plot(Data(:,xcol),Data(:,ycol),'.','Color','black')
hold all
vertices = graphical_selection(1);

maxx = max(vertices(:,1));
minx = min(vertices(:,1));
maxy = max(vertices(:,2));
miny = min(vertices(:,2));


insidedata = [];
outsidedata = [];
counter1 = 1;
counter2 = 2;
signal = 99;

for i = 1:length(Data(:,1))
        if Data(i,xcol) <= maxx & Data(i,xcol) >= minx
            if Data(i,ycol) <= maxy & Data(i,ycol) >= miny
                insidedata(counter1,:) = Data(i,:);
                counter1 = counter1+1;
                signal = 1;
            end
        end
        if signal == 99
            outsidedata(counter2,:) = Data(i,:);
            counter2 = counter2+1;
        end
        signal = 99;
end


plot(Data(:,xcol),Data(:,ycol),'.','color','black')
hold all
plot(vertices(:,1),vertices(:,2),'Color','black')
plot(insidedata(:,xcol),insidedata(:,ycol),'o','Color','red')

selected = insidedata;
not_selected = outsidedata;

end

