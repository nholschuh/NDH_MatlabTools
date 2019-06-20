function output_signal = power_flatten(series,taxis)

ss = size(series);
if length(ss) == 2
    ss(3) = 1;
end
output_signal = zeros(size(series));
series = series-min(min(min(series)));


    for j = 1:ss(3)
        hx = hilbert(series(:,:,j));
        output_signal(:,:,j) = series(:,:,j)./abs(hx);
    end
end