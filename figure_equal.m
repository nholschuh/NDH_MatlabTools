function figure_equal


xs = get(gca,'XLim');
ys = get(gca,'YLim');

ar = (ys(2)-ys(1))/(xs(2)-xs(1));

pos = get(gcf,'Position');

cp = [pos(1)+pos(3)/2 pos(2)+pos(4)/2];

if pos(4)/pos(3) > ar
    width = pos(3);
    height = pos(3)*ar;
else
    height = pos(4);
    width = height/ar;
end

set(gcf,'Position',[cp-[width/2 height/2] width height]);
