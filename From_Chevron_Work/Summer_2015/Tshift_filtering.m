%Tshift Filtering

% For Time Shift
load traceout_1.mat

% For Time Strain
load traceout_2.mat

end_crop = 400;
time = time(1:end_crop)/1000;
tshift = ex1(1:end_crop);
tshift_2 = ex2(1:end_crop);
base = base(1:end_crop);
mon = mon(1:end_crop);

[seis_f f] = fft_ndh(base,time,1,0,1);
[tshift_f f] = fft_ndh(tshift,time,1,0,1);

[tshift_filt] = stopband_ndh(tshift,time,50,60,0,1);

[tshift_filt_f f] = fft_ndh(tshift_filt,time,1,0,1);


subplot(1,5,1)
hold off
plot(base,time,'Color','red')

subplot(1,5,2)
hold off
plot(tshift,time,'Color','blue')
hold all
plot(tshift_filt,time,':','Color','blue')
set(gca,'YDir','reverse')

subplot(1,5,3:5)
hold off
plot(f,magnitude(seis_f)/max(magnitude(seis_f)),'Color','red')
hold all
plot(f,magnitude(tshift_f)/max(magnitude(tshift_f)),'Color','blue')
plot(f,magnitude(tshift_filt_f)/max(magnitude(tshift_filt_f)),':','Color','blue')
xlim([0 60])

legend({'Seismic Spectrum','TimeShift Spectrum','Filtered TimeShift Spectrum'})
