function add_box(filename,depth_to_top,thickness,xlims,ylims,perm_and_cond,dielectric_smoothing)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This adds the bed to an already initated domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - the name of the file to write or output to
% depth_to_top - the depth into the ice column to the top of the layer
% thickness - the layer thickness
% xlims - the x coordinate limits. Supply a 0 for the full width
% ylims - the y coordinate limits. Supply a 0 for the full width
% perm_and_cond - this defines the permittivity and conductivity of the
%                 material of the layer
% dielectric_smoothing - this defines whether or not dielectric_smoothing
%       is allowed for the introduced object (default - 1 [yes]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

freespace_thickness = 50;

filename = [filename,'.in'];
fid=fopen(filename,'r');

if exist('dielectric_smoothing') == 0
    dielectric_smoothing = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%% This portion determines if the material being
%%%%%%%%%%%%%%%%%%%%%%%%% defined has already been written into the
%%%%%%%%%%%%%%%%%%%%%%%%% initiate file
break_flag = 0;
material_counter = 1;
perm_and_cond_compare(1) = round_to(perm_and_cond(1),10^(order(perm_and_cond(1))-2));
perm_and_cond_compare(2) = round_to(perm_and_cond(2),10^(order(perm_and_cond(2))-2));
material_nowrite = 0;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'material') == 1
        vals = strsplit(line,' ');
        if eval(vals{2}) == perm_and_cond(1) & eval(vals{3}) == perm_and_cond(2)
            material_name = vals{6};
            material_nowrite = 1;
            break_flag = 1;
        elseif length(vals{6}) > 9
            if vals{6}(1:9) == 'material_'
                material_counter = material_counter+1;
            end
        end
    elseif line == -1
        break_flag = 1;
    end
end
fseek(fid,0,'bof');

if exist('material_name') == 0
    material_name = ['material_',sprintf('%04.f',material_counter)];
end

%%%%%%%%%%%%%%%%%%%%%%%%% This portion finds the boundary edges of the
%%%%%%%%%%%%%%%%%%%%%%%%% domain
break_flag = 0;

while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'domain') == 1
        vals = strsplit(line,' ');
        vals = [eval(vals{2}) eval(vals{3}) eval(vals{4})];
        break_flag = 1;
    end
end


if dielectric_smoothing == 1
    ds_char = 'y';
else
    ds_char = 'n';
end


fclose(fid);
fid=fopen(filename,'a');


if length(xlims) == 1
    xlims = [0 vals(1)];
end
if length(ylims) == 1
    ylims = [0 vals(2)];
end

if material_nowrite == 0
    fprintf(fid,'\n',[]);
    fprintf(fid,['#material: %.3g %.3g %.3g %.3g ',material_name,' \n'],[perm_and_cond 1 0]);
end

fprintf(fid,['#box: %.3g %.3g %.3g %.3g %.3g %.3g ',material_name,' ',ds_char,' \n'],[xlims(1) ylims(1) vals(3)-depth_to_top-thickness-freespace_thickness xlims(2) ylims(2) vals(3)-depth_to_top-freespace_thickness]);


fclose(fid);
















