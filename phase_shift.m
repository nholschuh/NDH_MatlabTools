function ts_out = phase_shift(ts,time,shift)
% Takes a time series and performs a phase shift at all frequencies

[Y freq] = fft_ndh(ts,time);
shift = deg2rad(shift);
if size(Y) ~= size(freq)
    freq = freq';
end

ts_out = ifft(Y.*exp(-j*freq*2*pi*shift));


end