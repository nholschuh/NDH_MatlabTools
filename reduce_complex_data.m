function [results] = reduce_complex_data(Data)
% Takes complex radar returns (of 1 or multiple antennae), and produces an
% amplitude results.

antennae = length(Data(1,1,:));
traces = length(Data(1,:,1));
samples = length(Data(:,1,1));

Final_Data_averaged = zeros(samples,traces,1);
Final_Data = zeros(samples,traces,antennae);

for i = 1:antennae
    for j = 1:traces
        for k = 1:samples
            Final_Data(k,j,i) = norm(Data(k,j,i));
        end
    end
end
    
for i = 1:antennae
    Final_Data_averaged = Final_Data_averaged + Final_Data(:,:,i);
end

results = Final_Data_averaged;

end