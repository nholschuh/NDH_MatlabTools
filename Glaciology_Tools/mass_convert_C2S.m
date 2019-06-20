function mass_convert_C2S(prefix,outputprefix,startdepth)

if exist('startdepth') == 0
    startdepth = 0;
end

filelist = dir([prefix,'*.mat']);
currentdirectory = pwd;
[upperPath, savename, ~] = fileparts(currentdirectory);

for i = 1:length(filelist)
    istring = num2str(i);
    if length(istring) == 1
        Cresis2Storadar(filelist(i).name,[outputprefix,savename,'_00',num2str(i)],startdepth)
    else
        Cresis2Storadar(filelist(i).name,[outputprefix,savename,'_0',num2str(i)],startdepth)
    end
end
end