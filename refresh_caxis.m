function refresh_caxis()

ylimits = get(gca,'YLim');
xlimits = get(gca,'XLim');
childs = get(gca,'Children');

for i = 1:length(childs)
    if length(get(childs(i),'Type')) == 5
        if get(childs(i),'Type') == 'image'
           xaxis = get(childs(i),'XData');
           yaxis = get(childs(i),'YData');
           cdata = get(childs(i),'CData');
        end
    end
end

rows = find_nearest(xaxis,xlimits(1));
rows = [rows find_nearest(xaxis,xlimits(2))];
columns = find_nearest(yaxis,ylimits(1));
columns = [columns find_nearest(yaxis,ylimits(2))];

color_range = [min(min(cdata(rows(1):rows(2),columns(1):columns(2)))) max(max(cdata(rows(1):rows(2),columns(1):columns(2))))];
caxis(color_range);

end

