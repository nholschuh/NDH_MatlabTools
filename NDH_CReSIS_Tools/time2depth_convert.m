function [d_axis new_d_axis depth_data] = time2depth_convert(Data,Time,Surface)
%% Converts a given time axis to an ice depth axis.

% Import the air and ice speeds
cice_import;
cair_import;
d_axis = zeros(size(Data));

cice = cice/2;
cair = cair/2;

% Converts to indexes, if they are currently in time
if min(order(Surface)) < -1
    Surface2 = time2index(Surface,Time);
else
    Surface2 = Surface;
end

% Compute the depth for each time axis (with dS/dx ~= 0)
for i = 1:length(Data(1,:)) % For all columns
    depth_time = Time(Surface2(i));
    d_axis(1:Surface2(i),i) = (Time(1:Surface2(i)))*cair;
    d_axis(Surface2(i)+1:end,i) = d_axis(Surface2(i))+(Time(Surface2(i)+1:end)-depth_time)*cice;
end

min_depth = min(min(d_axis));
max_depth = max(max(d_axis));
difs = (max_depth - min_depth)/((length(Time)*2)-1);
new_d_axis = min_depth:difs:max_depth;

depth_data = zeros(length(Data(:,1))*2,length(Data(1,:)));

keyboard
for i = 1:length(Data(1,:))
    depth_data(:,i) = interp1(d_axis(:,i),Data(:,i),new_d_axis,'spline');
end
keyboard

end