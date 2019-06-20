function wiggle_ndh(time,amp,mode,subset,fill,spectra)
% Produces a wiggle plot, either with the amplitudes of all traces
% normalized by the max value (mode = 0) or the amplitudes of each trace
% normalized by that trace's max value (mode = 1), or having applied an AGC
% (mode 2);

if exist('subset') == 0
    subset = 0
end
if length(subset) > 1
    amp = double(amp(:,subset));
else
    amp = double(amp);
end


% Determines if the amplitude matrix orientation is correct
amp_dim = size(amp);
if amp_dim(2) > amp_dim(1)
    amp = amp';
end


% Provides a default argument for "spectra"
if exist('spectra') == 0
    spectra = 0;
end
if exist('fill') == 0
    fill = 0;
end

% Determines if the time vector orientation is correction
if length(time(1,:)) > 1
    time = time';
end

% Produces the time vectors necessary to make the final plot
shape_times = [time(1); time; time(end); time(1)]; 

% Removes the mean value
new_amp = amp-ones(length(time),1)*mean(amp);


% Performs the normalization
if mode == 0
    amp = new_amp/(max(max(abs(new_amp))));
elseif mode == 1
    amp = new_amp./(ones(length(time),1)*max(abs(new_amp)));
elseif mode == 2
    filt_width = length(new_amp(:,1))/150;
    filter = conv2(ones(round(filt_width),1),1,abs(new_amp),'same');
    filter = filter./conv2(ones(round(filt_width),1),1,ones(size(filter)),'same');
    amp = new_amp./(filter);
    amp = amp./(ones(length(time),1)*max(abs(amp)));
    %%% For DC Shift to last sample
    amp = amp - ones(length(time),1)*amp(end,:);
end

%%% If a bandpass filter is desired this section can be included
% for i = 1:length(amp(1,:))
%     amp(:,i) = bandpass_ndh(amp(:,i),time,160,500,0);
% end
%%%

hold off
for i = 1:length(amp(1,:))   

    amp_pos = [0; amp(:,i); .0001];
    amp_pos(find(amp_pos<0)) = 0;
    amp_pos(end+1) = amp_pos(1);
    amp_neg = [0; amp(:,i); -.0001];
    amp_neg(find(amp_neg>0)) = 0;
    amp_neg(end+1) = amp_neg(1);
       
    
    if spectra == 1
        a = subplot(2,1,1);
    end
    plot(amp(:,i)+i-1,time,'Color','black','LineWidth',1)
    if fill == 1
        hold all
        patch(amp_pos+i-1,shape_times,[0.9 0.9 0.9],'LineStyle','none')
    	patch(amp_neg+i-1,shape_times,[0.7 0.7 0.7],'LineStyle','none')
    end

    set(gca,'YDir','reverse')
    ylim([min(time) max(time)])
    xlim([-1 length(amp(1,:))+1])
    ylabel('Two-way Travel Time (\mus)')
    xlabel('Trace')
    title('Radargram')
    NDH_Style()
     
end

if spectra == 1
    [spectra f_axis] = fft_ndh(amp,time,2,0,1);
    b = subplot(2,1,2);
    imagesc(1:length(amp(1,:)),f_axis,spectra);
end

end


