% Run this code to generate two synthetic seismograms for testing the
% time-shift code. 

clear all
close all

scaler = 0.9;
reflection_frequency = 0.005;
wavelet = 0.05;
dt=0.001;
max_t = 1;


% Construct the random lag series.
time_axis = 0:dt:max_t;
power = zeros(1,length(time_axis));

for i = 1:length(time_axis);
    if rand(1) > 1-reflection_frequency;
        power(i) = 2*(rand(1)-0.5);
    end
end

% Function for desired shifts is defined here by 'lags'
% sinusoidal lag
lags = round(sin(time_axis)*4);
% constant lag
lags = ones(1,length(time_axis))*0.05/dt;

% Resample the previous series at higher resolution
new_dt = (time_axis(2)-time_axis(1))/10;
warped_power = zeros(1,length(power));

for i = 1:length(power)
    if power(i) ~= 0  
        warped_power(i+lags(i)) = power(i)*scaler;
    end
end

% Convolve the results with a ricker wavelet
[rw t] = ricker(1/wavelet,wavelet/dt*4,dt);
plot(t,rw);

cutoff = find(max(rw) == rw);


% Plot and save the two series
[seis0] = conv(rw,power);
seis0 = seis0(cutoff:end-length(rw)+cutoff);

[seis1] = conv(rw,warped_power);
seis1 = seis1(cutoff:end-length(rw)+cutoff);


subplot(2,1,1)
stem(time_axis,power,'Color','blue')
hold all
stem(time_axis,warped_power,'Color','black')
xlabel('Time (s)')
ylabel('Reflectivity')
title('Reflectivity Series')

subplot(2,1,2)
plot(time_axis,seis0,'LineWidth',2,'Color','blue')
hold all
plot(time_axis,seis1,'LineWidth',2,'Color','black')
xlabel('Time (s)')
ylabel('Amplitude')
title('Seismograms')

time_axis0 = time_axis;
time_axis1 = time_axis;

seis = seis0;
save Seis0.mat seis0 time_axis0

seis = seis1;
save Seis1.mat seis1 time_axis1
