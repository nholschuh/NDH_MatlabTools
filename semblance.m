function [sem,amp,nmo]=semblance(varargin)
% -------------------------------------------------------------------------
% SEMBLANCE
% -------------------------------------------------------------------------
% SYNTAX:
% [sem]=semblance(traces,t0,x,v_nmo)
% [sem]=semblance(traces,t0,x,v_nmo,timegate)
% [sem,amp]=semblance(...)
% [sem,amp,nmo]=semblance(...)
%
% DESCRIPTION:
% Calculates semblance of a CMP gather. The script calculates 
% cross-correlation (that is the coherence between two datasets) between
% the CMP gather and teoretical hyperbolas at the given NMO velocities.
% A high coherence at a specific NMO velocity and travel time indicate that
% the data in the CMP gather concur with the teoretical hyperbolas at that
% perticular velocity and thus is a indication of the velocity in the
% medium.    
% 
% INPUT:
% x         Vector with offset between transmitter and receiver. It must
%           start at zero offset. 
% t0        Vector with zero offset traveltimes 
% traces    An (t0,x) array with the amplitude values for the CMP gather
% v_nmo     Vector with NMO velcoities at which the analyis should be done.
% timegate  Value for time gate window over which the coherence is
%           calculated. Given in number of samples. If no timegate is
%           supplied a default value of 41 is used.
%
% OUTPUT:
% nmo       Array of size length(t0) by length(x) by length(v_nmo). The
%           array contains the NMO corrected CMP gathers for each
%           specified NMO velocity (i.e. along the third dimension of the
%           array).  
% amp       Array of length(t0) by length(v_nmo) containing amplitude sum
%           along NMO corrected CMP gather.
% sem       Array of length(t0) by length(v_nmo) containing semblance
%           values (0-1) along NMO corrected CMP gather. 
% t0        Time axis at zero offset          
%
% REMARKS:
% Semblance analysis requires horizontal layering for the reflecting
% objects and that small-spread approximation applies. Small-spread
% approximation is fullfilled when the offset is small compared to depth to
% reflectors.
% If the CMP gather do not start at zero offset semblance fills the traces
% array with zeros for the missing offsets. 
%
% VERSION: 1.0
%
% AUTHOR:
% K. Christianson, Jun 2013
%
% REVISION HISTORY:
% 
%
% COMPABILITY:
% MATLAB R2011a
%
% DEPENDENCIES:
%
% SUBROUTINES:
%
% REFERENCES:
% Sheriff, R. E. and Geldhart, L.P., 1995. Exploration seismology.
% Cambridge University press.
% Yilmaz, Ö., 1987. Seismic data processing. Investigations in geophysics,
% Vol.2, Soceity of exploration geophysisists. 
% -------------------------------------------------------------------------

% Check input number of arguments
error(nargchk(4,5,nargin));

% Get input arguments sorted via cell array
traces=varargin{1};
t=varargin{2};
x=varargin{3};
v_nmo=varargin{4};

% Check for timegate input
if nargin>4
    timegate=varargin{5};
else
    timegate=81;
end
   
% Make sure that the time gate (in number of samples) is an odd value
bool=mod(timegate,2);
if ~bool
    error('The time gate must be an odd value');
end

% Calculates the number of samples on each side of center sample in time in
% the time gate
gate=(timegate-1)/2;

% Initalize some arrays to store coherency data
sem=zeros(length(t),length(v_nmo));
amp=zeros(length(t),length(v_nmo));
nmo=zeros(length(t),length(x));

% loops over every NMO velocity
for n=1:length(v_nmo)
    
    % Normal moveout correction of the CMP at the current medium velocity
    nmo(:,:,n)=nmo_ndh(traces,t,x,ones(length(traces),1)*v_nmo(n));
    
    % Calculates the coherency measures over the defined time gate
    for k=(gate+1):(length(t)-gate-1)
        % Average amplitude over timewindow of 'gate' samples length.
        % (Sheriff & Geldart (1995) eq. 9.56)
        amp(k,n)=sum(abs(sum(nmo((k-gate):(k+gate),:,n),2)))/(2*gate+1);
        
        % Calculate the semblance for this NMO velocity over timewindows of
        % 'gate' samples length.
        % (Sheriff & Geldart (1995) eq. 9.59)
        sem(k,n)=(sum(sum(nmo((k-gate):(k+gate),:,n),2).^2)./...
            sum(sum(nmo((k-gate):(k+gate),:,n).^2,2))).*...
            1/(length(x));
    end
end

