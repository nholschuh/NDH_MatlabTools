function [StackedData index] = stacker(Data,stacks);
%% Takes a data set and stacks the data using the # provided (odd)

traces = length(Data(1,:));
stackedtraces = floor(traces/stacks);
StackedData = zeros(length(Data(:,1)),stackedtraces);
startindex = ceil(stacks/2);
index = startindex:stacks:(stacks*(stackedtraces-1)+startindex);

for i = 1:stackedtraces
    StackedData(:,i) = (sum(Data(:,(i-1)*stacks+1:i*stacks)')/stacks)';
end

end