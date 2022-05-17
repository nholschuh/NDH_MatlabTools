function tools_list(input_string)
% Lists all tools that containt the supplied string

files = dir([OnePath,'Matlab_Code/NDH_Tools/*',input_string,'*.m']);
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/NDH_CReSIS_Tools/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/NDH_gprMax_Tools/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/Geophyiscal_Tools/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/Graphical_Selection_Tools/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/Glaciology_Tools/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/CommonData_Searches/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/CommonData_Searches/topographies/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/CommonData_Searches/velocities/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Matlab_Code/NDH_Tools/file_readers/*',input_string,'*.m'])];
files = [files; dir([OnePath,'Unix_Scripts/SeismicUnix/*',input_string,'*.m'])];
disp(' ')
disp('    Tools    ')
disp('--------------------------')
for i = 1:length(files)
    disp(files(i).name)
end

disp(' ')
end