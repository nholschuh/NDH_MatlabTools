function outfiles = nested_dir(in_pattern);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Finds all files in nested folders with the defined pattern (5 layers
% deep)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% in_pattern - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
% out2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


fds1 = folders('./');
files = dir(in_pattern);

for i = 1:length(fds1)
    t_files = dir([fds1(i).name,'/',in_pattern]);
    files = [files; t_files];
    
    fds2 = folders([fds1(i).name,'/']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii = 1:length(fds2)
        t_files = dir([fds1(i).name,'/',fds2(ii).name,'/',in_pattern]);
        files = [files; t_files];
        
        fds3 = folders([fds1(i).name,'/',fds2(ii).name,'/']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for iii = 1:length(fds3)
            t_files = dir([fds1(i).name,'/',fds2(ii).name,'/',fds3(iii).name,'/',in_pattern]);
            files = [files; t_files];
            
            fds4 = folders([fds1(i).name,'/',fds2(ii).name,'/',fds3(iii).name,'/']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for iiii = 1:length(fds4);
                t_files = dir([fds1(i).name,'/',fds2(ii).name,'/',fds3(iii).name,'/',fds4(iiii).name,'/',in_pattern]);
                files = [files; t_files];
                
                fds5 = folders([fds1(i).name,'/',fds2(ii).name,'/',fds3(iii).name,'/',fds4(iiii).name,'/']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for iiiii = 1:length(fds5)
                    t_files = dir([fds1(i).name,'/',fds2(ii).name,'/',fds3(iii).name,'/',fds4(iiii).name,'/',fds5(iiiii).name,'/',in_pattern]);
                    files = [files; t_files];                    
                end
            end
        end
    end
end

outfiles = files;





