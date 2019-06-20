function NDH_style(xaxis_lrc,yaxis_tbc,shifterx,shiftery,change_points)
% This function applies standard styles for matlab plots. Enter:
% xaxis_lrc = '[l,r,c][t,b]'
% yaxis_udc = '[t,b,c][l,r]'
%%% This applies a standardized style for plots in matlab

if exist('xaxis_lrc') == 0 || length(xaxis_lrc) == 1
    xaxis_lrc = 'rb';
end
if exist('yaxis_tbc') == 0 || length(yaxis_tbc) == 1
    yaxis_tbc = 'tl';
end
if exist('shiftery') == 0
    shifterx = 0;
end
if exist('shiftery') == 0
    shiftery = 0;
end
if exist('change_points') == 0
    change_points = 0;
end

fig_pos = get(gcf,'Position');
axis_pos = get(gca,'Position');

ylabs = get(gca,'YTickLabel');
for i = 1:length(ylabs)
    length_offsety(i) = length(ylabs{i});
end

xlabs = get(gca,'XTickLabel');
for i = 1:length(xlabs)
    length_offsetx(i) = length(xlabs{i});
end

%%%%%%%%% Determined using the xticks
ytitle_offset = 12*max(length_offsety); % offset in pixels
xtitle_offset = 20; % offset in pixels
xaxis_width = axis_pos(3)*fig_pos(3);
y_offset = ytitle_offset/xaxis_width;
yaxis_width = axis_pos(4)*fig_pos(4);
x_offset = xtitle_offset/yaxis_width;


fid = gca;

xt = get(fid,'XLabel');
yt = get(fid,'YLabel');

fn = 'Helvetica';
fs = 12;
fw = 'bold';

if xaxis_lrc == 'lb'
    xlabel(xt.String,'Units','normalized','Position',[0 -x_offset],'HorizontalAlignment','left','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif xaxis_lrc == 'cb'
    xlabel(xt.String,'Units','normalized','Position',[0.5 -x_offset],'HorizontalAlignment','center','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif xaxis_lrc == 'rb'
    xlabel(xt.String,'Units','normalized','Position',[1 -x_offset],'HorizontalAlignment','right','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif xaxis_lrc == 'lt'
    xlabel(xt.String,'Units','normalized','Position',[0 1+x_offset],'HorizontalAlignment','left','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif xaxis_lrc == 'ct'
    xlabel(xt.String,'Units','normalized','Position',[0.5 1+x_offset],'HorizontalAlignment','center','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif xaxis_lrc == 'rt'
    xlabel(xt.String,'Units','normalized','Position',[1 1+x_offset],'HorizontalAlignment','right','FontName',fn,'FontSize',fs,'FontWeight',fw)
end

if xaxis_lrc(2) == 't'
    set(fid,'XAxisLocation','top')
    if shiftery == 1
        set(fid,'Position',[axis_pos(1) axis_pos(2)-xtitle_offset/2/fig_pos(4) axis_pos(3:4)])
        axis_pos = get(fid,'Position');
    end
elseif xaxis_lrc(2) == 'b'
    set(fid,'XAxisLocation','bottom')
    if shiftery == 1
        set(fid,'Position',[axis_pos(1) axis_pos(2)+xtitle_offset/2/fig_pos(4) axis_pos(3:4)])
        axis_pos = get(fid,'Position')
    end
end

if yaxis_tbc == 'tl'
    ylabel(yt.String,'Units','normalized','Position',[-y_offset 1],'HorizontalAlignment','right','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif yaxis_tbc == 'bl'
    ylabel(yt.String,'Units','normalized','Position',[-y_offset 0],'HorizontalAlignment','left','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif yaxis_tbc == 'cl'
    ylabel(yt.String,'Units','normalized','Position',[-y_offset 0.5],'HorizontalAlignment','center','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif yaxis_tbc == 'tr'
    ylabel(yt.String,'Units','normalized','Position',[1+y_offset 1],'HorizontalAlignment','right','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif yaxis_tbc == 'br'
    ylabel(yt.String,'Units','normalized','Position',[1+y_offset 0],'HorizontalAlignment','left','FontName',fn,'FontSize',fs,'FontWeight',fw)
elseif yaxis_tbc == 'cr'
    ylabel(yt.String,'Units','normalized','Position',[1+y_offset 0.5],'HorizontalAlignment','center','FontName',fn,'FontSize',fs,'FontWeight',fw)
end

if yaxis_tbc(2) == 'l'
    set(fid,'YAxisLocation','left')
    if shifterx == 1
        set(fid,'Position',[axis_pos(1)+ytitle_offset/2/fig_pos(3) axis_pos(2:4)])
    end
elseif yaxis_tbc(2) == 'r'
    set(fid,'YAxisLocation','right')
    if shifterx == 1
        set(fid,'Position',[axis_pos(1)-ytitle_offset/2/fig_pos(3) axis_pos(2:4)])
    end
end

if change_points == 1
    childs = get(fid,'Children');
    if length(childs) == 1
        if length(get(childs,'type')) == 4 && min(get(childs,'type') == 'line')
            set(childs,'MarkerSize',4,'MarkerFaceColor',[0.6 0.6 0.6],'Color','black');
        end
    end
end

as = 10;
set(fid,'FontSize',as)
set(gcf,'Color','white')

end
