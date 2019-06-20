function [yes_no_final angle_storage] = within(data,xcol,ycol,boundaries,skipper)
% Determines whether or not the data within a given set of boundaries
% defined by their vertices. Skipper value is an efficiency algorithm,
% higher values makes the code run faster, but runs the risk of missing
% fine details. Angle_storage is used for debugging.


boundaries(length(boundaries(:,1))+1,:) = boundaries(1,:);


counter = 1;
data = [data zeros(length(data(:,1)))];
data_width = length(data(1,:));
boundaries = [boundaries zeros(length(boundaries(:,1)))];

dp = zeros(length(data(:,1)),length(boundaries(:,1))-1);
cp = zeros(length(data(:,1)),length(boundaries(:,1))-1);

for i = 1:length(boundaries(:,1)-1)
    
  