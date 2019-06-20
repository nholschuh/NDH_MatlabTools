function [CData] = get_index_from_colormap(datamat,cvals,map);

min_val = min(min(datamat));
max_val = max(max(datamat));

datamat(find(datamat <= cvals(1))) = cvals(1);
datamat(find(datamat >= cvals(2))) = cvals(2);
datamat = double(datamat);

min_val = min(min(datamat));
max_val = max(max(datamat));

crange = cvals(2)-cvals(1);
lowrange = min_val-cvals(1);
datarange = max_val-min_val;

datamat = datamat - min_val;
max_val = max_val - min_val;



    
CData = uint8(round((datamat/max_val*(datarange/crange)+(lowrange/crange))*(length(map(:,1)))));
CData(find(CData == 0)) = 1;
end