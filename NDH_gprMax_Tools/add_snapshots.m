function add_snapshots(filename,deltat,x_or_y,cross_section_pos)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This adds the bed to an already initated domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - the name of the gprmax input file to append this to
% deltat - the time step used for the snaps
% x_or_y - a [0] or [1] indicating which axis the snap should be parallel
%           to
% cross_section_pos - the value on the perpendicular axis for the snap to
%           pass through
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

fid=fopen(filename,'r');
break_flag = 0;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'dx_dy_dz') == 1
        vals2 = strsplit(line,' ');
        vals2 = [eval(vals2{2}) eval(vals2{3}) eval(vals2{4})];
        break_flag = 1;
    end
end
fclose(fid);

fid=fopen(filename,'r');
break_flag = 0;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'#time_window:') == 1
        total_t = strsplit(line,' ');
        total_t = round(eval(total_t{2})/deltat);
        break_flag = 1;
    end
end
fclose(fid);

if x_or_y == 0
    pos1 = [0 cross_section_pos 0];
    pos2 = [vals(1) cross_section_pos+vals2(2) vals(3)];
else
    pos1 = [cross_section_pos 0 0];
    pos2 = [cross_section_pos+vals2(1) vals(2) vals(3)];  
end

fid=fopen(filename,'a');


fprintf(fid,['#python: \n'],[]);
fprintf(fid,['for i in range(1, %g): \n'],[total_t]);
fprintf(fid,['   print(''#snapshot: %f %f %f %f %f %f %f %f %f {} snapshot{}''.format(i*%3g, i)) \n'],[pos1 pos2 vals2 deltat]);
fprintf(fid,['#end_python: \n'],[]);
fprintf(fid,['\n'],[]);

fclose(fid);

end















