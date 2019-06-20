% Automatic Gain Control (Version 1.1 For stereo input output)
%
% usage : y = AGC(x,gain_level,samples)
%
% where :
%          y        : output samples with required gain (range from -1 to +1)
%          x        : input samples (range from -1 to +1)
%       gain_level  : required gain in db
%          N        : number of samples 
%
% Example:
%       y=AGC(data,28,256);
%         data.mat file contains  256 data samples (import this file in workspace for MONO input)
%         data2.mat file contains  256 data samples (import this file in workspace for STEREO input)
%
% Programmer            : Jaydeep Appasaheb Dhole
%                       : Associate Software Engineer ( DSP )
%                       : Aparoksha Tech. Pvt. Ltd. ,Bangalore.
%                       : http://www.aparoksha.com
%                       : <jaydeepdhole@gmail.com>
%
% Version               : 1.1(For Mono and Stereo input signals)
%
% Date                  : 1 June 2006.
%
% Description : AGC algorithm is used to automatically adjust the speech level 
%               of an audio signal to a predetermined value 
%               (normally used unit is in decibel or db )
%                so that subsequent processing operates on signals within a specified dynamic range
%
%       here first understand the concept of the power
%       POWER : average energy over a period. Assuming that the period is N samples,
%
%              N-1     
%             ----     
%          1  \        2
%  P    = --- /    x[n]        power of the signal                     ....eq(1)
%          N  ---- 
%             n = 0  
%
%            N-1     
%           ----     
%          \        2
%  E    =  /    x[n]           energy of the signal                    ....eq(2)
%          ---- 
%           n = 0  
%
%  p (in db) = 10*log10(p/p_ref)
%  since the value of p_ref is taken as 1 Watt , equation becomes
%
%  p (in db) = 10*log10(p)
%
%  now we have to find out the multiplication factor such that :
%                                  
%            output power    =    input power   *   K_Coeff.
% 
%              N-1                   N-1
%             ----                   ----
%          1  \        2          1  \        2
%         --- /    y[n]     =    --- /    x[n]      *    K_Coeff
%          N  ----                N  ----
%             n = 0                  n = 0 
%
%
%
%              N-1                   N-1
%             ----                   ----
%             \        2            \          2
%             /    y[n]     =       /    ( x[n]  *  K )
%             ----                  ----
%             n = 0                  n = 0 
%
%
%      here we are finding the value of K so that we can multiply with 
%      input samples so we will get "output samples with required power"
%
%
%                                      /--------                         
%                       therefor K = \/ K_Coeff
%
%             /------------------------------  
%       K = \/(output_power/input_power)               
%
%             /------------------------------  
%       K = \/(output_power/(input_energy/N))
%
%             /------------------------------  
%       K = \/(output_power*N)/input_energy                             ....eq(3)
%
%       y[0...n] = x[0...n] * K                                         ....eq(4)
%

function [y]= AGC(x,gain_level,N)
 
% for checking the the number of channels
MONO     = 1;
STEREO   = 2;

% if input power level is below threshold don't  do anything
% by changing this value u can change the threshold level
THRESHOLD_VALUE   = 0 ;

% set the output power range here
OUTPUT_POWER_MIN  = -120 ;
OUTPUT_POWER_MAX  = 120 ;

% read the number of channel(s) and  size of the input signal
[m,n]=size(x);

% check validation for mono or stereo signal
if( (n ~= MONO) & (n ~= STEREO) )
        disp('input signal has invalid channels exiting ...')  %optional for testing
        %if input channel(s) are invalid then exit from the function
        y=0;
        return 
end

% check validation input signal size and number of samples
if((1 == m) | (m < N))
        disp(' Warning : input signal length is less than samples exiting ...')  %optional for testing
        %if input channel(s) are invalid then exit from the function
        y=0;
        return 
end

% check for input signal is not zero if zero exit
if( 0 == any(x))
        disp('input signal is ZERO exiting ...')  %optional for testing
        %if input channel(s) are invalid then exit from the function
        y = x(1:N,:); 
        return 
end

% calculate input power
p_db=10*log10(sum(x(1:N,:).^2)/N)                                
%num2str(p_db,'\n input power in db %5f')                            %optional for testing

% check for threshold 
if( min(p_db) < THRESHOLD_VALUE )
        num2str('input power level is below threshold exiting ...')  %optional for testing
        %if input below threshold then output = input
        y = x(1:N,:); 
        return 
end

% check for output power limits
if( (gain_level < OUTPUT_POWER_MIN) | (gain_level > OUTPUT_POWER_MAX) )
        %num2str('output power level is out of range exiting ...')  %optional for testing
        %if required output power is out of range then output = input
        y = x(1:N,:); 
        return 
end

% calculate the normal value of the output power 
% as per our gain level
% gain_level = 10*log10(output_power_Normal)  
% by solving the equation we get 
% output_power_Normal=10.^(gain_level/10);
output_power_Normal = 10.^(gain_level/10);

% calculate the energy of the input                                 (...Refer eq(2))
% here one more advantage of the energy calculation is to avoid the division
% in fix point arithmetic division is expensive so try to avoid the division 
energy = sum(x(1:N,:).^2);

if( n == STEREO)

    %num2str('input signal is STEREO.')  %optional for testing

    % calculate the multiplication factors K1 and K2 for stereo signal   (...Refer eq(3))
    K1 = sqrt( (output_power_Normal*N) / energy(:,1));
    K2 = sqrt( (output_power_Normal*N) / energy(:,2)); 

    % multiply K with input samples to get required stereo output samples      (...Refer eq(4))
    y(1:N,1) = x(1:N,1) * K1;
    y(1:N,2) = x(1:N,2) * K2;

else
    
    %num2str('input signal is MONO.')  %optional for testing

    % calculate the multiplication factor K1 for mono signal (...Refer eq(3))
    K1 = sqrt( (output_power_Normal*N) / energy);

    % multiply K1 with input samples to get required output samples      (...Refer eq(4))
    y(1:N,1) = x(1:N,1) * K1;
end

p_db=10*log10(sum(y.^2)/N);                                         %optional for testing                             
%num2str(p_db,'\n output power in db %5f')                           %optional for testing

% You can comment out the optional part it is just for testing