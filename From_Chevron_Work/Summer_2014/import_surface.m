function result = import_surface(name,plotting);
% Imports an ascii grid (ZMap + grid) surface exported from Petrel

if exist('plotting') == 0
    plotting = 0;
end

delimiter = ',';
startRow = 9;
endRow = 10;

formatSpec = '%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(name,'r');
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow-1, 'ReturnOnError', false);
fclose(fileID);
header1 = [dataArray{1:end-1}];

xaxis = header1(1,3):header1(2,2):header1(1,4);
yaxis = header1(1,5):header1(2,3):header1(1,6);
columns = header1(1,2);
rows = header1(1,1);

clearvars delimiter startRow endRow formatSpec fileID dataArray ans;

startRow = 12;
formatSpec = '%15f%15f%15f%15f%f%[^\n\r]';
fileID = fopen(name,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

grid_data = [dataArray{1:end-1}];


clearvars delimiter startRow endRow formatSpec fileID dataArray ans;

for i = 1:length(grid_data(:,1))
    for j = 1:length(grid_data(1,:))
        if grid_data(i,j) == 1e30
            grid_data(i,j) = NaN;
        end
    end
end

counter = 1;
for i = 1:length(grid_data(:,1))
    for j = 1:5
        data2(counter) = grid_data(i,j);
        counter = counter+1;
    end
end


for i = 1:columns
    for j = 1:rows
        grid(i,j) = data2((i-1)*rows+j);
    end
end
grid = flipud(grid');

if plotting == 1
    imagesc(xaxis,yaxis,grid)
    set(gca,'YDir','normal')
    axis equal
end

result{1} = xaxis;
result{2} = yaxis;
result{3} = grid;

end

