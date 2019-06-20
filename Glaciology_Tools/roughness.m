function    results = roughness(bed_elev,win,xcoord,ycoord)
% Calculates bed roughness using an FFT method and moving window

if length(bed_elev(:,1)) == 1
    bed_elev = transpose(bed_elev);
end

if length(xcoord(:,1)) == 1
    xcoord = transpose(xcoord);
end

if length(ycoord(:,1)) == 1
    ycoord = transpose(ycoord);
end   


dx = pointdistance([xcoord(1) ycoord(1)],[xcoord(2) ycoord(2)]);
Nyquist = (1/2)*(1/dx);
half_window = win/2;
k = win/(dx*win);
dk = k/win;
kscale = (0:win-1)*dk;


% Set up the moving window indices
t_linelength = length(bed_elev);
ntotal = t_linelength - win + 1;
ind(:,1) = 1:ntotal;
ind(:,2) = win:t_linelength;


% Variables for storage

rms = [];
freq_data = [];
freq_derivative_of_data = [];
average_power = [];
average_derivative_power = [];


for n = 1:ntotal
    datawindow = bed_elev(ind(n,1):ind(n,2));
    
    %% RMS Roughness Calculation
    zbar = mean(datawindow);
    rms_data = datawindow - zbar;
    rms_data = rms_data.*rms_data;
    rms(n) = sum(rms_data)/length(datawindow);
    
    %% Fourier Transform Calculations
    
    bed_detrend = detrend(datawindow);
    freq_data(:,n) = fft(bed_detrend,win);
    freq_derivative_of_data(:,n) = freq_data(:,n)*i*2*pi.*kscale';
    
    power = freq_data(:,n).*conj(freq_data(:,n));
    derivative_power = freq_derivative_of_data(:,n).*conj(freq_derivative_of_data(:,n));
    average_power(n) = sum(power(1:half_window));
    average_derivative_power(n) = sum(derivative_power(1:half_window));
    
end

% Write out the coordinates for the associated roughnesses;

filler1 = ones(1,half_window-1)*NaN;
filler2 = ones(1,half_window)*NaN;
rms = [filler1 rms filler2];
average_power = [filler1 average_power filler2];



results = [xcoord ycoord bed_elev rms' average_power'];
end

