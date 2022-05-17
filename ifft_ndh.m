function [result time] = ifft_ndh(data,freq,dimension);

if exist('dimension') == 0
    temp = size(data);
    if temp(1) > temp(2)
        dimension = 1;
    else
        dimension = 2;
    end
end

data = ifftshift(data,dimension);

if exist('freq') == 0
    result = ifft(data,[],dimension);
    freq = 1:length(data);
elseif length(freq) == 0
    result = ifft(data,[],dimensions);
    freq = 1:length(data);
else
    result = ifft(data,[],dimension);
end

df = freq(2)-freq(1);
dt = 1/df;
time = 0:dt:dt*(length(freq)-1);

%%%%%%%% This doesn't seem to do what I want it?
% result = ifftshift(result,dimension);
if dimension == 1
    result = flipud(result);
elseif dimension == 2
    result = fliplr(result);
end


end
