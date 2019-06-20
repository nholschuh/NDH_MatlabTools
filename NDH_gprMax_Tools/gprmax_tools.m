function gprmax_tools(input_string)
% Lists all tools that containt the supplied string

if exist('input_string') == 0
    files = [dir([OnePath,'Matlab_Code\NDH_Tools\NDH_gprMax_Tools\*.m'])];
elseif isempty(input_string) == 1
    files = [dir([OnePath,'Matlab_Code\NDH_Tools\NDH_gprMax_Tools\*.m'])];
else
    files = [dir([OnePath,'Matlab_Code\NDH_Tools\NDH_gprMax_Tools\*',input_string,'*.m'])];
end

disp(' ')
disp('    Tools    ')
disp('--------------------------')
for i = 1:length(files)
    disp(files(i).name)
end

disp(' ')
end