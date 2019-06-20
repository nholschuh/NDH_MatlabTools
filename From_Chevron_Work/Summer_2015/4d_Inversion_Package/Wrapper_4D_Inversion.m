%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Wrapper for the Entire Algorithm                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Read in the segy files for processing
%%% data1 - Time Strains (Low Frequency Volume)
%%% data2 - Amplitude Differences
%%% data3 - The Ideal Product (only used for plotting comparison)
%%% data4 - Time Shifts (optional)

clear all

tic;
mobim = 1;
w_tshifts = 1;
if mobim == 1
    prefix = 'Mobim_';
    [data1 header1] = ReadSegy('./Mobim_DVV/tstrain_amp.segy');
    disp(['Read Volume 1 - ',num2str(toc),'s'])
    [data2 header2] = ReadSegy('./Mobim_DVV/Quad_Diff.segy');
    disp(['Read Volume 2 - ',num2str(toc),'s'])
    [data3 header3] = ReadSegy('./Mobim_DVV/dvv.segy');
    disp(['Read Volume 3 - ',num2str(toc),'s'])
    if w_tshifts == 1
        [data4 header4] = ReadSegy('./Mobim_DVV/tshift_amp.segy');
        disp(['Read Volume 4 - ',num2str(toc),'s'])
    end       
elseif mobim == 2
    prefix = 'Mobim_';
    [data1 header1] = ReadSegy('./tstrain_amp.segy');
    disp(['Read Volume 1 - ',num2str(toc),'s'])
    %[data2 header2] = ReadSegy('./Mobim_DVV/Quad_Diff.segy');
    [data2 header2] = ReadSegy('./ampdiff_amp.segy');
    disp(['Read Volume 2 - ',num2str(toc),'s'])
    [data3 header3] = ReadSegy('./dvv.segy');
    disp(['Read Volume 3 - ',num2str(toc),'s'])
    if w_tshifts == 1
        [data4 header4] = ReadSegy('./tshift_amp.segy');
        disp(['Read Volume 4 - ',num2str(toc),'s'])
    end
end
%%%
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Perform the spatial averaging and fourier transforms
%%%

window = 20;
        
        
[volumes1 volumes1_meta] = TraceAveraging_3D(data1,header1,window);
[volumes2 volumes2_meta] = TraceAveraging_3D(data2,header2,window);
[volumes3 volumes3_meta] = TraceAveraging_3D(data3,header3,window);
if w_tshifts == 1
    [volumes4 volumes4_meta] = TraceAveraging_3D(data4,header4,window);
end

%%%
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The Shaping and Merge is performed
%%%

merge_and_shape = 0;
% 0 = Apply Spectral Shaping
% 1 = Apply Spectral Shaping and perform LF merge
save_flag = 1;

if w_tshifts == 1
    dV_V = ColoredInversion_4D(volumes2,volumes1,merge_and_shape,[0 0],save_flag,volumes3);
else
    [dV_V plotting_output] = ColoredInversion_4D(volumes2,volumes1,merge_and_shape,[0 0],save_flag);
end
%%%
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The product of the shaping and merge is read into a comparison
%%% UI for immediate quality control

dvv_filt_flag = 0;
% If you have an ideal comparison  volume to include, set to (1), otherwise (0)

if dvv_filt_flag == 0
    close all
    Shaping_4D_ResultsEvaluation(dV_V,volumes2,volumes3)
else
    close all
    Shaping_4D_ResultsEvaluation(dV_V_filt,volumes2,volumes3)
end
%%%
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Write out the final product as .Segy

Write_dV_V_Volume(volumes1,dV_V,header1,merge_and_shape,prefix);
