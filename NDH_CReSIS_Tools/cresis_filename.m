function f_path = cresis_filename(y,m,d,f,s,file_or_path);% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Constructs a CReSIS Data Filename from the date and acquisition
% information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% y - The year of acquisition [or a 5 element vector containing all values]
% m - The month of acquisition
% d - The day of acquisition
% f - The frame of acquisition
% s - The segment of acquisition
% file_or_path - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% f_path - The full path to the file of interest.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if length(y) == 5
    s = y(5);
    f = y(4);
    d = y(3);
    m = y(2);
    y = y(1);
end

if exist('file_or_path') == 0
    file_or_path = 1;
end

[season ant_or_gre] = cresis_season(y,m,d);

if length(season) > 0
    dirname = [sprintf('%0.4d',y),sprintf('%0.2d',m),sprintf('%0.2d',d),'_',sprintf('%0.2d',f)];
    if ant_or_gre == 1
        cont_path = 'Antarctica';
    else
        cont_path = 'Greenland';
    end
    
    if file_or_path == 0
        f_path = ['Data_',dirname,'_',sprintf('%0.3d',s),'.mat'];
    else
        f_path = [DataPath,'CReSIS_Bulk_Download\',cont_path,'\',season,'\CSARP_standard\',dirname,'\Data_',dirname,'_',sprintf('%0.3d',s),'.mat'];
    end
else
    f_path = [];
end















