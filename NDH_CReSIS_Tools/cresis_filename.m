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

if max(size(y) == 5) == 1 & max(size(y) == 1) ~= 1
    s = y(:,5);
    f = y(:,4);
    d = y(:,3);
    m = y(:,2);
    y = y(:,1);
end

if exist('file_or_path') == 0
    file_or_path = 0;
end


%%%%%%%%%%%%%%% Here, we allow you to supply multiple values for one of the
%%%%%%%%%%%%%%% entries, and seek out all fitting files. But first, we must
%%%%%%%%%%%%%%% reject the case where you provide a large number of file
%%%%%%%%%%%%%%% pieces.
if max(abs(diff([length(y),length(m),length(d),length(f),length(s)]))) > 0
    
    if length(y) > 1
        rep_flag = 1;
        rep_num = length(y);
        include_vals = y;
    elseif length(m) > 1
        rep_flag = 2;
        rep_num = length(m);
        include_vals = m;
    elseif length(d) > 1
        rep_flag = 3;
        rep_num = length(d);
        include_vals = d;
    elseif length(f) > 1
        rep_flag = 4;
        rep_num = length(f);
        include_vals = f;
    elseif length(s) > 1
        rep_flag = 5;
        rep_num = length(s);
        include_vals = s;
    else
        rep_flag = 1;
        rep_num = 1;
        include_vals = y;
    end
    
    dv = [y(1) m(1) d(1) f(1) s(1)];
    dv = repmat(dv,rep_num,1);
    dv(:,rep_flag) = include_vals;
else
   dv = [y m d f s]; 
end

rep_num = length(s);
file_counter = 1;

fpath = [];


for i = 1:rep_num
    
    [season ant_or_gre] = cresis_season(dv(i,1),dv(i,2),dv(i,3));
    
    if length(season) > 0
        dirname = [sprintf('%0.4d',dv(i,1)),sprintf('%0.2d',dv(i,2)),sprintf('%0.2d',dv(i,3)),'_',sprintf('%0.2d',dv(i,4))];
        if ant_or_gre == 1
            cont_path = 'Antarctica';
        else
            cont_path = 'Greenland';
        end
        
        if file_or_path == 0
            tpath = ['Data_',dirname,'_',sprintf('%0.3d',dv(i,5)),'.mat'];
        else
            tpath = [DataPath,'CReSIS_Bulk_Download\',cont_path,'\',season,'\CSARP_standard\',dirname,'\Data_',dirname,'_',sprintf('%0.3d',dv(i,5)),'.mat'];
        end
        
        if exist(tpath) ~= 0 & file_or_path == 1
            f_path(file_counter).name = tpath;
            file_counter = file_counter+1;
        elseif file_or_path == 0
            f_path(file_counter).name = tpath;
            file_counter = file_counter+1;
        end
    end
end














