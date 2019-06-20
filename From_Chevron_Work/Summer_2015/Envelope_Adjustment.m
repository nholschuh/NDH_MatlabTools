%% Envelope Adjustment


window = 31;
filter_type = 1;
taper_on = 1;
rm_high = 1;
taper_freq = 2.5;


traces_of_interest = 5:10;
ex_trace = 5;


load lineout_1.mat


if mod(window,2) == 0
    window = window+1;
end
filter = ones(1,window)/window;
average_ad = conv2(1,filter,ampdiff_amp,'fill');
average_ts = conv2(1,filter,tstrain_amp,'fill');

[ad_f f] = fft_ndh(ampdiff_amp,time/1000,1,0,1);
[ts_f f] = fft_ndh(tstrain_amp,time/1000,1,0,1);


if filter_type == 1
    % Filter the Amplitude Series
    [a,b]=butter(2,0.1);%butterworth Filter of 2 poles and Wn=0.1
    sig_sq=2*magnitude(ad_f).*magnitude(ad_f);% squaring for rectifing
    y_sq = filtfilt(a,b,sig_sq); %applying LPF
    ad_amp2=sqrt(y_sq);%taking Square root
    
    
    % Filter the TimeStrain
    sig_sq=2*magnitude(ts_f).*magnitude(ts_f);% squaring for rectifing
    %gain of 2 for maintianing the same energy in the output
    y_sq = filtfilt(a,b,sig_sq); %applying LPF
    ts_amp2=sqrt(y_sq);%taking Square root
    
    
elseif filter_type == 2
    ad_f = magnitude(ad_f(:,ex_trace));
    ts_f = magnitude(ts_f(:,ex_trace));
    temp1 = signal_attributes(ad_f,f,0);
    temp2 = signal_attributes(ts_f,f,0);
    
    ts_amp2 = temp2(:,2);
    ad_amp2 = temp1(:,2);
    
    
end


scaler_1 = ones(length(f),1)*max(ad_amp2);
ad_amp2 = ad_amp2./scaler_1;



scaler_2 = ones(length(f),1)*max(ts_amp2);
ts_amp2 = ts_amp2./scaler_2;

% Remove the high frequency info.

ts_amp2b = ts_amp2;

if rm_high == 1
    for i = 1:length(ad_amp2(1,:))
        cutoff = abs(f(find(max(ad_amp2(:,i)) == ad_amp2(:,i))));
        cutoff = cutoff(1);
        ts_amp2b(find(f> cutoff | f < -cutoff),i) = 0;
    end
end



if taper_on == 1
    taper_s1 = find_nearest(f,-taper_freq);
    taper_s2 = find_nearest(f,0);
    taper_s3 = find_nearest(f,taper_freq);
    taper_width = taper_s3-taper_s2+1;
    taper = ones(1,length(f));
    g_inf = gausswin(taper_width*5)*3;
    taper(taper_s2:taper_s3) = g_inf(1:taper_width);
    taper(taper_s1:taper_s2) = flipud(g_inf(1:taper_width));
    taper = taper'*ones(1,length(ts_amp2b(1,:)));
end


[ind1] = find(ts_amp2b>ad_amp2);
[ind2] = find(ad_amp2>ts_amp2b);

plotter = 0;
if plotter == 1
    figure(2)
end
scale_series = zeros(size(ts_amp2));

if plotter == 1
    imagesc(scale_series)
    pause(1)
end
scale_series(ind1) = ts_amp2b(ind1);

if plotter == 1
    imagesc(scale_series)
    pause(1)
end
scale_series(ind2) = ad_amp2(ind2);

if plotter == 1
    imagesc(scale_series)
    pause(1)
end


scale_series = scale_series./magnitude(ad_amp2);
if taper_on == 1
    scale_series = scale_series.*taper;
end

if plotter == 1
    imagesc(scale_series)
    pause(1)
end

%%

PI = ifft_ndh(ad_f.*scale_series,f,1);
PI = real(PI);


%% Plots an Example Trace'



figure(4)
set(gcf,'Color','white')

if filter_type == 1
    
    
    b = subplot(2,2,1);
    hold off
    imagesc(1:length(mon(1,:)),time,ampdiff_amp)
    hold all
    plot(ones(length(time),1)*ex_trace,time,'Color','black')
    colorbar()
    colormap(b2r(-100,100));
    caxis([-100 100])
    title('Raw Amplitude Difference')
    
    a = subplot(2,2,3);
    hold off
    imagesc(1:length(mon(1,:)),time,PI)
    hold all
    plot(ones(length(time),1)*ex_trace,time,'Color','black')
    %cshift = 0.5*max(max(PI));
    cshift = 0;
    colormap(b2r(-100+cshift,100+cshift))
    colorbar()
    title('Pseudo-Impedance')
    
    linkaxes([a b],'xy')
    
    subplot(2,2,2)
    hold off
    hold off
    plot(f,magnitude(ad_f(:,ex_trace))./scaler_1(:,ex_trace),':','Color','blue')
    hold all
    plot(f,ad_amp2(:,ex_trace),'Color','blue')
    plot(f,magnitude(ts_f(:,ex_trace))./scaler_2(:,ex_trace),':','Color','red')
    plot(f,real(ts_amp2(:,ex_trace)),'Color','red')
    %legend({'AmpDiff Spectrum','TimeStrain Spectrum'})
    legend({'Amplitude Difference Spectrum','Amplitude Difference Envelope','Time Strain Spectrum','Time Strain Envelope'});
    title('Example Trace Spectra')
    xlabel('Frequency (Hz)')
    xlim([0 40])
    
    subplot(2,2,4)
    hold off
    plot(f,magnitude(ad_f(:,ex_trace).*scale_series(:,ex_trace)),'Color','blue')
    hold all
    plot(f,magnitude(ad_f(:,ex_trace)),'Color','red')
    legend({'Reshaped Amplitude Spectrum','Original Amplitude Spectrum'})
    title('Resulting Spectra')
    xlabel('Frequency (Hz)')
    xlim([0 40])
else
    
    subplot(2,1,2)
    hold off
    plot(f,magnitude(ad_f)./scaler_1,':','Color','blue')
    hold all
    plot(f,ad_amp2(:,ex_trace),'Color','blue')
    plot(f,magnitude(ts_f)./scaler_2,':','Color','red')
    plot(f,real(ts_amp2),'Color','red')
    %legend({'AmpDiff Spectrum','TimeStrain Spectrum'})
    legend({'Amplitude Difference Spectrum','Amplitude Difference Envelope','Time Strain Spectrum','Time Strain Envelope'});
    title('Example Trace Spectra')
    xlabel('Frequency (Hz)')
    xlim([0 40])
    
    subplot(2,2,4)
    plot(f,magnitude(ad_f.*scale_series),'Color','blue','LineWidth',2)
    hold all
    plot(f,magnitude(ad_f),'Color','red')
    legend({'Reshaped Amplitude Spectrum','Original Amplitude Spectrum'})
    title('Resulting Spectra')
    xlabel('Frequency (Hz)')
    xlim([0 40])
    
end



