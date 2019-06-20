function text_tl(input_text,top_inset_px,left_inset_px);
% (C) Nick Holschuh - Penn State University - 2017 (Nick.Holschuh@gmail.com)
% This is designed to plot text in the top left corner of the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input_text - The string containing the text to be displayed
% top_inset_px - The distance from the top boundary the text should be in
%                   pixels
% left_inset_px - The distance from the left boundary the text should be in
%                   pixels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


xl = get(gca,'XLim');
yl = get(gca,'YLim');
dx = xl(2)-xl(1);
dy = yl(2)-yl(1);
as = get(gca,'Position');
fs = get(gcf,'Position');

as_px = [as(3)*fs(3) as(4)*fs(4)];

if exist('top_inset_px') == 0
    top_inset_px = 20;
end

if exist('left_inset_px') == 0
    left_inset_px = 20;
end


pvx = left_inset_px/as_px(1)*dx+xl(1);
pvy = yl(2)-top_inset_px/as_px(2)*dy;


hold all
text(pvx,pvy,input_text,'HorizontalAlignment','left')

end


