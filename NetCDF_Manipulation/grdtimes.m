function [out time_axis] = grdtimes(filename,varname,timesvar);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function extracts the number of time slices contained in a netcdf
% file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filename - The file to read in containing the variable of interest
% varname - The variable of interest
% timesvar - [optional] the name of the variable containing the time info
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out - The number of time steps in the target variable
% time_axis - [Optional] the values at each time step
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

varnames = grdvariables(filename);
match = 0;

%%%%%%%%%%%%%%% Ensure that the provided variable is included in the netcdf
if exist('varname') == 1
    in_length = length(varname);
else
    varname = 0;
    in_length = 0;
end

for i = 1:length(varnames)
    var_lengths(i) = length(varnames{i});
    if var_lengths(i) == in_length
        if varnames{i} == varname
            match = i;
            break
        end
    end
end

%%%%%%%%%%%%%%% Prompt the user to select the variable if not included
if varname == 0 | match == 0
    match = listdlg('ListString',varnames,'PromptString','Provided varname does not exist - select:');
end

selected_var = ncread(filename,varnames{match});
out_temp = size(selected_var);
out = out_temp(3);


%%%%%%%%%%%%%%%% If the user provides the timesvar value, find it here
if exist('timesvar') == 1
    in_length2 = length(timesvar);
    match = 0;
    for i = 1:length(varnames)
        var_lengths(i) = length(varnames{i});
        if var_lengths(i) == in_length2
            if varnames{i} == timesvar
                match = i;
                break
            end
        end
    end
    if match == 0
        match = listdlg('ListString',varnames,'PromptString','Select Time-Axis Name:');
    end
    
    time_axis = ncread(filename,varnames{match});
else
    time_axis = [];
end


