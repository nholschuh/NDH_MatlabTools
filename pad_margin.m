function output = pad_margin(data,width,type,value)
%
%
% type - (0) both margins, (1) add rows, (2) add columns

dims = size(data);
if exist('value') == 0
    value = 0;
end

if type == 0 | type == 1
    data = [ones(width,dims(2))*value; data; ones(width,dims(2))*value];
end

if type == 0
    data = [ones(dims(1)+2*width,width)*value data ones(dims(1)+2*width,width)*value];
end

if type == 2
    data = [ones(dims(1),width)*value data ones(dims(1),width)*value];
end

output = data;
end