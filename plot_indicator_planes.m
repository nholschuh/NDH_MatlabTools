function plot_indicator_planes(value,horiz1_or_vert2_or_sloped3,EdgeColor,EdgeAlpha,SurfaceColor,SurfAlpha);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Takes a series of points and plots them as horizontal (1) or vertical (2)
% lines on a pre-existing plot
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% values - the x (or y) coordinates where lines are desired. For sloped
%           line, provide [slope x1 y1].
%
% horiz_or_vert - 1 for horizontal, 2 for vertical, 3 for sloped (provide
%                 the slope and a target point to pass through).
%
% color_lines - Either a string or a vector indicating the color
%
% width - the "LineWidth" parameter value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold all

if exist('EdgeColor') == 0
    EdgeColor = 'black';
end
if EdgeColor == 0
    EdgeColor = 'black';
end
if exist('EdgeAlpha') == 0
    EdgeAlpha = 0;
end
if exist('SurfaceColor') == 0
    SurfaceColor = [0 0 0];
end
if exist('SurfAlpha') == 0
    SurfAlpha = 0.2;
end

SurfaceColor = color_call(SurfaceColor);
EdgeColor = color_call(EdgeColor);

if horiz1_or_vert2_or_sloped3 == 1
    Xs = get(gca,'XLim');
    Xs = linspace(Xs(1),Xs(2),10);
    Ys = get(gca,'YLim');
    Ys = linspace(Ys(1),Ys(2),10);
    
    Zs = value;
    [xm ym zm] = meshgrid(Xs,Ys,Zs);

    C(:,:,1) = ones(size(zm))*SurfaceColor(1);
    C(:,:,2) = ones(size(zm))*SurfaceColor(2);
    C(:,:,3) = ones(size(zm))*SurfaceColor(3);
    
    hs = surface(xm,ym,zm,C,'EdgeColor',EdgeColor);
    alpha(hs,SurfAlpha);
    set(hs,'EdgeAlpha',EdgeAlpha)
elseif horiz1_or_vert2_or_sloped3 == 2

elseif horiz1_or_vert2_or_sloped3 == 3

end