function [inds_mat] = within_grid(xaxis,yaxis,poly_x,poly_y)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Finds the cells of a matrix that fall within a given outline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% xaxis - xaxis for the matrix
% yaxis - yaxis for the matrix
% poly_x - x coordinates for the outlining polygon
% poly_y - y coordinates for the outlining polygon
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inds_mat - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
as_x = size(xaxis);
if as_x(1) > as_x(2)
    xaxis = xaxis';
end

as_y = size(yaxis);
if as_y(1) > as_y(2)
    yaxis = yaxis';
end

six = max([1 find_nearest(xaxis,min(poly_x))-1]);
eix = min([find_nearest(xaxis,max(poly_x))+1 length(xaxis)]);

siy = max([1 find_nearest(yaxis,min(poly_y))-1]);
eiy = min([find_nearest(yaxis,max(poly_y))+1 length(yaxis)]);

pts2 = combvec(six:eix,siy:eiy)';
orig_inds = sub2ind([length(yaxis),length(xaxis)],pts2(:,2),pts2(:,1));

pts = combvec(xaxis(six:eix),yaxis(siy:eiy))';

inds_temp = find(within(pts(:,1),pts(:,2),poly_x,poly_y));
inds = orig_inds(inds_temp);

inds_mat = zeros(length(yaxis),length(xaxis));
inds_mat(inds) = 1;

debug = 0;

if debug == 1
    a = subplot(1,2,1);
    hold off
    imagesc(xaxis,yaxis,zeros(length(yaxis),length(xaxis)))
    hold all
    plot(poly_x,poly_y,'Color','black')
    plot(pts(:,1),pts(:,2),'.','Color','black')
    plot(pts(inds_temp,1),pts(inds_temp,2),'.','Color','blue')
    
    b = subplot(1,2,2);
    hold off
    imagesc(xaxis,yaxis,inds_mat)
    hold all
    plot(poly_x,poly_y,'Color','black')
    
    linkaxes([a b],'xy')
end


end