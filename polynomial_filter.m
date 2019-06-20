function [output_data output_filter] = polynomial_filter(dataset,polyset,smoothing_window);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
%  Removes a polynomial signal of a given order as a function of depth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dataset - 
% polyset - 
% smoothing_window - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output_data - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('smoothing_window') == 0
    smoothing_window = 1;
end

samps = 1:length(dataset(:,1));

temp_data = convolve2(dataset,[1 smoothing_window],'same');
normalizer = convolve2(ones(size(dataset)),[1 smoothing_window],'same');
filt_data = temp_data./normalizer;

if polyset > 0
output_data = zeros(size(dataset));

for i = 1:length(dataset(1,:));
    [a b] = polyfit(samps',filt_data(:,i),polyset);
    output_filter(:,i) = polyval(a,samps');
    output_data(:,i) = dataset(:,i) - polyval(a,samps');    

end
else
   output_data = dataset;
   output_filter = zeros(size(dataset));
    
end