function agc_data = agc_ndh(data,window)
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

energy = conv2(ones(window,1),1,data,'same');
power_scaler = conv2(ones(window,1),1,ones(size(data)),'same');
power = energy./power_scaler;

sample_scaler = 10^(target_power/10) - power;

agc_data = data.*sample_scaler;



