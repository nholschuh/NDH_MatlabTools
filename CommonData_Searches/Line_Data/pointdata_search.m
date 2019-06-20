function [x_out y_out surf_out bed_out mission_id_out] = pointdata_search(topleft,bottomright);
% Provide the top left and bottom right coordinates, and this function
% searches the aggregated data for all ice surface and bed elevation
% measurements within that region:
%% 
topleft = [-300000,-535000];
bottomright = [-200000,-585000];

files = {'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\bedmap1.mat',
    'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\CReSIS_Flights.mat',
    'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\CESARTZ.mat',
    'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\2009_AN_UTIG.mat',
    'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\2010_AN_UTIG.mat',
    'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\AGASEA.mat',
    'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\DVD.mat',
    'C:\Users\nick\OneDrive\Matlab_Code\NDH_Tools\CommonData_Searches\Line_Data\WMB.mat'};

x_out = [];
y_out = [];
surf_out = [];
bed_out = [];
mission_id_out = [];
tic
for i = 1:length(files)
    load(files{i})
    range = find(x < bottomright(1) & x > topleft(1) & y > bottomright(2) & y < topleft(2));
    x_out = [x_out; x(range)];
    y_out = [y_out; y(range)];
    surf_out = [surf_out; surfs(range)];
    bed_out = [bed_out; bed(range)];
    mission_id_out = [mission_id_out; mission_id(range)];
    
    
    
end

end
    