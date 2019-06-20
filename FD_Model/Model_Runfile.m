srcloc = [25,0];
recloc = [25,0];
savename = 'Position_0006_Model_Output';
prefix = 'Position_0006';
%%% Load in the material properties of the system used for modeling
%load reflection_model.mat
close all
addpath(genpath('/gpfs/scratch/ndh147/NDH_Tools/'))
savename = 'FD_Model_Output_NoFocusing';
Forward_Domain
x = xaxis;
z = zaxis;

runner = 1; % Parameter choice for if you want the final model to run

check = 0;
if check == 1
    subplot(3,1,1)
    imagesc(x,z,ep')
    subplot(3,1,2)
    imagesc(x,z,mu')
    subplot(3,1,3)
    imagesc(x,z,sig')
end

%%% Produce the proper source pulse, using a given frequency and duration.
%%% Pulse length should be the desired end record length.
pulse_freq = 3e6;
tend = 35e-6;

pt = 0:1e-10:tend;
pa = blackharrispulse(pulse_freq,pt);

check = 0;
if check == 1
    plot(pt,pa)
end

%%% Using the electric properties and the pulse, compute the necessary dx
%%% to control for numerical dispersion.

[dxmax wlmin fmax] = finddx(max(max(ep)),max(max(mu)),pa,pt);

%%% Using the electrical properties and the computed maximum dx, compute
%%% the minimum possible timeste for numerical stability.

dtmax = finddt(min(min(ep)),min(min(mu)),dxmax,dxmax);
dtmax_order = order(dtmax);
dt = floor(dtmax/(1*10^(dtmax_order)))*10^(dtmax_order);

%%% Reproduce the source pulse with the new dt.

pt = 0:dt:tend;
pa = blackharrispulse(pulse_freq,pt);

%%% Interpolates the electrical grids if necessary, based on the minimum
%%% necessary dx.

dxmax = dxmax/2;
ndx_order = order(dxmax/2);
ndx = floor(dxmax/(1*10^(ndx_order)))*10^(ndx_order);

x2 = min(x):ndx:max(x);
z2 = min(z):ndx:max(z);

if mod(length(x2),2) == 0
    x2 = x2(1:end-1);
end
if mod(length(z2),2) == 0
    z2 = z2(1:end-1);
end

ep = gridinterp(ep,x,z,x2,z2);
mu = gridinterp(mu,x,z,x2,z2);
sig = gridinterp(sig,x,z,x2,z2);
    


%%% Add the necessary absorption boundary conditions to the edge of the
%%% domain
padding = 20;

ep = padgrid(ep,x2,z2,padding);
mu = padgrid(mu,x2,z2,padding);
[sig x2 z2] = padgrid(sig,x2,z2,padding);

%%% Define the source and receiver positions


%%% Actually run the finite difference code
if runner == 1;
    [gather tout srcx srcz recx recz] = TM_model2d(ep,mu,sig,x2,z2,srcloc,recloc,pa,pt,padding,1,[3 50 0.01]);
end

save(savename,'gather tout srcx srcz recx recz')











