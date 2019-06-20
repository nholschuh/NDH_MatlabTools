function [true_midpoint_z true_p true_L transmit_angle reflect_angle true_time] = focusing_raytracing(srcz,offsets,travel_time,surf_rho,timerflag)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Performs a ray tracing algorithm for vertically layered, radially
% isotropic medium, and computes the reflector depths, ray parameters, and
% transmission and reflection angles for a set of source/receiver offsets.
% The velocity profile is derived from Herron and Langway densification,
% given a surface density.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% srcz - (the source depth relative to the surface [- for airborne])
% offsets - The receiver offset distances (in m)
% travel_time -  The travel_time axis that you want to duplicate
% surf_rho - surface density (in g/cc), if 0 is provided, the velocities
%   through the entire column are set to the ice velocity (ie no refrac)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows
%
% true_midpoint_z - depth to a target imaged given the travel time and
%                   position information
% true_p - the ray parameter for the given target
% true_L - this value, when divided from the return power (or
%       subtracted, in dB) corrects the data for spherical spreading
% transmit_angle - the outgoing angle for the ray from the radar
% reflect_angle - the incidence angle for the ray as it approaches the
%                 reflector
% true_time - for comparison with the original travel time
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% debug = 1;
% if debug == 1
%     clear all
%     srcz = 0;
%     offsets = 0:100:1200;
%     travel_time = 0:1e-8:1e-5;
%     surf_rho = 0.45;
% end

%%%%%%%%%%%%%%%%%% PreSet some Accumulation and Temperature for different
%%%%%%%%%%%%%%%%%% regions
if 0 %% Crary Ice Rise
    A = 0.1;
    T = -2+273.5;    
elseif 1
    A = 0.3;
    T = -5+273.5;
end
    

if exist('timerflag') == 0
    timerflag = 0;
end

    cair_import;
    cice_import;
    tic

%%%%%% This code makes an initial guess at the depth to the target, and
%%%%%% models the travel time for reflectors off of the initial guessed
%%%%%% depths. It then interpolates the depths back to the original travel
%%%%%% times, using the true travel times from the model. This step decides
%%%%%% how many depths to guess at.
if length(travel_time) > 1000
    tt_downsample = 5;
elseif length(travel_time) > 100
    tt_downsample = 1;
elseif length(travel_time) > 10
    tt_downsample = 0.5;
else
    tt_downsample = 0.05;
end

max_depth = max(travel_time - srcz*2/cair)*cice/2+50;
zd = linspace(1,max_depth,round(length(travel_time)/tt_downsample));

%%%%%% Generate the velocity fields
domain_z = round(srcz - 50):1:round(max_depth+40);
    % Firn Density from Herron and Langway
    rho_p = firn_density(domain_z+1,surf_rho,A,T);

    % Velocity from density - Robin 1975
    domain_V = cair./(1+0.851*rho_p);
    domain_V(find(domain_z < 0)) = cair;
    domain_V(find(abs(domain_V - cice) <= 5e5)) = cice;
    
    if surf_rho == 0
        domain_V(:) = cice;
        domain_V(find(domain_z < 0)) = cair;
    elseif surf_rho == -1
        domain_V(:) = cice;
        domain_V(find(domain_z < 0)) = cice;
    end
disp(['Step 1 - Initialize the Domain: ',num2str(round(toc)),'s'])
disp(['Step 2 - Begin Ray Tracing:'])
    
%%%%%% Perform the ray tracing
for i = 1:length(zd)
    
    [t_temp,p_temp,L_temp,raycoord]=traceray_pp(domain_V,domain_z,srcz,srcz,zd(i),offsets,10,-1,20,1,0,0);
    
    
    t_final(i,:) = t_temp;
    p_final(i,:) = p_temp;
    %%%%% This is the radial spredding term, and comes out of two
    %%%%% functions:
    %%%%%
    %%%%% traceray_pp
    %%%%% sphdiv
    
    L_final(i,:) = 1./(4*pi*(L_temp).^2); %%% Convert to effective spherical radius
    
    if mod(i,ceil(length(zd)/10)) == 0 & timerflag == 1
        disp(['        Completed ',num2str(round(i/length(zd)*100)),'% - ',num2str(round(toc)),'s'])
    end
end


%%%%%% Interpolate back to travel_time;
for i = 1:length(offsets)  
    %%%% Can only interpolate for points without infinite travel time
    interp_inds = find(t_final(:,i) ~= Inf);
    %%%% find midpointz for travel times as a function of offset
    true_midpoint_z(:,i) = interp1(t_final(interp_inds,i),zd(interp_inds),travel_time);
    true_p(:,i) = interp1(t_final(interp_inds,i),p_final(interp_inds,i),travel_time);
    true_L(:,i) = interp1(t_final(interp_inds,i),L_final(interp_inds,i),travel_time);
    true_time(:,i) = interp1(t_final(interp_inds,i),t_final(interp_inds,i),travel_time);
end
disp(['Step 3 - Performed the Interpolations: ',num2str(round(toc)),'s'])


transmit_angle = ones(size(true_L))*NaN;
reflect_angle = ones(size(true_L))*NaN;

%%%%%% Compute the Transmit and Reflection angles from the Ray Parameter
for i = 1:length(offsets)
    search_inds = find(isnan(true_p(:,i)) ~= 1);
    transmit_angle(search_inds,i) = rad2deg(asin(true_p(search_inds,i).*domain_V(find_nearest(domain_z,srcz))));
    reflect_angle(search_inds,i) = rad2deg(asin(true_p(search_inds,i).*domain_V(round(true_midpoint_z(search_inds,i))+round(abs(min(domain_z))))'));
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%% Gut Check to make sure this is doing things correctly
%     test_ind = 5;
%     subplot(1,3,1)
%     plot(t_final(:,test_ind)*10^6,zd(:,test_ind),':','Color','black','LineWidth',4)
%     hold all
%     plot(travel_time*10^6,true_midpoint_z(:,test_ind),'Color','red','LineWidth',1)
%     xlabel('Two Way Travel Time (\muS)')
%     ylabel('Midpoint Depth (m)')
% 
%     subplot(1,3,2)
%     plot(t_final(:,test_ind)*10^6,p_final(:,test_ind),':','Color','black','LineWidth',4)
%     hold all
%     plot(travel_time*10^6,true_p(:,test_ind),'Color','red','LineWidth',1)
%     xlabel('Two Way Travel Time (\muS)')
%     ylabel('Midpoint Depth (m)')
%     
%     subplot(1,3,3)
%     plot(t_final(:,test_ind)*10^6,L_final(:,test_ind),':','Color','black','LineWidth',4)
%     hold all
%     plot(travel_time*10^6,true_L(:,test_ind),'Color','red','LineWidth',1)
%     xlabel('Two Way Travel Time (\muS)')
%     ylabel('Midpoint Depth (m)')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end



    


    