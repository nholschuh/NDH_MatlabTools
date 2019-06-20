function outvec = rotate_3d(start_vec,axis_vec,angle,plotter);

if exist('plotter') == 0
    plotter = 0;
end

if length(start_vec(:,1)) == 1
    start_vec = start_vec';
    rotate_flag = 1;
else
    rotate_flag = 0;
end

axis_vec = axis_vec/sqrt(sum(axis_vec.^2));

if angle > 0
    th = deg2rad(angle);
    neg_flag = 0;
else
    th = deg2rad(abs(angle));
    neg_flag = 1;
end

%%%%%%%%%%%% Develop the rotation matrix
R =[cos(th)+axis_vec(1)^2*(1-cos(th))     axis_vec(1)*axis_vec(2)*(1-cos(th))-axis_vec(3)*sin(th)     axis_vec(1)*axis_vec(3)*(1-cos(th))+axis_vec(2)*sin(th); ...
    axis_vec(2)*axis_vec(1)*(1-cos(th))+axis_vec(3)*sin(th)     cos(th)+axis_vec(2)^2*(1-cos(th))     axis_vec(2)*axis_vec(3)*(1-cos(th))-axis_vec(1)*sin(th); ...
    axis_vec(1)*axis_vec(3)*(1-cos(th))-axis_vec(2)*sin(th)     axis_vec(3)*axis_vec(2)*(1-cos(th))+axis_vec(1)*sin(th)     cos(th)+axis_vec(3)^2*(1-cos(th))];

if neg_flag == 0
    outvec = R*start_vec;
else
    outvec = start_vec*2 - R*start_vec;
end


if rotate_flag == 1
    outvec = outvec';
end

if plotter == 1
    hold off
    plot3([0 start_vec(1)],[0 start_vec(2)],[0 start_vec(3)],'Color','red');
    hold all
    plot3([0 axis_vec(1)],[0 axis_vec(2)],[0 axis_vec(3)],'Color','black');
    plot3([0 -axis_vec(1)],[0 -axis_vec(2)],[0 -axis_vec(3)],'Color','black');
    plot3([0 outvec(1)],[0 outvec(2)],[0 outvec(3)],'Color','blue');
end

end



