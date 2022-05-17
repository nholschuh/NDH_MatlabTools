function agc_data = agc_ndh(data,window,method)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

target_power = 30;

if exist('method') == 0
    method = 0;
end

if method == 0
energy = conv2(data,ones(window,1),'same');
power_scaler = conv2(ones(size(data)),ones(window,1),'same');
elseif method == 1
    fwin = gauss_window(window);
    fwin = fwin(:,round(mean(1:length(fwin(1,:)))));
    energy = conv2(data,fwin,'same');
    power_scaler = conv2(ones(size(data)),fwin,'same');
end




power = energy./power_scaler;

%sample_scaler = 10^(target_power/10) - power;
%agc_data = data.*sample_scaler;

agc_data = power;



