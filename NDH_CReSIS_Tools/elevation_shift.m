function [new_data shift_amount new_time] = elevation_shift(data,time,elevation);


cair_import
datum = max(elevation);
dt = time(2)-time(1);

new_data = zeros(size(data));
new_time = time-min(time);

steps = floor(length(data(1,:))/10);


for i = 1:length(data(1,:))
    
        elev_dif(i) = elevation(i)-datum;
        tshift = elev_dif(i)/cair;
        shift_amount(i) = round(tshift/dt);
        
        if shift_amount(i) < 0
            select_inds = 1:length(time)+shift_amount(i)+1;
            new_data(abs(shift_amount(i)):end,i) = data(select_inds,i);
        else
            select_inds = shift_amount(i)+1:length(time);
            new_data(1:length(select_inds),i) = data(select_inds,i);
        end
    
    
    if mod(i-1,steps) == 0
        disp([num2str(round(10*(i-1)/steps)),'% Complete'])
    end
end

end