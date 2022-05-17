function [ax_handle subhandle] = subplot_ndh(row,col,posit,marginfrac,subhandle)
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This allows you to put in a subplot with fixed axes position limits based
% on a scaling of normal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% row - The number of rows of figures to include in the grid
% col - The number of columns of figures to include in the grid
% posit - Which number within the row/column grid to plot on
% marginfrac - The fraction of the expected margins between plots to
%               include
% subhandle - If you want to add the handle to a grid of handles, for
%               referencing later
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ax_handle - The handle for the specific subaxis being plotted
% subhandle - The matrix of handles for all plotted subplots.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('subhandle') == 0
    subhandle = cell(row,col);
end
if length(subhandle) == 1 | length(subhandle) == 0
    if subhandle == 0
        subhandle = cell(row,col);
    end
    if isempty(subhandle)
        subhandle = cell(row,col);
    end
end

[pc pr] = ind2sub([col row],posit);

if length(subhandle{pr,pc}) > 0
    set(gcf,'CurrentAxes',subhandle{pr,pc})
    ax_handle = subhandle{pr,pc};
else

    cfig = get(gcf,'Handle');
    
    ftemp = figure(99);
    temp_ax = subplot(row,col,1);
    tpos = get(temp_ax,'Position');
    xmarg = (1/col-tpos(3))*marginfrac/2;
    ymarg = (1/row-tpos(4))*marginfrac/2;
    center_pointx = (1/col/2)*(2*pc-1);
    center_pointy = 1-(1/row/2)*(2*pr-1);
    lx = center_pointx-(1/col/2-xmarg);
    ly = center_pointy-(1/row/2-ymarg);
    dx = (1/col-2*xmarg);
    dy = (1/row-2*ymarg);
    close(ftemp);
    
    ax_handle = axes('Position',[lx ly dx dy]);
    subhandle{pr,pc} = ax_handle;
end


end

