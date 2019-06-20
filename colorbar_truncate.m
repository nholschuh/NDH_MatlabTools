function colorbar_truncate(truncate_vals)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function truncates the colorbar and plots the new values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% truncate_vals - two value matrix containing the min and max values
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

cs = caxis;
colors = colormap;


color_opts = linspace(cs(1),cs(2),length(colors(:,1)));

ind1 = find_nearest(color_opts,truncate_vals(1));
ind2 = find_nearest(color_opts,truncate_vals(2));

colors = colors(ind1:ind2,:);
caxis([color_opts(ind1) color_opts(ind2)])

colormap(colors)