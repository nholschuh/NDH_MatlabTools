%%% This code creates the variables that define the electric properties of a
%%% domain used for finite difference modeling. Characteristic values can
%%% be found below:
check = 1;

% % % % % % % freq=3e6;% center frequency of radio wave in Hz
% % % % % % % angle_incident= 0;
% % % % % % % speed_light= 2.998e8;% speed of light in m/s
% % % % % % % 
% % % % % % % permitt_free=8.854e-12; % permittivity of free space
% % % % % % % permitt_ice=3.2;% permittivity of polar ice at radio frequences (dimensionless)
% % % % % % % permitt_water=79.7;%permittivity of water at radio frequencies (ellison et al. (1998), radio sci.
% % % % % % % permitt_gwtill=18;%table 1 of anandakrishnan et al. (2007)
% % % % % % % permitt_sand=6.6;%table 1 of peters et al. (2005)
% % % % % % % permitt_fwtill=30;%table 1 of anandakrishnan et al. (2007)
% % % % % % % 
% % % % % % % sat = 1:100;
% % % % % % % permitt_tills = sat*((87-permitt_sand)/100) + permitt_sand;
% % % % % % % conduct_tills = 0.01*2*pi*freq*permitt_free*permitt_tills;
% % % % % % % 
% % % % % % % conduct_ice=70e-6;%from isbgl_atten_work at bottom of ice
% % % % % % % conduct_seawater=2.7;%crc handbook; ellison et al. (1998), radio sci.
% % % % % % % conduct_freshwater=1e-6;%crc handbook
% % % % % % % conduct_icewater=1e-4;%minimum conductivity of melted meteoric ice from rothlisberger et al., 2000, environ. sci tech.
% % % % % % % conduct_gwtill=0.82*2*pi*freq*permitt_free*permitt_gwtill;%table 1 of anandakrishnan et al. (2007)
% % % % % % % conduct_fwtill=0.01*2*pi*freq*permitt_free*permitt_fwtill;%table 1 of anandakrishnan et al. (2007)
% % % % % % % conduct_fwtill_max=0.1*2*pi*freq*permitt_free*permitt_fwtill;%table 1 of anandakrishnan et al. (2007)
% % % % % % % conduct_sand=0.015*2*pi*freq*permitt_free*permitt_sand;%table 1 of peters et al. (2005)

xaxis = -660:660;
zaxis = -10:2710;
ep = ones(length(xaxis),length(zaxis));
mu = ones(length(xaxis),length(zaxis));
sig = zeros(length(xaxis),length(zaxis));


%%%%% This is the relative permittivity term. Remember, for radar waves,
%%%%% this represents 
ep(:,find(zaxis>0 & zaxis < 2700)) = 3.2;
ep(:,find(zaxis>=2700)) = 6;

% put in mildly reflective layers every 100m

counter = 1;
for i = 100:100:2600;
    ind(counter) = find_nearest(zaxis,i);
    ep(:,ind(counter)-1:ind(counter)+1) = 3.5;
    counter = counter+1;
end



%%%%% This is the relative magnetic permeability of the materials. This can
%%%%% typically be assumed to be equal to the freespace value, whic means
%%%%% relative value == 1;
mu = mu;


%%%%% This is the electrical conductivity in simons.
sig(:,find(zaxis<0)) = 0;
sig(:,find(zaxis>0 & zaxis < 2700)) = 1e-6;
sig(:,find(zaxis>=2700)) = 1e-5;

if check == 1
    subplot(3,1,1)
    imagesc(xaxis,zaxis,ep')
    caxis([3.1 3.6])
    subplot(3,1,2)
    imagesc(xaxis,zaxis,mu')
    subplot(3,1,3)
    imagesc(xaxis,zaxis,sig')
end