function variables = grdvariables(gridname)
%Takes a netcdf grid and outputs all variable names for that grid

temp = ncinfo(gridname);

numvariables = length(temp.Variables);

result = {};
for i = 1:numvariables
    result{i} = ['' temp.Variables(i).Name ''];
end

variables = result;