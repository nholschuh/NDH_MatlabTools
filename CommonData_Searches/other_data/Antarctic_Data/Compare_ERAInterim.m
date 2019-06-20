%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compare ERA_Interim
%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

var_opt = 'skt';
var_opt = 't2m';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create the comparison era_interim data
for i = 1:12
   [x y skt(:,:,i)] = grdread('era_interim.nc',var_opt,i,'longitude','latitude'); 
end
skt = mean(skt,3);

yi = find(y < -55);

[X Y] = meshgrid(x,y(yi));

dvec(:,3) = matrix_to_vector(skt(yi,:));
lon = matrix_to_vector(X);
lat = matrix_to_vector(Y);

[dvec(:,1) dvec(:,2)] = polarstereo_fwd(lat,lon);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Read in the data from a mysterious
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% origin

[x2 y2 a2] = grdread('Ant_Temperature_ERF_Interim.nc');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Set to the same grid

era_st = griddata(dvec(:,1),dvec(:,2),dvec(:,3),x2,y2');


subplot(1,3,1)
imagesc(x2,y2,a2)
set(gca,'YDir','normal')
title('Mystery Data')

subplot(1,3,2)
imagesc(x2,y2,era_st)
set(gca,'YDir','normal')
title('Known ERA Interim')

subplot(1,3,3)
imagesc(x2,y2,era_st-a2)
set(gca,'YDir','normal')
title('Field Diff')







