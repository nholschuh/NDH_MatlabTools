function plot_indicator_lines(values,horiz1_or_vert2_or_sloped3,color_lines,width,linestyle)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
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

if exist('color_lines') == 0
    color_lines = 'blue';
end
if exist('width') == 0;
    width = 1;
end
if exist('linestyle') == 0;
    linestyle = '-';
end

if horiz1_or_vert2_or_sloped3 == 1
    Xs = get(gca,'XLim');
    for i = 1:length(values)
        plot(Xs,[values(i) values(i)],'Color',color_lines,'LineWidth',width,'LineStyle',linestyle)
    end
elseif horiz1_or_vert2_or_sloped3 == 2
    Ys = get(gca,'YLim');
    for i = 1:length(values)
        plot([values(i) values(i)],Ys,'Color',color_lines,'LineWidth',width,'LineStyle',linestyle)
    end    
elseif horiz1_or_vert2_or_sloped3 == 3
    Xs = get(gca,'XLim');
    Ys = values(1)*(Xs)+values(2);
    for i = 1:length(values)
        plot(Xs,Ys,'Color',color_lines,'LineWidth',width,'LineStyle',linestyle)
    end   
    
end