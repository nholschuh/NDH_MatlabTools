%% Spectral Grouping Analysis

[data1 header1] = ReadSegy('./Agbami_OBN_PSDM/Amp_Strain.segy');
[data2 header2] = ReadSegy('./Agbami_OBN_PSDM/AmpDiff_AmpWarping.segy');

inlines = [header1.Inline3D];
in_ind = min(inlines):max(inlines);
crosslines = [header1.Crossline3D];
cross_ind = min(crosslines):max(crosslines);
temp = header1(1).LagTimeA;
ts = header1(1).dt/1000;
time = ((1:length(data1(:,1)))-1)*ts+temp;
time = time/1000;


%%
figure(1)
set(gcf,'Color','white')
log_vals = 0;
group_size = [1 21 101];
f = {};
amp = {};
temp_traces = {};

tin = in_ind(round(length(in_ind)/2));
tx = cross_ind(round(length(cross_ind)/2));

tic
for k = 1:length(group_size)
    
    bottom_mask = 400;
    
    inds = find_nearest_xy([inlines' crosslines'],[tin tx],group_size(k)^2);
    temp_traces{k} = data1(1:400,inds);
    temp_traces2{k} = data2(1:400,inds);
    time_crop = time(1:bottom_mask);
    
    
    [amp{k} f{k}] = fft_ndh(temp_traces{k},time_crop,1,0,1);
    [amp2{k} f2{k}] = fft_ndh(temp_traces2{k},time_crop,1,0,1);
    
    amp{k} = amp{k}(find(f{k} >= 0),:);
    f{k} = f{k}(find(f{k} >= 0));
    amp2{k} = amp2{k}(find(f2{k} >= 0),:);
    f2{k} = f2{k}(find(f2{k} >= 0));
    
    amp{k} = sum(amp{k},2)/length(amp{k}(1,:));
    amp2{k} = sum(amp2{k},2)/length(amp2{k}(1,:));
    
    if log_vals == 1
        f{k} = log10(f{k});
        f2{k} = log10(f2{k});
        amp{k} = lp(magnitude(amp{k}));
        amp2{k} = lp(magnitude(amp2{k}));
    else
        amp{k} = magnitude(amp{k})/max(max(magnitude(amp{k})));
        amp2{k} = magnitude(amp2{k})/max(max(magnitude(amp2{k})));
    end
    
    subplot(length(group_size)+1,1,k)
    plot(f{k},amp{k},'Color','blue')
    hold all
    plot(f2{k},amp2{k},'Color','red')
    
    ylim([40 60])
    ylabel('Power')
    title([num2str(group_size(k)),'x',num2str(group_size(k)),' window'])
    
    if log_vals == 1;
        xlim([0 2])
        xlabel('Log Frequency (Hz)')
    else
        xlabel('Frequency (Hz)')
        xlim([0 50])
    end
    
%     subplot(length(group_size)+1,2,k*2)
%     imagesc(temp_traces{k})
    disp([num2str(round(k/length(group_size)*100)),' Time Elapsed-',num2str(toc)])
    
end

[total_amp total_f] = fft_ndh(data1,time_crop,1,0,1);
[total_amp2 total_f2] = fft_ndh(data2,time_crop,1,0,1);

total_amp = total_amp(find(total_f >= 0),:);
total_f = total_f(find(total_f >= 0));
total_amp2 = total_amp2(find(total_f2 >= 0),:);
total_f2 = total_f2(find(total_f2 >= 0));

total_amp = sum(total_amp,2)/length(total_amp(1,:));
total_amp2 = sum(total_amp2,2)/length(total_amp2(1,:));

if log_vals == 1
    total_f = log10(total_f);
    total_f2 = log10(total_f2);
    total_amp = lp(magnitude(total_amp));
    total_amp2 = lp(magnitude(total_amp2));
else
    total_amp = magnitude(total_amp)/max(max(magnitude(total_amp)));
    total_amp2 = magnitude(total_amp2)/max(max(magnitude(total_amp2)));
end

subplot(length(group_size)+1,1,k+1)
plot(total_f,total_amp,'Color','blue')
hold all
plot(total_f,total_amp2,'Color','red')
    if log_vals == 1;
        xlim([0 2])
        xlabel('Log Frequency (Hz)')
    else
        xlabel('Frequency (Hz)')
        xlim([0 50])
    end
title('Full Data Set')

ylabel('Power')



