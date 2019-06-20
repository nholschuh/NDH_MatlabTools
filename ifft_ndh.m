function [result freq] = ifft_ndh(data,freq,dimension);

if exist('dimension') == 0
    temp = size(data);
    if temp(1) > temp(2)
        dimension = 1;
    else
        dimension = 2;
    end
end

if exist('freq') == 0
    result = ifft(data,[],dimension);
    freq = 1:length(data);
elseif length(freq) == 0
    result = ifft(data,[],dimensions);
    freq = 1:length(data);
else
    if freq(1) > freq(end)
        result = ifft(data,[],dimension);
    else
        freq = ifftshift(freq);
        data = ifftshift(data,dimension);
        result = ifft(data,[],dimension);
    end
end

        df = freq(2)-freq(1);
        dt = 1/df;
        time = 0:dt:dt*(length(freq)-1);
end
        