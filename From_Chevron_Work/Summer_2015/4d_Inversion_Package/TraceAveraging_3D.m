function [output meta] = TraceAveraging_3D(data,headers,window)
%% (C) 2015 - Chevron ETC - Author: Nick Holschuh (nick.holschuh@gmail.com)
% Takes data read in by ReadSegy from a 3d volume, Averages over a 2D 
% inline/crossline window, and computes the frequency spectra of the averages.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs: %
%%%%%%%%%%%%
% output - Structure that contains 7 variables
%
%    {1} The Seismic Volume
%    {2} The Fourier Transform of the Individual Traces
%    {3} The Regional Averaged Seismic Traces
%    {4} The Spectra of the Average Traces
%    {5} The Regaional Average of the Magnitude Spectra of the Traces
%    {6} The Inline Indecies
%    {7} The Crossline Indecies
%    {8} The Time Axis
%    {9} The Frequency Axis
%    {10} 2D matrix that maps the traces in the volume to the original segy trace position
%    {11} The Window Size
%    
% meta - A cell array describing what output contains
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs: %
%%%%%%%%%%%
% data - data-output from ReadSegy
%
% headers - header-output from Read Segy
%
% window - window size for regional averaging
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Takes data read in by ReadSegy from a 3d volume, Averages over a 2D inline/crossline window, and computes the frequency spectra of the averages.
%%%%%% Compute Necessary Metadata
tic
inlines = [headers.Inline3D];
inline_spacing = min(inlines(find(inlines>min(inlines)))) - min(inlines);
in_ind = min(inlines):inline_spacing:max(inlines);
crosslines = [headers.Crossline3D];
crossline_spacing = min(crosslines(find(crosslines>min(crosslines)))) - min(crosslines);
cross_ind = min(crosslines):crossline_spacing:max(crosslines);
temp = headers(1).LagTimeA;
ts = headers(1).dt/1000;
time = ((1:length(data(:,1)))-1)*ts+temp;
time = time/1000;
disp(['Compiled Header Data - ',num2str(round(toc)),'s'])

%% Convert traces to volume
trace_indecies = 1:length(headers);
for i = 1:length(in_ind)
    for j = 1:length(cross_ind)
        trace_ind = find(inlines == in_ind(i));
        ti = trace_indecies(trace_ind);
        trace_ind = find(crosslines(trace_ind) == cross_ind(j));
        ti = ti(trace_ind);
        if i == 1 | i == length(in_ind) | j == 1 | j == length(cross_ind)
            trace_ind2 = find(inlines == in_ind(20));
            ti2 = trace_indecies(trace_ind2);
            trace_ind2 = find(crosslines(trace_ind2) == cross_ind(20));
            ti2 = ti2(trace_ind2);
            if max(data(:,ti)) > max(data(:,ti2))*2;
                seis_vol(i,j,:) = data(:,ti)/max(data(:,ti))*max(data(:,ti2));
            else
                seis_vol(i,j,:) = data(:,ti);
            end
        else
             seis_vol(i,j,:) = data(:,ti);
        end
        trace_ind_mat(i,j) = ti;
    end
end
disp(['Converted Traces to Volume - ',num2str(round(toc)),'s'])

%% Compute the regional Average
cells_sampled = conv2(ones(size(seis_vol(:,:,i))),ones(window),'same');
for i = 1:length(time);
    seis_vol_filt(:,:,i) = conv2(seis_vol(:,:,i),ones(window),'same')./cells_sampled;
end

disp(['Compute Window Average - ',num2str(round(toc)),'s'])

%% Compute the Trace Spectra
short_dim = find(min([length(in_ind) length(cross_ind)]) == [length(in_ind) length(cross_ind)]);

if short_dim == 1
    for i = 1:length(in_ind)
        seis_spectra(i,:,:) = fft_ndh(squeeze(seis_vol(i,:,:))',time,1,0,1)';
        seis_filt_spectra(i,:,:) = fft_ndh(squeeze(seis_vol_filt(i,:,:))',time,1,0,1)';
    end
else
    for i = 1:length(cross_ind)
        seis_spectra(:,i,:) = fft_ndh(squeeze(seis_vol(:,i,:))',time,1,0,1)';
        seis_filt_spectra(:,i,:) = fft_ndh(squeeze(seis_vol_filt(:,i,:))',time,1,0,1)';
    end    
end

%% Compute the Average Magnitude Spectrum

for i = 1:length(time);
    seis_filt_magnitude_spectra(:,:,i) = conv2(magnitude(seis_spectra(:,:,i)),ones(window)/window^2,'same');
end

[trash f] = fft_ndh(squeeze(seis_vol_filt(30,30,:))',time,1,0,1);


disp(['Compute Averaged Trace Spectra - ',num2str(round(toc)),'s'])

output = {seis_vol,seis_spectra,seis_vol_filt,seis_filt_spectra,seis_filt_magnitude_spectra,in_ind,cross_ind,time,f,trace_ind_mat,window};
meta = {'Seismic Volume','Seismic Spectrum Volume',['Filtered Seismic - Window ',num2str(window),'samples'],'Spectra of Seismic Average','Averaged Spectra','Inline Indecies','Crossline Indecies','Time Axis','Frequency Axis','Original SegY Trace Indecies','Window Size'};
end

