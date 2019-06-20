function [indexfinal intersection] = segment_intersect(line1,line2,plotter)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% This function returns a 1 if the line segments provided intersect or a 0
% if they do not. Input as 2x2 matricies containing the endpoints of the segments in the form 
% [x1 y1;x2 y2])

if exist('plotter') == 0
    plotter = 0;
end

%%%%%%%%%%%%%%%% There was an error that resulted from rounding somewhere
%%%%%%%%%%%%%%%% in the slopeintercept code, so we restrict things to
%%%%%%%%%%%%%%%% accuracy within 8 significant figures

% round_val = order(max(max(abs([line1(1:2,1:2);line2(1:2,1:2)]))));
% round_val = 10^(round_val-8);
% 
% l11 = round_to(line1(1,:),round_val);
% l12 = round_to(line1(2,:),round_val);
% l21 = round_to(line2(1,:),round_val);
% l22 = round_to(line2(2,:),round_val);
l11 = line1(1,:);
l12 = line1(2,:);
l21 = line2(1,:);
l22 = line2(2,:);

index = 0;

[slope1 int1] = slopeintercept(l11,l12);
[slope2 int2] = slopeintercept(l21,l22);

% First we deal with the case where one of the lines is vertical

if slope1 == Inf || slope1 == -Inf
    intersectionx = int1;
    intersectiony = slope2*int1+int2;
    if min([l21(1) l22(1)]) <= int1
        if max([l21(1) l22(1)]) >= int1
            if intersectiony <= max([l11(2) l12(2)])
                if intersectiony >= min([l11(2) l12(2)])
                    index = 1;
                end
            end
        end
    end
end

if index < 1  
    if slope2 == Inf || slope2 == -Inf
        intersectionx = int2;
        intersectiony = slope1*int2+int1;
        if min([l11(1) l12(1)]) <= int2
            if max([l11(1) l12(1)]) >= int2
                if intersectiony <= max([l21(2) l22(2)])
                    if intersectiony >= min([l21(2) l22(2)])
                        index = 1;
                    end
                end
            end
        end
    end
end

% Then we deal with the case where neither line is vertical

if index < 1
    %intersectionx = round_to((int2 - int1)/(slope1-slope2),round_val);
    %intersectiony = round_to(slope1*intersectionx+int1,round_val);
    intersectionx = (int2 - int1)/(slope1-slope2);
    intersectiony = slope1*intersectionx+int1;
    %%%%%% Inside the x coordinates of the first line
    if intersectionx <= max([l11(1) l12(1)])
        if intersectionx >= min([l11(1) l12(1)])
            %%%%%% Inside the x coodinates of the second line
            if intersectionx <= max([l21(1) l22(1)])
                if intersectionx >= min([l21(1) l22(1)])
                    %%%%%% Inside the y coodinates of the second line
                    if intersectiony >= min([l21(2) l22(2)])
                        if intersectiony <= max([l21(2) l22(2)])
                            %%%%% Inside the y coordinates of the first line
                            if intersectiony >= min([l11(2) l12(2)])
                                if intersectiony <= max([l11(2) l12(2)])
                                    index = 1;
                                else
                                    index = 0;
                                end
                            else
                                index = 0;
                            end
                        else
                            index = 0;
                        end
                    else
                        index = 0;
                    end
                else
                    index = 0;
                end
            else
                index = 0;
            end
        else
            index = 0;
        end
    else
        index = 0;
    end
end

if index == 1
    intersection = [intersectionx intersectiony];
else
    intersection = 0;
end
indexfinal = index;

% This can be uncommented if you would like to plot the line segments and their intersection
% after completing the calculations
if plotter == 1
    hold off
    plot([l11(1) l12(1)],[l11(2) l12(2)],'Color','black')
    hold all
    plot([l21(1) l22(1)],[l21(2) l22(2)],'Color','black')
    plot(intersectionx,intersectiony,'o','Color','blue')
end


end

