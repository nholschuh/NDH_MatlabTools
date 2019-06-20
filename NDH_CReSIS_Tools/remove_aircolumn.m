function [new_data newtime newelev] = remove_aircolumn(data,time,surface,elevation);
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This converts radar in time to the true elevation coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% data - The radar data matrix
% time - The time axis for the data
% surface - the surface pick (should theoretically accept both index or
%           time)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%
% new_data - The data removing the aircolumn
% newtime - The updated time axis
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


%%% This fills NaN's with the closest picked value
filled_inds = find(isnan(surface) == 0);
unfilled_inds = find(isnan(surface) == 1);
for i = 1:length(unfilled_inds)
    [trash replace_ind] = find_nearest(filled_inds,unfilled_inds(i));
    surface(unfilled_inds(i)) = surface(replace_ind);
end


%%% Decide if the pick info are times or indecies
if ind_flag == 1
    surf_time = time(surface);
else
    surf_time = surface;
end


new_data1 = zeros(size(data));
new_data2 = zeros(size(data));

cair_import

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
end

new_data = new_data1(1:end-max(shift_amount1),:);
dt = time(2)-time(1);
newtime = 0:dt:dt*(length(new_data(:,1))-1);
newelev = surface_elev;


end







