function [new_data shift_amount new_time surface_elev] = surface_shift(data,time,surface);

if min(mod(surface,1)) == 0
    ind_flag = 1;
else
    ind_flag = 0;
end

new_data = zeros(size(data));
new_time = time-min(time);

steps = floor(length(data(1,:))/10);


for i = 1:length(data(1,:))
    if ind_flag == 0
        shift_amount(i) = find_nearest(time,surface(i));
        surface_elev
    else
        shift_amount(i) = round(surface(i));
    end
    select_inds = shift_amount(i):length(time);
    new_data(1:length(select_inds),i) = data(select_inds,i);
    if mod(i-1,steps) == 0
        disp([num2str(round(10*(i-1)/steps)),'% Complete'])
    end
end

end