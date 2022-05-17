function [new_data shift_amount depth_axis surface_elev bed_elev] = depth_shift(data,time,surface,elevation,bed,disp_flag);
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This converts radar in time to the true elevation coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% data - The radar data matrix
% time - The time axis for the data
% surface - the surface pick (should theoretically accept both index or
%           time)
% elevation - Values for flight elevation
% bed - if exists, the bed pick
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%
% new_data - The data adjusted for flight elevation
% shift_amount - The number of indecies each column has been shifted 
%                (Subtract this value from picks to correct them) 
% depth_axis - The new Z axis for the data
% surface_elev - The elevation for the new surface
% bed_elev - The bed elevation if bed pick is supplied
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if min(mod(surface,1)) == 0
    ind_flag = 1;
else
    ind_flag = 0;
end

%%%%%%%%%%%% Fix the orientation of certain objects
ss = size(surface);
if ss(2) == 1
    surface = surface';
end
st = size(time);
if st(2) == 1
    time = time';
end

if ind_flag == 1
    surf_time = time(surface);
else
    surf_time = surface;
end

if exist('disp_flag') == 0
    disp_flag = 0;
end


cair =  299792458;
cice = cair/sqrt(3.15);


%% Computes ice thickness if the bed pick is supplied
if exist('bed') == 1
    sb = size(bed);
    if sb(2) == 1
        bed = bed';
    end
    
    
    if min(mod(bed,1)) == 0
        ind_flag2 = 1;
    else
        ind_flag2 = 0;
    end
    
    if ind_flag2 == 1
        temp_inds = interpNaN(bed);
        temp_inds(find(temp_inds < 1)) = 1;
        bed_time = time(round(temp_inds));
    else
        bed_time = bed;
    end
    
    thickness_time = bed_time-surf_time;
    thickness = thickness_time*cice/2;
end



new_data1 = zeros(size(data));
new_data2 = zeros(size(data));

dt = time(2)-time(1);
dx = cice*dt/2;

steps = floor(length(data(1,:))/10);

filled_inds = find(isnan(surface) == 0);
unfilled_inds = find(isnan(surface) == 1);


%%% This fills NaN's with the closest picked value
for i = 1:length(unfilled_inds)
    [trash replace_ind] = find_nearest(filled_inds,unfilled_inds(i));
    surface(unfilled_inds(i)) = surface(replace_ind);
end


%%%% This first forces the surface to be the 0th index.
for i = 1:length(data(1,:))
    if ind_flag == 0
        shift_amount1(i) = find_nearest(time,surface(i));
    else
        shift_amount1(i) = round(surface(i));
    end
    surface_elev(i) = elevation(i) - time(shift_amount1(i))*cair/2;
    select_inds = shift_amount1(i):length(time);
    new_data1(1:length(select_inds),i) = data(select_inds,i);
    if mod(i-1,steps) == 0
        if disp_flag == 1
        disp([num2str(round(10*(i-1)/steps)),'% Complete - Surface Shift'])
        end
    end
end

top = max(surface_elev) + 100;


surface_elev = interpNaN(surface_elev);

for i = 1:length(data(1,:))
    shift_amount2(i) = round((top-surface_elev(i))/dx)+1;
    select_inds = 1:length(time)-shift_amount2(i)+1;
    new_data2(shift_amount2(i):end,i) = new_data1(select_inds,i);
    if mod(i-1,steps) == 0
        if disp_flag == 1
        disp([num2str(round(10*(i-1)/steps)),'% Complete - Elevation Shift'])
        end
    end
end

shift_amount = shift_amount1-shift_amount2;
new_data = new_data2;
depth_axis = fliplr(top-dx*(length(time)-1):dx:top);

%% This computes the bed elevation if it is supplied
if exist('bed') == 1
    bed_elev = surface_elev - thickness;
else
    bed_elev = ones(size(surface_elev))*NaN;
end
  
  

end







