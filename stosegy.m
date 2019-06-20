function stosegy(filename,datatype)

if datatype == 1
    data_var = data;
elseif datatype == 2
    data_var = filtdata;
elseif datatype == 3
    data_var = migdata;
end

WriteSegy(filename,data_var,'dt',dt*10^6,'cdpX',,'cdpY',;
    