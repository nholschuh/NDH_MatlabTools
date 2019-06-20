function write_colormap_to_gmt(filename,colors);
% Writes the current colormap out to gmt format
if exist('colors') == 0
    colors = colormap;
    cvals = caxis;
else
    cvals = 1:length(colors(:,1));
end
colors = [colors*255 (1:length(colors(:,1)))'/length(colors(:,1))];


d_or_c = 0;

axis = linspace(cvals(1),cvals(2),length(colors(:,1))+(1-d_or_c));

%%%% Not sure what this does exactly?
% if axis(2)-axis(1) < 1
%     dx = round(0.8/(axis(2)-axis(1)));
%     colors = colormap;
%     colors = colors(1:dx:end,:)*255;
%     cvals = caxis;
%     axis = linspace(cvals(1),cvals(2),length(colors(:,1)));
% end



plotter = 0;
gmt_colormap(colors,axis,filename,0,d_or_c,0,plotter);
end


