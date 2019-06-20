function [results2 f_axis] = fft_ndh(data,time_axis,method,plotter,along_dim)
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


    n = length(time_axis);
    dt = time_axis(2)-time_axis(1);
    samp_freq = (1/dt);
    df = samp_freq/length(data);
     if mod(length(time_axis),2) == 0
         f_axis = ((-(n)/2):1:(((n)/2)-1))*df;
     else
         f_axis = (-(n-1)/2:1:(n-1)/2)*df;
     end
     
if exist('along_dim') == 0
    results = fft(data);
    results = fftshift(results);
else
    results = fft(data,[],along_dim);
    results = fftshift(results,along_dim);
end

if length(results(1,:)) > 1 & min(size(data)) == 1
    results = results';
end

if exist('plotter') == 0
    plotter = 0;
end
if exist('method') == 0
    method = 2;
elseif method == 0
    method = 2;
end
if method == 1
    results2 = results;
    if plotter == 1
        plot(f_axis,real(results2),'LineWidth',2,'Color','black')
        xlabel('Frequency (Hz)')
        ylabel('Amplitude (real)')
    end
elseif method == 2
    
    results2 = abs(results);
    
    if plotter == 1
        plot(f_axis,results2,'LineWidth',2,'Color','black')
        xlabel('Frequency (Hz)')
        ylabel('Amplitude (mag)')
    end
elseif method == 3
    results2 = 20*log10(abs(results));
    
    if plotter == 1
        plot(f_axis,results2,'LineWidth',2,'Color','black')
        xlabel('Frequency (Hz)')
        ylabel('Power (dB)')
    end
end

% sort_index = sortrows([f_axis' [1:length(f_axis)]']);
% f_axis = sort_index(:,1)';
% results3 = results2(sort_index(:,2),:);

end
