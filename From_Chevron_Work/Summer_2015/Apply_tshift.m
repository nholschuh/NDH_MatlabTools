function newamp = Apply_tshift(time,amp,tshift)

if size(tshift) ~= size(time)
    tshift = tshift';
end

tshift_dif = tshift(2:end)-tshift(1:end-1);
tshift(2:end) = tshift(2:end)-tshift_dif;
tshift_dif(find(abs(tshift_dif) > 15)) = mean(tshift_dif);
for i = 1:length(tshift)-1
    tshift(i+1) = tshift(i) + tshift_dif(i);
end

t2 = time+tshift;

newamp = interp1(t2,amp,time,'spline');

end