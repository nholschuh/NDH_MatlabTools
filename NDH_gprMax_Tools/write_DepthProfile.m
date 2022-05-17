function write_DepthProfile(filename,domain_size,spacing,surface_density,firn_depth,layers,include_geometryout,write0_or_append1)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This writes a 3D object, initates the firm profile and the ice column
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - the name of the file to write or output to
% domain_size - the size, in m, for the [x y z] dimensions
% spacing - the incremental spacing for the grid, [dx dy dz]
% surface density - in kg/m3
% firn_depth - the maximum depth to the glacial ice
% layers - the number of firn layers to include in the model
% include_geometryout - this includes a flag to write a vti file of the
%                       domain
% write0_or_append1 - write a new file [0] or append to a file [1]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

freespace_thickness = 50;

if exist('write0_or_append1') == 0
    write0_or_append1 = 0;
end
if exist('include_geometryout') == 0
    include_geometryout = 0;
end

filename = [filename,'.in'];

if write0_or_append1 == 0
    fid=fopen(filename,'w');
elseif write0_or_append1 == 1
    fid=fopen(filename,'a');
end

fprintf(fid,'#title: %s \n',filename);
fprintf(fid,'#domain: %.3f %.3f %.3f \n',domain_size);
fprintf(fid,'#dx_dy_dz: %.3f %.3f %.3f \n',spacing);

cice_import;
total_time = round_to(domain_size(3)*2/cice,1e-9);

%%%%%%%%%%%%%% Need to include a stability test here!

fprintf(fid,'#time_window: %f \n',total_time);
fprintf(fid,'\n',[]);


%%%%%%%%%%%%%%%%% Initiate variables that may not be defined
if exist('firn_depth') == 0
    firn_depth = 100;
end
if firn_depth == 0
    firn_depth = 100;
end

if exist('surface_density') == 0
    surface_density = 0;
end

if exist('layers') == 0
    layers = 10;
end
if layers == 0
    layers = 10;
end


%%
%%%%%%%% Step 1 - Derive the depth-density profile

[firn_info] = firn_profile(0,0,surface_density);
cutoff = find_nearest(firn_info(:,2),916.9);
firn_info = firn_info(1:cutoff,:);
firn_info(:,1) = firn_info(:,1)/firn_info(end,1)*firn_depth;
firn_info(:,2) = firn_info(:,2)/1000;


%%%%%%%% Step 2 - Select the depth slices of interest, and compute the
%%%%%%%% permittivity and conductivity at those depths
opts = linspace(firn_info(1,2),firn_info(end,2),layers+2);
depth(1) = freespace_thickness;
opts = opts(2:end-1);
for i = 1:length(opts)
    pick_ind(i) = find_nearest(firn_info(:,2),opts(i));
    depth(i+1) = round_to(depth(1)+firn_info(pick_ind(i),1),spacing(3));
end
cond = density_to_conductivity(opts);
perm = velocity_to_permittivity(density_to_velocity(opts));


%%%%%%%% Step 3 - Write the new properties into the gprMax file

%%% Put in the material properties
%fprintf(fid,'#material: %.3g %.3g %.3g %.3g fs \n',[1 0 1 0]);
for i = 1:length(opts)
    fprintf(fid,'#material: %.3g %.3g %.3g %.3g firn_%03g \n',[perm(i) cond(i)*10^-6 1 0 i]);
end
fprintf(fid,'#material: %.3g %.3g %.3g %.3g ice \n',[3.17 6.6e-6 1 0]);

fprintf(fid,'\n',[]);
%%% Put in the material blocks
fprintf(fid,'#box: %.3g %.3g %.3g %.3g %.3g %.3g free_space \n',[0 0 domain_size(3)-freespace_thickness domain_size(1) domain_size(2) domain_size(3)]);
for i = 1:length(opts)
    fprintf(fid,'#box: %.3g %.3g %.3g %.3g %.3g %.3g firn_%03g \n',[0 0 domain_size(3)-depth(i+1) domain_size(1) domain_size(2) domain_size(3)-depth(i) i]);
end
fprintf(fid,'#box: %.3g %.3g %.3g %.3g %.3g %.3g ice \n',[0 0 0 domain_size(1) domain_size(2) domain_size(3)-depth(end)]);
fprintf(fid,'\n',[]);
%%% This writes out the geometry view line, which produces a .vti file for
%%% viewing in paraview when gprMax is run

if include_geometryout == 1
fprintf(fid,'#geometry_view: %.3g %.3g %.3g %.3g %.3g %.3g %.3f %.3f %.3f %s n',[0 0 0 domain_size(1) domain_size(2) domain_size(3) spacing],[filename(1:end-3),'_geometry']);
fprintf(fid,'\n',[]);
end

fclose(fid);

end



