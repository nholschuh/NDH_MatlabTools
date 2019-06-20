function slope_analysis(data,window_size,T,X,freq,plotter);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% For Debugging %%%%%%%%%%%%%%%%%
% 
% load sline3_interp
% data = log10(interp_data.^2);
% %data = data - mean(data,2)*ones(1,length(data(1,:)));
% window_size = 51;
% T = travel_time;
% X = dist;
% freq = 150;
% plotter = 1;
% 
% clearvars -except data window_size T X freq plotter

%%
% data = traces;
% window_size = 201;
% %data = data - mean(data,2)*ones(1,length(data(1,:)));
% plotter = 1;
% freq = 3e6;
% 
% clearvars -except traces data window_size T X freq plotter



%slope_info = zeros(length(T),window_size,length(data(1,:)));
slope_info = zeros(length(T),window_size);
cice_import;
for ii = 1:length(data(1,:))
    %%
    start = max([ii-floor(window_size/2) 1]);
    stop =  min([ii+floor(window_size/2) length(data(1,:))]);
    
    
    if stop-start ~= window_size
        
        f_start1 = ceil((window_size)/2)-round((stop-start)/2);
        f_stop1 = f_start1+stop-start;
 
        
        [slope_info(:,[f_start1:f_stop1],ii) kx] = fft_ndh(data(:,start:stop),X(1:window_size),1,0,2);
    else
        [slope_info(:,:,ii) kx] = fft_ndh(data(:,start:stop),X(start:stop),1,0,2);
        
    end

        k = 2*pi*freq / cice;
        kz = real(sqrt(k.^2 - kx.^2));
        theta = k;
        %theta = (atan2(kz,kx) - pi/2)*180/pi;
        %theta = atan2(sign(kx).*sqrt(kx.^2),real(sqrt((4*k^2-kx.^2))))*180/pi;
        
        if plotter == 1
            subplot(1,5,1)
                imagesc(theta,T,real(slope_info(:,:,ii)))
            subplot(1,5,2:5)
            if ii == 1
                imagesc(X,T,data)
            end
                hold all
                a = plot([X(start) X(start)],[T(1) T(end)],'LineWidth',2,'Color','black');
                b = plot([X(stop) X(stop)],[T(1) T(end)],'LineWidth',2,'Color','black');
                xlim([X(1),X(end)])
                ylim([T(1),T(end)])
                set(gca,'YDir','reverse')
                    pause(0.1)
                    delete(a)
                    delete(b)
        end
        
end
    
for i = 1:length(slope_info(1,1,:))

end
end