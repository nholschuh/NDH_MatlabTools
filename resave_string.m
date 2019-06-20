function save_string = resave_string(filename,additional_vars,exclude_vars,name_append);
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
% This provides some additional save functionality, designed for updating
% files that already have set variables. This allows you to add or remove
% variables from those files.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - The output file to be saved. If it already exist, this code
%           makes sure to include and update the variables in the file
% additional_vars - cell array of variables to include in the save
% exclude_vars - cell array of variables to exclude in the save
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('additional_vars') == 0
    additional_vars = [];
end
if exist('exclude_vars') == 0
    exclude_vars = [];
end
if exist('name_append') == 0
   name_append = []; 
end

if iscell(additional_vars) == 0
    additional_vars = {additional_vars};
end
if iscell(exclude_vars) == 0
    exclude_vars = {exclude_vars};
end

if exist(filename) == 2
    start_vars = whos('-file',filename);
    start_vars = {start_vars.name};
end

exclude_flag = zeros(1,length(start_vars));
for i = 1:length(exclude_vars)
    for j = 1:length(start_vars)
        if strcmp(exclude_vars(i),start_vars(j)) == 1
            exclude_flag(j) = 1;
        end
    end
end

start_vars(find(exclude_flag)) = [];

save_string = ['save(''',filename(1:end-4),name_append,'.mat'','''];

for i = 1:length(start_vars);
    save_string = [save_string,start_vars{i},''','''];
end
for i = 1:length(additional_vars)
    save_string = [save_string,additional_vars{i},''','''];
end

save_string = [save_string(1:end-2),');'];

end

