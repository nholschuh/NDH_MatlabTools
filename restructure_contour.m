function cs = restructure_contour(contour_out,outtype)

if exist('outtype') == 0
    outtype = 0;
end

%%%%%%%%%%%%%%% This portion finds the contourline breaks
break_points = 1;

while break_points(end) < length(contour_out(1,:))
    break_points(end+1) = break_points(end)+contour_out(2,break_points(end))+1;
end

break_points = break_points(1:end-1);


if outtype == 0
    contour_out(:,break_points) = NaN;
    cs = contour_out';

elseif outtype == 1

    break_points = [1 break_points length(contour_out(1,:))+1];
    for i =1:length(break_points)-1
    cs{i} = contour_out(:,break_points(i)+1:break_points(i+1)-1)';
    end
end



