function semblance_values = semblance_analysis(data,time_axis,offset_axis,velocity_range)
% Performs semblance analysis to make velocity picking easier, using a
% provided range of velocities.

time_interval = (time_axis(2) - time_axis(1))/10;
new_time_axis = time_axis(1):time_interval:time_axis(end);

semblance_values = [];

for i = 1:length(velocity_range)
    to_stack = zeros(length(new_time_axis),length(offset_axis));
    for j = 1:length(offset_axis)
        del_t = zeros(length(time_axis),1);
        for k = 2:length(time_axis)
            del_t(k) = time_axis(k)*((1+(offset_axis(j)/(velocity_range(i)*time_axis(k)))^2)^0.5-1);
        end
        new_time = time_axis + del_t';
        to_stack(:,j) = interp1(new_time,data(:,j),new_time_axis);
    end
    semblance_values(:,i) = [sum(to_stack')]'; 
end

imagesc(velocity_range,new_time_axis,semblance_values)

end
            