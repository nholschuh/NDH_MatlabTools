function results = signal_attributes(x,t,plotter)
% (C) Nick Holschuh - Chevron Corporation - 2014 (Nick.Holschuh@gmail.com)
% Computes instantaneous attributes of a time series using properties from
% the hilbert transform.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% x - The amplitude seires
% t - The corresponding time axis (only used in plotting)
% plotter - (0) No plots (1) plots
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The output comes in a single matrix with the following columns
%
% hx - The complete, complex Hilbert Transform of the data
% inst_amp - The instantaneous amplitude
% unwrapped_phase - The unwrapped phase
% inst_phase - The instantaneoup phase
% inst_freq - The instantaneous frequency
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(x(:,1)) > 1
    x = x';
end

if exist('plotter') == 0
    plotter = 0;
end

% x is the signal; t is time vector.
% performing the HILBERT TRANSFORM
hx = hilbert(x);
% calculating the INSTANTANEOUS AMPLITUDE (ENVELOPE)
inst_amp = abs(hx);
% calculating the UNWRAPPED PHASE
unwrapped_phase = unwrap(angle(hx));
% calculating the INSTANTANEOUS PHASE
inst_phase = angle(hx);
% calculating the INSTANTANEOUS FREQUENCY
inst_freq = diff(unwrap(angle(hx)))/(2*pi);
inst_freq = [inst_freq(1) inst_freq];

if plotter == 1
    subplot(4,1,1), plot(t,x,'LineWidth',2), title('Modulated signal')
    subplot(4,1,2), plot(t,inst_amp,'LineWidth',2), title('Instantaneous amplitude')
    subplot(4,1,3), plot(t, unwrapped_phase,'LineWidth',2), title('Unrolled phase')
    subplot(4,1,4), plot(t, inst_phase,'LineWidth',2), title('Instantaneous phase')
end

results = [hx' inst_amp' unwrapped_phase' inst_phase' inst_freq'];

%-------------------- end of function -----------------------------