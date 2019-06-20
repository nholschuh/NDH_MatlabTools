%%%%%%%%%%%%%%%%%%%%%%%%
%%% Convert_39_45
%%%%%%%%%%%%%%%%%%%%%%%%

dir1 = 'gland_surface_outlines_xy';
dir2 = 'gland_surface_outlines_45xy';
files = dir([dir1,'/*.xy']);

if exist(dir2) == 0
    mkdir(dir2)
end

for i = 1:length(files)
    data = dlmread([dir1,'/',files(i).name]);
    [x2 y2] = polarstereo_reproject(data(:,1),data(:,2),2);
    dlmwrite([dir2,'/',files(i).name(1:end-2),'.xy'],[x2 y2])
end




%%
files = dir('*.xy');


for i = 1:length(files)
    data = dlmread([files(i).name]);
    [x2 y2] = polarstereo_reproject(data(:,1),data(:,2),2);
    dlmwrite([files(i).name(1:end-3),'_39.xy'],data)
    dlmwrite([files(i).name(1:end-2),'xy'],[x2 y2])
end