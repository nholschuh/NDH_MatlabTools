%% convert gland_surface_outlines_xy to gland_surface_outlines_lonlat

dir1 = 'gland_surface_outlines_xy';
dir2 = 'gland_surface_outlines_lonlat';
files = dir([dir1,'/*.xy']);

if exist(dir2) == 0
    mkdir(dir2)
end

for i = 1:length(files)
    data = dlmread([dir1,'/',files(i).name]);
    [lat lon] = polarstereo_inv(data(:,1),data(:,2),1);
    dlmwrite([dir2,'/',files(i).name(1:end-2),'.lonlat'],[lon lat])
end
