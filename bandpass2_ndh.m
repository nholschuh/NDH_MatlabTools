function filt_data = bandpass2_ndh(data,xaxis,yaxis,min_f,max_f,plotter);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function applies a two dimensional bandpass filter, assuming the x
% and y axis dimensions are sample spacing are the same
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% data - 
% xaxis - 
% yaxis - 
% inp4 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
% out2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This section does testing for frequency removal
debug_flag = 0;
if debug_flag == 1
    xaxis = 0:0.001:3*pi;
    yaxis = 0:0.001:2*pi;
    data = zeros(length(yaxis),length(xaxis));
    freqx = [1 2 5];
    freqy = [1 2 30];
    
    for i = 1:length(freqx)
        data = data+ones(size(yaxis'))*sin(xaxis*freqx(i)*2*pi);  
    end
    for i = 1:length(freqy)
        data = data+sin(yaxis'*freqy(i)*2*pi)*ones(size(xaxis));
    end
    
    min_f = 0;
    max_f = 0;
end


if exist('plotter') == 0
    plotter = 0;
end
if max_f == 0
    max_f = Inf;
end

test_data = data(:,round(median(length(data(1,:)))));

if min_f == 0 & max_f == 0
    [fft_out faxis] = fft_ndh(test_data,yaxis,2,1);
    xlim([-max(faxis)/8 max(faxis)/8])
    frequencies = graphical_selection(2);
    frequencies = frequencies(:,1);
    min_f = max([min(frequencies) faxis(2)-faxis(1)]);
    max_f = max(frequencies);
end

%%%%%%%%%%% Develop the frequency filter
[N,M] = size(data); %[height, width]
%Sampling intervals 
if length(xaxis) > 1
    dx = abs(xaxis(2)-xaxis(1));
    dy = abs(yaxis(2)-yaxis(1));
else
    dx = xaxis;
    dy = yaxis;
end


%Characteristic wavelengths 
KX0 = (mod(1/2 + (0:(M-1))/M, 1) - 1/2); 
KX1 = KX0 * (2*pi/dx); 
KY0 = (mod(1/2 + (0:(N-1))/N, 1) - 1/2); 
KY1 = KY0 * (2*pi/dy); 
[KX,KY] = meshgrid(KX1,KY1); 
freq_grid = sqrt(KX.*KX + KY.*KY);

lpf = (freq_grid > min_f & freq_grid < max_f); 

idata = fft2(data);
filt_data = ifft2(idata.*lpf);

if debug_flag == 1
    figure
    subplot(1,2,1)
    imagesc(xaxis,yaxis,data);
    subplot(1,2,2)
    imagesc(xaxis,yaxis,real(filt_data));
end

end


