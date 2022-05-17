function add_substrate(filename,icethickness,material)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This adds the bed to an already initated domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - the name of the file to write or output to
% icethickness - this defines the point in the domain where the bed starts
% material - this sets the substrate as either [1] sea water, [2]
%            freshwater, [3] Frozen Bedrock, [4] Unfrozen Bedrock, [5]
%            Freshwater till (at the high end)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

freespace_thickness = 50;%

if length(material) == 1
    if material == 1  % Seawater
        props = [77 2.9 1 0];
        material = 'Seawater';
    elseif material == 2 % Freshwater
        props = [80 1e-4 1 0];
        material = 'Freshwater';
    elseif material == 3 % Frozen Bedrock
        props = [2.7 2e-4 1 0];
        material = 'FrozenBedrock';
    elseif material == 4 % Unfrozen Bedrock
        props = [12 0.0048 1 0];
        material = 'UnfrozenBedrock';
    elseif material == 5 % Freshwater Till (high)
        props = [20 3e-4];
        material = 'FreshwaterTill';
    end
else
    props = [material 1 0];
    material = 'Substrate';
end


filename = [filename,'.in'];

fid=fopen(filename,'r');

break_flag = 0;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'domain') == 1
        vals = strsplit(line,' ');
        vals = [eval(vals{2}) eval(vals{3}) eval(vals{4})];
        break_flag = 1;
    end
end

fclose(fid);
fid=fopen(filename,'a');



fprintf(fid,'\n',[]);
fprintf(fid,['#material: %.3g %.3g %.3g %.3g ',material,' \n'],props);
fprintf(fid,['#box: %.3g %.3g %.3g %.3g %.3g %.3g ',material,' n \n'],[0 0 0 vals(1:2) vals(3)-icethickness-freespace_thickness]);


fclose(fid);
















