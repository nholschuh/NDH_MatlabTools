
cl = 35;
title_string = 'Total Produced Broadband Product (Mobim)';
t_or_d = 2;


di = volumes5;

    data = di{1};
    time = di{8};
    f = di{9};
    inline = di{6};
    crossline = di{7};
    
    
    figure(4)
    set(gcf,'Color','white','Position',[ 257   443   983*0.9   655*0.9])
    
    subplot(3,1,1:2)
    colormap(flipud(b2r2(-1,1)));
    imagesc(crossline,time,squeeze(data(cl,:,:))')
    cmax = max(max(abs(squeeze(data(cl,:,:)))));
    xlabel('Crossline Index')
    if t_or_d == 1
        ylabel('Time (s)')
    else
        ylabel('Depth (km)')
    end
    title(title_string,'fontweight','bold')
    caxis([-cmax cmax])
    colorbar
    pause(1)
    
    subplot(3,1,3)
    hold off
    plot(f,magnitude(fft_ndh(squeeze(data(37,150,:)),time)))
hold all
    plot(f,magnitude(squeeze(sum(sum(fft_ndh(data(:,:,:),time,2,0,3),2),1)))/prod(size(data(:,:,1))))
    if t_or_d == 1
        xlabel('Frequency (Hz)')
    else
        xlabel('Wave Number (1/m)')
    end
 
    ylabel('Amplitude')
    xlim([0 100])
    legend({'Individual Trace Result','Global Average'})
