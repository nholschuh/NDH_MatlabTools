function filt_data = bandpass_ndh(data,time_scale,min_f,max_f,plotter,along_dim)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% Filters the supplied data using a bandpass filter. Supply min_f and max_f
% values of 0 for graphical frequency selection.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% data - The power values to compute the fft on
% time_axis - The corresponding time values for the power in data
% min_f / max_f = Filter Corner Frequencies
% plotter = 0 for no plot, 1 for plot
% along_dim - 1 for columns, 2 for rows
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Exception Handling: No plotter value entered
if exist('plotter') == 0
    plotter = 0;
end
if exist('along_dim') == 0
    dims = size(data);
    if max(dims) == dims(2)
        along_dim = 1;
    else
        along_dim = 2;
    end
end

% Exception Handling: Select frequencies from a single trace if multiple
% traces are provided.

if min(size(data)) > 1
    test_data = data(:,1);
else
    test_data = data;
end

% Allows the user to graphically select corner frequences when the min_f
% and max_f are set to 0

if min_f == 0 & max_f == 0
    [fft faxis] = fft_ndh(test_data,time_scale,3,1);
    frequencies = graphical_selection(2);
    frequencies = frequencies(:,1);
    min_f = max([min(frequencies) faxis(2)-faxis(1)]);
    max_f = max(frequencies);
end
   
% Computes the filter and applies it

s_rate = abs(time_scale(2)-time_scale(1));
nyquist = (1/s_rate)/2;

min_f2 = min_f/nyquist;
max_f2 = max_f/nyquist;

[a b] = butter(7,[min_f2 max_f2],'stop');

    filt_data = filter(a,b,data,[],along_dim);


% Exception Handling: Plots the spectra of a representative trace if
% multiple are provided.

if min(size(data)) > 1
    test_filt_data = filt_data(:,1);
else
    test_filt_data = filt_data;
end

if plotter == 1
    figure(98)
    subplot(1,2,1)
    fft_ndh(test_data,time_scale,3,1);
    plot_indicator_lines([min_f max_f],2,'red',1);
    title('Original Data Spectrum')
    subplot(1,2,2)
    fft_ndh(test_filt_data,time_scale,3,1);
    plot_indicator_lines([min_f max_f],2,'red',1);
    title('Filtered Data Spectrum')
end

end