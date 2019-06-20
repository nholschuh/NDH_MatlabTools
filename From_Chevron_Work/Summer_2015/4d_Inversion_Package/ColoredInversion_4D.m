function [Final_Product debug_output] = ColoredInversion_4D(Seismic_TraceAveraging_Output,LF_TraceAveraging_Output,merge_onoff,f_merge,save_flag,TShift_TraceAveraging_Output,parameter_mat)
%% (C) 2015 - Chevron ETC - Author: Nick Holschuh (nick.holschuh@gmail.com)
% This code is designed to spectrally shape a 3D seismic volume, as well as
% merge with a low-frequency volume (originally intended for 4D inversion
% of amplitude differences using seismic time-strains).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs: %
%%%%%%%%%%%%
% Final_Product - 3D Volume that has either been spectrally shaped, merged,
%                 or both.
% debug_output - This is a set of the intermediate products for use in
%                debugging the code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs: %
%%%%%%%%%%%
% Seismic_TraceAveraging_Output - Seismic volume output from the
%                                 "TraceAveraging_3D.m" function.
%
% LF_TraceAveraging_Output - Time strain output from TA3D function
%
% merge_onoff - flag to determine whether or not there is only spectral
%               shaping (0) or shaping with merge (1).
%
% f_merge - prescribe the frequencies over which the merge occurs (in a 1x2
%           vector with [lowf highf] or let the algorithm decide [0 0]
%
% save_flag - (1) automatically save the results with all chosen parameters
%             defined in the name, or no automatic save (0)
%
% TShift_TraceAveraging_Output - [optional] time shift volume for use in
%                                shaping (alternatively, enter a 0)
%
% parameter_mat - Matrix of all parameter values to be used in the shaping
%                 and merge. The parameter set choices are listed below. The
%                 recommended values are supplied in the code, if the default 
%                 is desired simply enter (0). Parameters are listed below,
%                 and their definitions can be found on line 70. 
%
%    (1x12 matrix)              (suggested default)
%    merge_onoff                0
%    spectral_shaping_method    1
%    shape_lf                   0
%    exact_shaping_hf           -1    
%    exact_shaping_lf           -1
%    dc_shift_correction        -1
%    merge_filter_type          1
%    ad_power_equalization      0
%    global_lf_boost1           0
%    global_lf_boost2           0
%    blend                      0.4
%    tshift_flag                0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

debugger = 0;
if debugger == 1
    Seismic_TraceAveraging_Output = volumes2;
    LF_TraceAveraging_Output = volumes1;
    merge_onoff = 0;
    f_merge = [1 4];
end

% Exception handling
if exist('TShift_TraceAveraging_Output') == 0
    tshift_flag = 0;
else
    if length(TShift_TraceAveraging_Output) == 1
        tshift_flag = 0;
    else
        tshift_flag = 1;
        tshift_filt_spectra = TShift_TraceAveraging_Output{5};
        tshift_spectra = TShift_TraceAveraging_Output{2};
    end
end

if exist('save_flag') == 0
    save_flag = 0;
end

if exist('parameter_mat') == 0 || length(parameter_mat) < 5

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TESTING FLAGS HERE %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    spectral_shaping_method = 1;
    % 1 - Uses linear fit of the lf spectrum in log/log space
    % 2 - Uses the spectral envelope comparison (deprecated)
    
    shape_lf = 0;
    % 0 - No spectral shaping of the lf data
    % 1 - Spectrally shapes the individual lf trace using the average lf trace
    
    exact_shaping_hf = -1;
    exact_shaping_lf = 0;
    %-1 - Uses the regional average spectrum 
    % 0 - Uses the envelope to shape the seismic (and potentially lf) data
    % 1 - Forces each seismic spectrum to be exactly Ax^b in magnitude on a
    % trace by trace basis
    % 2 - Forces the regional average spectrum to be flat
    
    dc_shift_correction = -1;
    %-1 - Shape to the real exponential at low f
    % 0 - Force no shaping at low frequencies (NOT RECOMMENDED)
    % 1 - Applies a low frequency reduction after shaping
    % 2 - Cosine Taper up to a dc shift after f_cutoff
    
    merge_filter_type = 1;
    % 0 - No overlap in merge data
    % 1 - Sin decay in merge filter
    % 2 - Intelligent Phase / Amplitude Combination
    % 3 - Forces the phase of the lf to be = to the nearest hf sample
    
    ad_power_equalization = 0;
    % 0 - Each trace is power scaled individually
    % 1 - The power distribution over the volume is forced to the power
    % distribution of the AD volume (ie - traces with low power in AD have low
    % power in the final product)
    
    global_lf_boost1 = 0;
    global_lf_boost2 = 0; % only if exact_lf_shaping == -1
    % 0 - Boost the low frequencies trace by trace
    % 1 - Smooth the low frequency scalar using the window size.
    
    blend = 0.4;
    % 0 - Use purely the algorithm defined by the above flags (runs twice as
    %     fast)
    % (0 1] - Blend the result of the above algorithm with the result of a
    %       perfect spectral match, according to the fraction pure provided
    

else %%%%%%%%%% Read In Parameters for Automation %%%%%%%%%%%%%%%
    merge_onoff = parameter_mat(1);                             %
    spectral_shaping_method = parameter_mat(2);                 %
    shape_lf = parameter_mat(3);                                %
    exact_shaping_hf = parameter_mat(4);                        %
    exact_shaping_lf = parameter_mat(5);                        %
    dc_shift_correction = parameter_mat(6);                     %
    merge_filter_type = parameter_mat(7);                       %
    ad_power_equalization = parameter_mat(8);                   %
    global_lf_boost1 = parameter_mat(9);                        %
    global_lf_boost2 = parameter_mat(10);                       %
    blend = parameter_mat(11);                                  %
    tshift_flag = parameter_mat(12);                            %
end  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters that meaningfully change the results %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fit_shift = 1000;  % The shift away from f=0 for data when fitting exponential
    shift_scaler = 0.8;   % The degree to which spectra are stretched to fit the exponential, versus shifted up
    additional_shift_factor = 3;  % Boost amount for the "signal" relative to the frequencies outside of the calculated seismic range
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% The pre-loop variable initation
%%%%%%%%%%%
tic
seis = Seismic_TraceAveraging_Output{1};
seis_spectra = Seismic_TraceAveraging_Output{2};
seis_filt_spectra = Seismic_TraceAveraging_Output{5};
lf_spectra = LF_TraceAveraging_Output{2};
lf_filt_spectra = LF_TraceAveraging_Output{5};

in_ind = Seismic_TraceAveraging_Output{6};
cross_ind = Seismic_TraceAveraging_Output{7};
time = Seismic_TraceAveraging_Output{8};
f = Seismic_TraceAveraging_Output{9};

if shape_lf == 1
    shaped_lf_spectra = zeros(size(lf_spectra));
end

% Define the frequency range over which the exponential fit is performed
filter_range = [2 40];
new_f_log = log10(f(find(f>0)));
new_f = f(find(f>0));
new_f_ind = find(f>0);
mat_size = size(seis);
scale_volume = zeros(mat_size);
lf_scaling_volume = zeros(mat_size);
scale_mat = zeros(mat_size(2:3));

ind_range = find(new_f > filter_range(1) & new_f < filter_range(2));

one_pad = ones(length(new_f(ind_range)),1);
zero_freq = find(f == 0);
hf_base_scaler = squeeze(max(seis,[],3))/max(max(squeeze(max(seis,[],3))));
filt_coef = zeros([mat_size(1:2),2]);
filt_coef_lf = zeros([mat_size(1:2),2]);
windowsize = Seismic_TraceAveraging_Output{end};

disp('Computing Spectral Shaping Filters')

%%%%%%%%%%%%%%%%%% Define the cutoff frequency for method 1
bulk_spectrum = sum(squeeze(sum(magnitude(seis_spectra),2)),1);
[a,b]=butter(2,0.1);
sig_sq=magnitude(bulk_spectrum(new_f_ind));
bulk_filtered=filtfilt(a,b,sig_sq);
temp = max(bulk_filtered(find(new_f>3)));
matching_f_samp = find(bulk_filtered == temp); % Find the maximum power at F > 3Hz
bulk_change = [0 bulk_filtered(2:end)-bulk_filtered(1:end-1)]; % Slope of envelope
c_f = zeros(1,4);
for i = 1:length(new_f)
    if bulk_change(matching_f_samp-i+1) > 0 & bulk_change(matching_f_samp-i) < 0
        c_f_new(1) = matching_f_samp-i; % Sample defining the left edge of the HF shaping filter in new_f
        c_f(2:3) = [find(-new_f(c_f_new(1)) == f), find(new_f(c_f_new(1)) == f)]; % Sample defining the left edges in full f
        break
    elseif bulk_filtered(matching_f_samp-i) < 0.5*bulk_filtered(matching_f_samp)
        c_f_new(1) = matching_f_samp-i; % Sample defining the left edge of the HF shaping filter in new_f
        c_f(2:3) = [find(-new_f(c_f_new(1)) == f), find(new_f(c_f_new(1)) == f)]; % Sample defining the left edges in full f
        break
    end
end
for i = 1:length(new_f)
    if bulk_filtered(matching_f_samp+i) < 0.8*bulk_filtered(matching_f_samp)
        c_f_new(2) = matching_f_samp+i; % Sample defining the right edge of the HF shaping filter in new_f
        c_f([1,4]) = [find(f == -new_f(c_f_new(2))), find(f == new_f(c_f_new(2)))]; % Sample defining the left edges in full f
        break
    end
end

% Consistent Filter Parameters
[filt_a,filt_b]=butter(2,0.1);

% Merge Configuration
fcenter = (c_f_new(1));
if max(f_merge) == 0
    f_merge = [new_f(fcenter) new_f(round(fcenter+0.4*fcenter))];
end

% For lf_taper

lowest_fshift_scaler = 4; % Defines the lowest dc shift factor for cos taper
lf_sin_sampnum = round(fcenter*(0.6));
lf_sin_x = linspace(-pi/8,9*pi/8,lf_sin_sampnum*2+1);
lf_sin_intro = abs((cos(lf_sin_x)));
mid_r = zero_freq-lf_sin_sampnum:zero_freq+lf_sin_sampnum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Define the taper for method 2
taper_freq = 2.5;
taper_s1 = find_nearest(f,-taper_freq);
taper_s2 = find_nearest(f,0);
taper_s3 = find_nearest(f,taper_freq);
taper_width = taper_s3-taper_s2+1;
taper = ones(1,length(f));
g_inf = gausswin(taper_width*5)*3;
taper(taper_s2:taper_s3) = g_inf(1:taper_width);
taper(taper_s1:taper_s2) = flipud(g_inf(1:taper_width));
taper = taper';


if blend > 0
    reps = 2;
    if exact_shaping_hf == 2;
        flat_flag = 1;
    else
        flat_flag = 0;
    end
    shape_lf_temp = shape_lf;
    exact_shaping_hf_temp = exact_shaping_hf;
    exact_shaping_lf_temp = exact_shaping_lf;
    shape_lf = 1;
    exact_shaping_hf = 1;
    exact_shaping_lf = 1;
else
    flat_flag = 0;
    reps = 1;
end
%%%%%%%%%%%
%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  The Grand Loop

for blend_loop = 1:reps       % reps = 1 for no blend, reps = 2 for blend
    if blend_loop == 2
        shape_lf = shape_lf_temp;
        exact_shaping_hf = exact_shaping_hf_temp;
        exact_shaping_lf = exact_shaping_lf_temp;
    end
    
    for i = 1:length(in_ind)                  % Loops across the # of inlines
        for j = 1:length(cross_ind)           % Loops across the # of crosslines
            
            if spectral_shaping_method == 1
                
                %%% Fits an exponential to the regionally averaged low
                %%% frequency volume (either tshift or tstrain)
                if tshift_flag == 0
                    filt_coef(i,j,:) = [log(new_f(ind_range)+fit_shift)' one_pad]\log(magnitude(squeeze(lf_filt_spectra(i,j,new_f_ind(ind_range)))));
                else
                    filt_coef(i,j,:) = [log(new_f(ind_range)+fit_shift)' one_pad]\log(magnitude(squeeze(tshift_filt_spectra(i,j,new_f_ind(ind_range)))));
                end
                seis_filt_f = magnitude(squeeze(seis_filt_spectra(i,j,new_f_ind)));
                seis_f = magnitude(squeeze(seis_spectra(i,j,new_f_ind)));
                
                
                % Compute Seismic Spectral Envelope (seis_f_env)
                
                
                sig_sq1=seis_f.*seis_f;
                y_sq1 = filtfilt(filt_a,filt_b,sig_sq1);
                y_sq1(find(y_sq1 < 0)) = min(y_sq1);
                seis_f_env=sqrt(y_sq1);
                
                sig_sq2=seis_filt_f.*seis_filt_f;
                y_sq2 = filtfilt(filt_a,filt_b,sig_sq2);
                y_sq2(find(y_sq2 < 0)) = min(y_sq2);
                seis_filt_f_env=sqrt(y_sq2);
                

                
                % Convert low-frequency exponential from log-log space to
                % linear space, and determine the power of the ideal low
                % frequency exponential at the matching frequency.
                white_spec = (new_f+fit_shift).^filt_coef(i,j,1)*exp(filt_coef(i,j,2));
                power_at_matchingf = white_spec(matching_f_samp);
                
                if exact_shaping_hf == 2 || flat_flag == 1
                    white_spec(:) = power_at_matchingf;
                end
                
                


                    scale1 = seis_f_env(matching_f_samp)/power_at_matchingf;
                    
                    sum_dif(i,j) = seis_f_env(matching_f_samp) - power_at_matchingf;

                % Scale and shift the desired exponential function based on
                % defined parameters
                scale_series = (white_spec'*scale1*shift_scaler + shift_scaler*sum_dif(i,j)*additional_shift_factor);
                
                % Taper the scaling series at edges of seismic frequencies
                max_cos_length = 50;
                
                cos_in = (sin([linspace(-pi/2,pi/2,min([c_f_new(1) max_cos_length]))])+1)/2*(scale_series(c_f_new(1)));
                cos_out = zeros(1,length(scale_series(c_f_new(2)+1:end)));
                cos_out(1:length(cos_in)) = fliplr(sin([linspace(-pi/2,pi/2,length(cos_in))])+1)/2*(scale_series(c_f_new(2)));
                scale_series((c_f_new(1)-length(cos_in)+1):c_f_new(1)) = cos_in;
                scale_series(c_f_new(2)+1:end) = cos_out;
                if (c_f_new(1)-length(cos_in)+1) > 1
                    scale_series(1:c_f_new(1)-length(cos_in)+1) = 0;
                end 
                
                
                
                % Defines the scaling series based on the 
                if exact_shaping_hf == -1
                    scale_series = scale_series./seis_filt_f_env;
                elseif exact_shaping_hf == 0
                    scale_series = scale_series./seis_f_env;
                elseif exact_shaping_hf == 1
                    scale_series = scale_series./seis_f;
                elseif exact_shaping_hf == 2
                    scale_series = scale_series./seis_filt_f_env;
                end
                
                if mod(length(f),2) == 0
                    scale_series = [0; flipud(scale_series); 0; scale_series];
                else
                    scale_series = [flipud(scale_series); 0; scale_series];
                end
                
            
                
               
                
                white_spec = (abs(f')+fit_shift).^filt_coef(i,j,1)*exp(filt_coef(i,j,2));
                
                if exact_shaping_hf == 2 || flat_flag == 0
                    white_spec(:) = power_at_matchingf;
                end
                
                white_spec = (white_spec'*scale1*shift_scaler + shift_scaler*sum_dif(i,j)*additional_shift_factor);
                white_spec_vol(i,j,:) = white_spec;

                
                 
                if tshift_flag == 0
                    lf_scaler(i,j) = scale1;
                else
                    tstrain_spec = magnitude(squeeze(lf_filt_spectra(i,j,new_f_ind)));
                    additional_scaler = power_at_matchingf/magnitude(tstrain_spec(matching_f_samp));
                    lf_scaler(i,j) = additional_scaler;
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Shaping of the Low Frequencies if Desired
                if shape_lf == 1
                    
                    lf_white_spectra = exp(filt_coef(i,j,2))*(abs(f')+fit_shift).^filt_coef(i,j,1);
                    lfpower_at_matchingf= lf_white_spectra(matching_f_samp);
                    
                    if exact_shaping_hf == 2 || flat_flag == 1
                        lf_white_spectra(:) = lfpower_at_matchingf;
                    end
                    
                    
                    %%%% Here we specify what to do with the Lowest Frequencies
                    if dc_shift_correction == -1 % No adjustment at low frequencies;
                        
                    elseif dc_shift_correction == 0 % Force Low frequencies to be unshaped
                        lf_white_spectra(zero_freq-lf_sin_sampnum:zero_freq+lf_sin_sampnum) = magnitude(squeeze(lf_spectra(i,j,zero_freq-lf_sin_sampnum:zero_freq+lf_sin_sampnum)))/magnitude(lf_spectra(i,j,zero_freq-lf_sin_sampnum))*lf_white_spectra(zero_freq-lf_sin_sampnum);
                    elseif dc_shift_correction == 1 % Sin Taper Low frequencies to a low value
                        sin_shift = magnitude(lf_white_spectra(zero_freq+lf_sin_sampnum))/lowest_fshift_scaler;
                        sin_scale = magnitude(lf_white_spectra(zero_freq+lf_sin_sampnum));
                        lf_sin_scale_series = (lf_sin_intro*(sin_scale-sin_shift)+sin_shift);
                        lf_white_spectra(mid_r) = lf_sin_scale_series;
                    elseif dc_shift_correction == 2 % Sin Taper Low frequencies to a high f
                        cutoff_val = round(c_f_new(1)*0.5);
                        c_ind = find(f == new_f(cutoff_val));
                        replace_range = find(f == -new_f(cutoff_val)):find(f == new_f(cutoff_val));
                        cos_scaling = (lf_white_spectra(c_ind) - lf_white_spectra(c_ind+1))/(f(2)-f(1))*2;
                        cos_shift = lf_white_spectra(c_ind);
                        lf_white_spectra(replace_range) = abs(sin(linspace(0,pi,length(replace_range))))*cos_scaling+cos_shift;
                    end
    
                    
                    
                    

%                         sig_sq1=magnitude(squeeze(lf_filt_spectra(i,j,:)));
%                         y_sq1 = filtfilt(filt_a,filt_b,sig_sq1);
%                         y_sq1(find(y_sq1 < 0)) = min(y_sq1);
%                         lf_filt_env = y_sq1;
                          lf_filt_coef = [log(new_f(ind_range)+fit_shift)' one_pad]\log(magnitude(squeeze(lf_filt_spectra(i,j,new_f_ind(ind_range)))));
                          lf_filt_env = exp(lf_filt_coef(2))*(abs(f')+fit_shift).^lf_filt_coef(1);
                          lf_filt_env = (lf_filt_env*lf_scaler(i,j)*shift_scaler)/lf_scaler(i,j);

%                         sig_sq2=magnitude(squeeze(lf_spectra(i,j,:)));
%                         y_sq2 = filtfilt(filt_a,filt_b,sig_sq2);
%                         y_sq2(find(y_sq2 < 0)) = min(y_sq2);
%                        lf_env = y_sq2;
                         lf_coef = [log(new_f(ind_range)+fit_shift)' one_pad]\log(magnitude(squeeze(lf_spectra(i,j,new_f_ind(ind_range)))));
                         lf_env = exp(lf_coef(2))*(abs(f')+fit_shift).^lf_coef(1);
                         fit_shift_temp = fit_shift;
                         while max(isnan(lf_env)) > 0
                             fit_shift_temp = fit_shift_temp*0.5;
                             lf_coef = [log(new_f(ind_range)+fit_shift_temp)' one_pad]\log(magnitude(squeeze(lf_spectra(i,j,new_f_ind(ind_range)))));
                             lf_env = exp(lf_coef(2))*(abs(f')+fit_shift_temp).^lf_coef(1);
                         end
                         
                         lf_env = (lf_env*lf_scaler(i,j)*shift_scaler)/lf_scaler(i,j);

                        if exact_shaping_lf == -1
                            lf_scaling_volume(i,j,:) = lf_white_spectra./lf_filt_env + shift_scaler*sum_dif(i,j)*additional_shift_factor/lf_scaler(i,j);
                        elseif exact_shaping_lf == 0
                            lf_scaling_volume(i,j,:) = lf_white_spectra./lf_env + shift_scaler*sum_dif(i,j)*additional_shift_factor/lf_scaler(i,j);
                        elseif exact_shaping_lf == 1
                            lf_white_spectra = (lf_white_spectra*lf_scaler(i,j)*shift_scaler + shift_scaler*sum_dif(i,j)*additional_shift_factor)/lf_scaler(i,j);
                            lf_scaling_volume(i,j,:) = lf_white_spectra./magnitude(squeeze(lf_spectra(i,j,:)));
                        elseif exact_shaping_lf == 1
                           lf_scaling_volume(i,j,:) = lf_white_spectra./lf_filt_env + shift_scaler*sum_dif(i,j)*additional_shift_factor/lf_scaler(i,j);
                        end
                        
               end
                %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Attempting other method
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%
            elseif spectral_shaping_method == 2
                
                seis_f = magnitude(squeeze(seis_filt_spectra(i,j,:)));
                lf_f = magnitude(squeeze(lf_filt_spectra(i,j,:)));
                
                % Filter the Amplitude Series
                sig_sq=2*magnitude(seis_f).*magnitude(seis_f);% squaring for rectifing
                y_sq = filtfilt(filt_a,filt_b,sig_sq); %applying LPF
                ad_amp2=sqrt(y_sq);%taking Square root
                
                
                % Filter the TimeStrain
                sig_sq=2*lf_f.*lf_f;% squaring for rectifing
                %gain of 2 for maintianing the same energy in the output
                y_sq = filtfilt(filt_a,filt_b,sig_sq); %applying LPF
                ts_amp2=sqrt(y_sq);%taking Square root
                
                
                
                scaler_1 = ones(length(f),1)*max(real(ad_amp2));
                ad_amp2 = magnitude(ad_amp2)./scaler_1;
                
                scaler_2 = ones(length(f),1)*max(real(ts_amp2));
                ts_amp2 = magnitude(ts_amp2)./scaler_2;
                ts_amp2b = ts_amp2;
                
                lf_scaler(i,j) = max(scaler_1./scaler_2);
                
                % Filter out the high frequencies
                cutoff = abs(f(find(max(ad_amp2) == ad_amp2)));
                cutoff = cutoff(1);
                ts_amp2b(find(f> cutoff | f < -cutoff)) = 0;
                
                
                
                [ind1] = find(ts_amp2b>ad_amp2);
                [ind2] = find(ad_amp2>ts_amp2b);
                
                c_f_new = round(min(ind2)*0.75);
                
                scale_series = zeros(size(ts_amp2));
                scale_series(ind1) = ts_amp2b(ind1);
                scale_series(ind2) = ad_amp2(ind2);
                scale_series = scale_series./magnitude(ad_amp2);
                scale_series = scale_series.*taper;
                
                
            end
            
            
            
            % Store the scale series into a new volume
            scale_mat(j,:) = scale_series;
            
        end
        if mod(i,20) == 0
            disp([num2str(round(i*100/length(in_ind))),'% Complete'])
        end
        scale_volume(i,:,:) = real(scale_mat);
        
    end
    
    %% Apply the scaling filter
    disp('Computing new traces from scaled spectra.')
    scaled_seis_spectra = seis_spectra.*scale_volume;
    
    if max(f_merge) == 0
        fcenter = (c_f_new(1));
        f_merge = [new_f(fcenter) new_f(round(fcenter+0.4*fcenter))];
    end
    
    freq_cutoffs(1) = find_nearest(f,-f_merge(2));
    freq_cutoffs(2) = find_nearest(f,-f_merge(1));
    freq_cutoffs(3) = find_nearest(f,f_merge(1));
    freq_cutoffs(4) = find_nearest(f,f_merge(2));
    %Convert from Frequency back to time, and merge.
    
    % Scale the LF_Volume
    scale_lf_volume = zeros(size(lf_spectra));
    
    if global_lf_boost1 == 1
%         lf_scaler = conv2(lf_scaler,ones(windowsize),'same');
%         lf_scaler = lf_scaler./(conv2(ones(size(lf_scaler)),ones(windowsize),'same'));
            lf_scaler(:,:) = min(min(lf_scaler));
    end
    

    
    for i = 1:length(in_ind)
        for j = 1:length(cross_ind);
            if shape_lf == 1
                shaped_lf_spectra(i,j,:) = squeeze(lf_spectra(i,j,:)).*squeeze(lf_scaling_volume(i,j,:));
                scale_lf_volume(i,j,:) = shaped_lf_spectra(i,j,:)*lf_scaler(i,j);
            else
                scale_lf_volume(i,j,:) = lf_spectra(i,j,:)*lf_scaler(i,j);
            end
            
        end
    end
    disp('Low Frequency Scaling Complete')
    
    %% Compute the merge filter volumes
    disp('Performing the Merge')
    
    if merge_onoff == 1
        
        sin_back = cos(linspace(0,pi,freq_cutoffs(2)-freq_cutoffs(1)+1))/2;
        sin_for = fliplr(sin_back);
        
        if merge_filter_type == 0
            lf_mergefilt = zeros(length(f),1);
            hf_mergefilt = ones(length(f),1);
            lf_mergefilt(freq_cutoffs(2):freq_cutoffs(3)) = ones(length(lf_mergefilt(freq_cutoffs(2):freq_cutoffs(3))),1);
            hf_mergefilt(freq_cutoffs(2):freq_cutoffs(3)) = zeros(length(lf_mergefilt(freq_cutoffs(2):freq_cutoffs(3))),1);
        elseif merge_filter_type == 1 | merge_filter_type == 2 | merge_filter_type == 3
            lf_mergefilt = zeros(length(f),1);
            hf_mergefilt = ones(length(f),1);
            
            lf_mergefilt(freq_cutoffs(1):freq_cutoffs(2)) = sin_for+0.5;
            lf_mergefilt(freq_cutoffs(2):freq_cutoffs(3)) = ones(length(lf_mergefilt(freq_cutoffs(2):freq_cutoffs(3))),1);
            lf_mergefilt(freq_cutoffs(3):freq_cutoffs(4)) = sin_back+0.5;
            
            hf_mergefilt(freq_cutoffs(1):freq_cutoffs(2)) = sin_back+0.5;
            hf_mergefilt(freq_cutoffs(2):freq_cutoffs(3)) = zeros(length(hf_mergefilt(freq_cutoffs(2):freq_cutoffs(3))),1);
            hf_mergefilt(freq_cutoffs(3):freq_cutoffs(4)) = sin_for+0.5;
        end
        
        
        
        lf_mergefilt_volume = zeros(size(lf_filt_spectra));
        hf_mergefilt_volume = zeros(size(seis_spectra));
        % Produce MergeFilter Volumes
        for i = 1:length(in_ind)
            for j = 1:length(cross_ind);
                % Standard sin decay merge
                if merge_filter_type == 0 | merge_filter_type == 1;
                    if ad_power_equalization == 0;
                        lf_mergefilt_volume(i,j,:) = lf_mergefilt;
                        hf_mergefilt_volume(i,j,:) = hf_mergefilt;
                    else
                        lf_mergefilt_volume(i,j,:) = lf_mergefilt*hf_base_scaler(i,j);
                        hf_mergefilt_volume(i,j,:) = hf_mergefilt*hf_base_scaler(i,j);
                    end
                % Amplitude Consistent Merge (or intellignet merge)
                elseif merge_filter_type == 2
                    temp_lf_mergefilt = lf_mergefilt;
                    temp_hf_mergefilt = hf_mergefilt;
                    loopvec = [find(lf_mergefilt ~= 0 & lf_mergefilt~= 1)];
                    warning('off','all')
                    for k = 1:length(loopvec); % Does a proper scaling using Linear Algebra and a change of basis
                        replace_ind = loopvec(k);
                        t_phase = angle(scale_lf_volume(i,j,replace_ind))*lf_mergefilt(replace_ind) + angle(scaled_seis_spectra(i,j,replace_ind))*hf_mergefilt(replace_ind);
                        t_amp = magnitude(scale_lf_volume(i,j,replace_ind))*lf_mergefilt(replace_ind) + magnitude(scaled_seis_spectra(i,j,replace_ind))*hf_mergefilt(replace_ind);
                        t_vec = t_amp.*exp(t_phase*sqrt(-1));
                        t_vec = [real(t_vec); imag(t_vec)];
                        basis = [real(scale_lf_volume(i,j,replace_ind)) real(scaled_seis_spectra(i,j,replace_ind)); imag(scale_lf_volume(i,j,replace_ind)) imag(scaled_seis_spectra(i,j,replace_ind))];
                        new_scale = inv(basis)*t_vec;
                        temp_lf_mergefilt(replace_ind) = new_scale(1);
                        temp_hf_mergefilt(replace_ind) = new_scale(2);
                    end
                    warning('on','all')
                    lf_mergefilt_volume(i,j,:) = temp_lf_mergefilt;
                    hf_mergefilt_volume(i,j,:) = temp_hf_mergefilt;
                elseif merge_filter_type == 3
                    temp_lf_mergefilt = lf_mergefilt;
                    temp_hf_mergefilt = hf_mergefilt;
                    loopvec = [find(lf_mergefilt~= 0 & f' ~= 0)];
                    warning('off','all')
                    for k = 1:length(loopvec); % Does a proper scaling using Linear Algebra and a change of basis
                        replace_ind = loopvec(k);
                        if k < length(loopvec)/2
                            t_phase = angle(scaled_seis_spectra(i,j,loopvec(1)));
                        else
                            t_phase = angle(scaled_seis_spectra(i,j,loopvec(end)));
                        end
                        t_amp = magnitude(scale_lf_volume(i,j,replace_ind))*lf_mergefilt(replace_ind) + magnitude(scaled_seis_spectra(i,j,replace_ind))*hf_mergefilt(replace_ind);
                        t_vec = t_amp.*exp(t_phase*sqrt(-1));
                        t_vec = [real(t_vec); imag(t_vec)];
                        basis = [real(scale_lf_volume(i,j,replace_ind)) real(scaled_seis_spectra(i,j,replace_ind)); imag(scale_lf_volume(i,j,replace_ind)) imag(scaled_seis_spectra(i,j,replace_ind))];
                        new_scale = inv(basis)*t_vec;
                        temp_lf_mergefilt(replace_ind) = new_scale(1);
                        temp_hf_mergefilt(replace_ind) = new_scale(2);
                    end
                    warning('on','all')
                    lf_mergefilt_volume(i,j,:) = temp_lf_mergefilt;
                    hf_mergefilt_volume(i,j,:) = temp_hf_mergefilt;
                end
            end
            if mod(i,20) == 0
                disp([num2str(round(i*100/length(in_ind))),'% Complete'])
            end
        end
        disp('Scaler Volumes Complete')
        
        
        
        
        
        if reps == 2 & blend_loop == 1
            blend_seis_spectra = scaled_seis_spectra.*hf_mergefilt_volume*blend;
            blend_lf_volume = scale_lf_volume.*lf_mergefilt_volume*blend;
        elseif reps == 2 & blend_loop == 2
            scaled_seis_spectra = (scaled_seis_spectra.*hf_mergefilt_volume)*(1-blend)+blend_seis_spectra;
            scale_lf_volume = (scale_lf_volume.*lf_mergefilt_volume)*(1-blend)+blend_lf_volume;
        else
            scaled_seis_spectra = scaled_seis_spectra.*hf_mergefilt_volume;
            scale_lf_volume = scale_lf_volume.*lf_mergefilt_volume;
        end
        
        if blend == 0 | blend_loop == 2
            short_dim = find(min([length(in_ind) length(cross_ind)]) == [length(in_ind) length(cross_ind)]);
            
            if short_dim == 1
                for i = 1:length(in_ind)
                    new_seis(i,:,:) = ifft_ndh(squeeze(scaled_seis_spectra(i,:,:))',f,1)';
                    new_lf(i,:,:) = ifft_ndh(squeeze(scale_lf_volume(i,:,:))',f,1)';
                end
            else
                for i = 1:length(cross_ind)
                    new_seis(:,i,:) = ifft_ndh(squeeze(scaled_seis_spectra(:,i,:))',f,1)';
                    new_lf(:,i,:) = ifft_ndh(squeeze(scale_lf_volume(:,i,:))',f,1)';
                end
            end
            Final_Product = real(new_seis+new_lf);
            
            disp('100% - Frequency/Time Conversion Complete')
        end
        
    else
        if blend == 0 
            %%%% For the case where no merge takes place
            short_dim = find(min([length(in_ind) length(cross_ind)]) == [length(in_ind) length(cross_ind)]);
                        
            if short_dim == 1
                for i = 1:length(in_ind)
                    new_seis(i,:,:) = ifft_ndh(squeeze(scaled_seis_spectra(i,:,:))',f,1)';
                end
            else
                for i = 1:length(cross_ind)
                    new_seis(:,i,:) = ifft_ndh(squeeze(scaled_seis_spectra(:,i,:))',f,1)';
                end
            end
            
            Final_Product = real(new_seis);
            
            disp('100% - Frequency/Time Conversion Complete')
        elseif blend > 0 & blend_loop == 1
            blend_spectra = scaled_seis_spectra*blend;
        elseif blend > 0 & blend_loop == 2
            scaled_seis_spectra = scaled_seis_spectra*(1-blend) + blend_spectra;
            %%%% For the case where no merge takes place
            short_dim = find(min([length(in_ind) length(cross_ind)]) == [length(in_ind) length(cross_ind)]);
            
            if short_dim == 1
                for i = 1:length(in_ind)
                    new_seis(i,:,:) = ifft_ndh(squeeze(scaled_seis_spectra(i,:,:))',f,1)';
                end
            else
                for i = 1:length(cross_ind)
                    new_seis(:,i,:) = ifft_ndh(squeeze(scaled_seis_spectra(:,i,:))',f,1)';
                end
            end
            
            Final_Product = real(new_seis);
            
            disp('100% - Frequency/Time Conversion Complete')
        end
    end
end

if merge_onoff == 1
    debug_output = {lf_scaler,scale_volume,white_spec_vol,f_merge,lf_mergefilt_volume,hf_mergefilt_volume,filt_coef};
else
    debug_output = {lf_scaler,scale_volume,white_spec_vol,f_merge,filt_coef};
end
    
    if save_flag == 1
        disp('Saving the Data')
        tic
        dv_v = Final_Product;
        date_string = date;
        save_name = ['dvv_',date_string,'_merge',num2str(merge_onoff),'shapelf',num2str(shape_lf),'_hflf',num2str(exact_shaping_hf),num2str(exact_shaping_lf),'_dc',num2str(dc_shift_correction),'_mf',num2str(merge_filter_type),'_bl',num2str(round(blend*10)),'_globallf_',num2str(global_lf_boost1),'_tshift',num2str(tshift_flag),'_Window',num2str(windowsize),'.mat'];
        save_string = ['save ',save_name,' dv_v debug_output'];
        eval(save_string)
        disp(['Save Complete - ',num2str(round(toc)),'s'])
    end
end








