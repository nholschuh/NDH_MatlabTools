function [distance projection] = point_line_distance(point,line1,line2,plotindicator)
% Supply the two endpoints of a line (line1,line2), and the coordinates of the points. 
% This function calculates the orthoganal distance from a point to a line
% in 3d space

if length(line1) == 2
    line1(3) = 0;
    line2(3) = 0;
    point(3) = 0;
    twod_flag = 1;
else
    twod_flag = 0;
end

d = norm(cross(line2-line1,point-line1))/norm(line2-line1);
projection = line1 + (dot(line2-line1,point-line1)/norm(line2-line1)^2)*(line2-line1);


if exist('plotindicator') == 1
    plot3([line1(1) line2(1)],[line1(2) line2(2)],[line1(3) line2(3)],'Color','black','LineWidth',2)
    grid on
    set(gca,'DataAspectRatio',[1 1 1])
    hold all
    plot3(point(1),point(2),point(3),'o','Color','blue')
    plot3(projection(1),projection(2),projection(3),'.','Color','red')
    plot3([point(1) projection(1)],[point(2) projection(2)],[point(3) projection(3)],'Color','blue')
    hold off
end

distance = d;

if twod_flag == 1
    projection = projection(1:2);
end

end

