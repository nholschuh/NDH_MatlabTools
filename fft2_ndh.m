function [results f_axis_x f_axis_y] = fft2_ndh(data,xaxis,yaxis,plotter)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Calculates and plots the results of an FFT with the correct frequency
% axis. This is done by supplying the time axis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% data - The power values to compute the fft on
% time_axis - The corresponding time values for the power in data
% method - 1 = complex fft results, 2 = fft magnitude, 3 = fft power (dB)
% along_dim - 1 for columns, 2 for rows
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%%% Compute the frequency axis in the x direction
    n = length(xaxis);
    dt = xaxis(2)-xaxis(1);
    samp_freq = (1/dt);
    df = samp_freq/length(xaxis);
     if mod(length(xaxis),2) == 0
         f_axis_x = ((-(n)/2):1:(((n)/2)-1))*df;
     else
         f_axis_x = (-(n-1)/2:1:(n-1)/2)*df;
     end

%%%%%%%% Compute the frequency axis in the y direction     
    n = length(yaxis);
    dt = yaxis(2)-yaxis(1);
    samp_freq = (1/dt);
    df = samp_freq/length(yaxis);
     if mod(length(yaxis),2) == 0
         f_axis_y = ((-(n)/2):1:(((n)/2)-1))*df;
     else
         f_axis_y = (-(n-1)/2:1:(n-1)/2)*df;
     end     
     

    results = fft2(data);
    results = fftshift(results);


if exist('plotter') == 0
    plotter = 0;
end

    if plotter == 1
        imagesc(f_axis_x,f_axis_y,lp(results))
        xlabel('Frequency (Hz)')
        ylabel('Frequency (Hz)')
        colormap(jet)
    end


end
