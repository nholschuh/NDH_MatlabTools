function contour_out2 = plot_contouroutput(contour_out,plottype,linewidth,downsample_rate)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Takes the object that is output from the "contour" function, and plots it
% with either filled shapes or black contour lines of a given line width
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% contour_out - the object produced by contour()
% plottype - [0], contour lines, or 1, filled contours
% linewidth - the value for the contour line width
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%%%%%%%%%% This portion finds the contourline breaks
break_points = 1;

if exist('downsample_rate') == 0
    downsample_rate = 1;
end

if exist('linewidth') == 0
    linewidth = 1;
end

while break_points(end) < length(contour_out(1,:))
    break_points(end+1) = break_points(end)+contour_out(2,break_points(end))+1;
end

break_points = break_points(1:end-1);


if plottype == 0
    contour_out(:,break_points) = NaN;
    contour_out2 = [];
    break_points =  [break_points length(contour_out(:,1))+1];
    num_line_counter = 0;
    if downsample_rate > 1
        for i = 1:length(break_points)-1
            
            if break_points(i+1)-1 - (break_points(i)+1) > downsample_rate*1
                contour_out2 = [contour_out2 ...
                    contour_out(:,break_points(i)+1:downsample_rate:break_points(i+1)-1) [NaN; NaN]];
                num_line_counter = num_line_counter + 1;
            end
        end
    else
        contour_out2 = contour_out;
    end
    
    plot(contour_out2(1,:),contour_out2(2,:),'Color','black','LineWidth',linewidth)
elseif plottype == 1
    break_points(end+1) = length(contour_out(1,:))+1;
    
    for i = 1:length(break_points)-1;
        fill(contour_out(1,break_points(i)+1:break_points(i+1)-1), ...
            contour_out(2,break_points(i)+1:break_points(i+1)-1), ...
            [1 1 1],'FaceAlpha',0.5);
    end
    contour_out2 = contour_out(:,break_points(1)+1:break_points(1+1)-1);
end



