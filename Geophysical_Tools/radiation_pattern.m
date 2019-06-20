function db_correction = radiation_pattern(theta,phi,permittivity,extra_plotting);
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This function computes the antenna gain value given the angle from nadir
% perpendicular to the dipole antenna (theta) and the angle out
% from the antenna array in the plane of the surface (phi). The E plane (which
% contains the antenna and the transmission direction) has phi = 0, while
% the H plane (perpendicular to the antennae) has phi = pi/2.
% These equations are taken from Engheta1982, pp. 1563
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% theta - the angle from nadir perpendicular to the dipole antenna (rad)
% phi - the angle out from the antenna array in the plane of the surface (rad)
% permittivity - Value for the dielectric permittivity of the lower half
%               space. If 0, or if omitted, the permittivity of ice (3.1543)
%               is used
% extra_plotting - 1 for the E and H planes plotted, with the chosen
%                  corrections marked
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The output are:
% db_correction = column 1 - theta (radians)
%                 column 2 - phi (radians)
%                 column 3 - 10*log10 of the gain (dB)
%                 column 4 - gain relative to nadir (dB)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if exist('phi') == 0
    phi = ones(size(theta))*pi;
end

if length(phi) ~= length(theta)
    if length(phi) == 1 & length(theta) > 1
        phi = ones(size(theta))*phi;
    elseif length(phi) > 1 & length(theta) == 1
        theta = ones(size(phi))*theta;
    else
        error('Theta and Phi vectors must be equal in length');
    end
end


if max(abs(theta)) > 2*pi
    theta = pi-deg2rad(theta);
else
    theta = pi-theta;
end

if length(phi) == 1
    phi = ones(size(theta))*phi;
end

cice_import;
cair_import;

if exist('permittivity') == 0
    n = cair/cice;
elseif permittivity == 0
    n = cair/cice;
else
    n = sqrt(permittivity);
end

% Define the values at Nadir for comparison
phi(end+1) = 0;
theta(end+1) = 0;
theta_c = asin(1/n);
efield0_or_poynting1 = 1;


for i = 1:length(phi)
    
    E(i,1) = theta(i);
    E(i,2) = phi(i);
    
    if efield0_or_poynting1 == 0
        %%%%%%%%%%%%%%%%%% Equations that explain the electric field
        if theta(i) < pi/2 | theta(i) >= 3*pi/2
            E(i,3) = ((cos(theta(i))^2/ ...
                (cos(theta(i))+(n^2-sin(theta(i))^2)^0.5) - ...
                sin(theta(i))^2*cos(theta(i))*(cos(theta(i)) - (n^2 - sin(theta(i))^2)^0.5)/ ...
                (n^2*cos(theta(i))+(n^2-sin(theta(i))^2)^(0.5)))^2 * cos(phi(i))^2 + ...
                (cos(theta(i))^2*sin(phi(i))^2)/ ...
                (cos(theta(i)) + (n^2 - sin(theta(i))^2)^(0.5))^2);
            
        elseif (theta(i) > pi/2 & theta(i) <= pi-theta_c) | (theta(i) >= pi+theta_c & theta(i) < 3*pi/2)
            E(i,3) = ( ...
                ((n^2-1)*sin(theta(i))^4*cos(theta(i))^2*cos(phi(i))^2 - 2*cos(phi(i))^2*sin(theta(i))^2*cos(theta(i))^4)/ ...
                (n^2*(n^2*sin(theta(i))^2 - 1) + cos(theta(i))^2) + ...
                (cos(theta(i))^4*cos(phi(i))^2 + sin(phi(i))^2*cos(theta(i))^2)/(n^2 - 1));
        else
            E(i,3) = ((sin(theta(i))^2*cos(theta(i))*((1-n^2*sin(theta(i))^2)^0.5 + n*cos(theta(i)))/ ...
                (n*(1-n^2*sin(theta(i))^2)^0.5 - cos(theta(i))) - ...          %
                cos(theta(i))^2/((1-n^2*sin(theta(i))^2)^0.5 - n*cos(theta(i))))^2*cos(phi(i))^2 + ...
                (cos(theta(i))^2*sin(phi(i))^2)/((1-n^2*sin(theta(i))^2)^0.5 - n*cos(theta(i)))^2);
            
        end
        
        %%%%%%%%%%%%%%%%%%%% Equations that explain the Poynting Vector
    elseif efield0_or_poynting1 == 1;
        %%% Equation 73
        if theta(i) < pi/2 | theta(i) >= pi/2
            E(i,3) = (cos(theta(i))^2/(cos(theta(i))+sqrt(n^2-sin(theta(i))^2)) - ...
                sin(theta(i))^2*cos(theta(i))*(cos(theta(i))-sqrt(n^2-sin(theta(i))^2))/(n^2*cos(theta(i))+sqrt(n^2-sin(theta(i))^2)))^2*cos(phi(i)^2);
            
            %%% Equation 74
        elseif (theta(i) > pi-theta_c & theta(i) < pi+theta_c)
            E(i,3) = ((sin(theta(i))^2*cos(theta(i)) * ...
                (sqrt(1-n^2*sin(theta(i))^2)+n*cos(theta(i)))/(n*sqrt(1-n^2*sin(theta(i))^2) - cos(theta(i))) - ...
                (cos(theta(i))^2)./(sqrt(1-n^2*sin(theta(i))^2) - n*cos(theta(i))))^2*cos(phi(i))^2 + ...
                (cos(theta(i))^2*sin(phi(i))^2)/((sqrt(1-n^2*sin(theta(i))^2)-n*cos(theta(i))))^2);
            %%% Equation 75
        elseif (theta(i) > pi/2 & theta(i) < pi-theta_c) | (theta(i) >= pi+theta_c & theta(i) < 3*pi/2)
            E(i,3) = (((n^2-1)*sin(theta(i))^4*cos(theta(i))^2*cos(phi(i))^2 - 2*cos(phi(i))^2*sin(theta(i))^2*cos(theta(i))^4)/ ...
                (n^2*(n^2*sin(theta(i))^2 - 1) + cos(theta(i))^2) + ...
                (cos(theta(i))^4*cos(phi(i))^2 + sin(phi(i))^2*cos(theta(i))^2)/(n^2-1));
        end
    end
    
end

db_correction = [10*log10(E(1:end-1,3)) 10*log10(E(end,3))-10*log10(E(1:end-1,3))];
db_correction = [E(1:end-1,1:2) db_correction];



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This section is for plotting the results on the overall radiation
%   pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('extra_plotting') == 0
    extra_plotting = 0;
end
if extra_plotting > 0    %% This section tests the equations, and plots the H and E planes
    
    
    ds = 0.02;
    theta_options = 0:ds:2*pi;
    phi_options = -pi/2:ds:pi/2;
    num = length(phi_options);
    
    theta_c = asin(1/n);
    
    
    for i = 1:length(theta_options)
        for j = 1:length(phi_options)
            
            theta = theta_options(i);
            phi = phi_options(j);
            
            E2((i-1)*num+j,1) = theta;
            E2((i-1)*num+j,2) = phi;
            
            if efield0_or_poynting1 == 0
                if theta < pi/2 | theta > 3*pi/2 %%% The air case
                    E2((i-1)*num+j,3) = ((cos(theta)^2/ ...
                        (cos(theta)+(n^2-sin(theta)^2)^0.5) - ...
                        sin(theta)^2*cos(theta)*(cos(theta) - (n^2 - sin(theta)^2)^0.5)/ ...
                        (n^2*cos(theta)+(n^2-sin(theta)^2)^(0.5)))^2 * cos(phi)^2 + ...
                        (cos(theta)^2*sin(phi)^2)/ ...
                        (cos(theta) + (n^2 - sin(theta)^2)^(0.5))^2);
                    
                elseif (theta > pi/2 & theta < pi-theta_c) | (theta > pi+theta_c & theta < 3*pi/2)
                    E2((i-1)*num+j,3) = ( ...
                        ((n^2-1)*sin(theta)^4*cos(theta)^2*cos(phi)^2 - 2*cos(phi)^2*sin(theta)^2*cos(theta)^4)/ ...
                        (n^2*(n^2*sin(theta)^2 - 1) + cos(theta)^2) + ...
                        (cos(theta)^4*cos(phi)^2 + sin(phi)^2*cos(theta)^2)/(n^2 - 1));
                    
                else
                    E2((i-1)*num+j,3) = ((sin(theta)^2*cos(theta)*((1-n^2*sin(theta)^2)^0.5 + n*cos(theta))/ ...
                        (n*(1-n^2*sin(theta)^2)^0.5 - cos(theta)) - ...
                        cos(theta)^2/((1-n^2*sin(theta)^2)^0.5 - n*cos(theta)))^2*cos(phi)^2 + ...
                        (cos(theta)^2*sin(phi)^2)/((1-n^2*sin(theta)^2)^0.5 - n*cos(theta))^2);
                    
                end
            elseif efield0_or_poynting1 == 1
                %%%%%%%%%%%%%%%%%%%% Equations that explain the Poynting Vector
                
                %%% Equation 73
                if theta < pi/2 | theta >= 3*pi/2
                    E2((i-1)*num+j,3) = (cos(theta)^2/(cos(theta)+sqrt(n^2-sin(theta)^2)) - ...
                        sin(theta)^2*cos(theta)*(cos(theta)-sqrt(n^2-sin(theta)^2))/(n^2*cos(theta)+sqrt(n^2-sin(theta)^2)))^2*cos(phi^2);
                    
                    %%% Equation 74
                elseif (theta > pi-theta_c & theta < pi+theta_c)
                    E2((i-1)*num+j,3) = ((sin(theta)^2*cos(theta) * ...
                        (sqrt(1-n^2*sin(theta)^2)+n*cos(theta))/(n*sqrt(1-n^2*sin(theta)^2) - cos(theta)) - ...
                        (cos(theta)^2)./(sqrt(1-n^2*sin(theta)^2) - n*cos(theta)))^2*cos(phi)^2 + ...
                        (cos(theta)^2*sin(phi)^2)/((sqrt(1-n^2*sin(theta)^2)-n*cos(theta)))^2);
                    %%% Equation 75
                elseif (theta > pi/2 & theta < pi-theta_c) | (theta >= pi+theta_c & theta < 3*pi/2)
                    E2((i-1)*num+j,3) = (((n^2-1)*sin(theta)^4*cos(theta)^2*cos(phi)^2 - 2*cos(phi)^2*sin(theta)^2*cos(theta)^4)/ ...
                        (n^2*(n^2*sin(theta)^2 - 1) + cos(theta)^2) + ...
                        (cos(theta)^4*cos(phi)^2 + sin(phi)^2*cos(theta)^2)/(n^2-1));
                end
                
                
            end
        end
    end
        
            E2(find(abs(E2(:,3)) < .001),3) = 0.001;
            E2(find(imag(E2(:,3)) > 0),3) = abs(E2(find(imag(E2(:,3)) > 0),3)).*sign(real(E2(find(imag(E2(:,3)) > 0),3)));
        
        if extra_plotting == 1
            
            %% Plot the E plane
            
            temp1 = E2(find_nearest(E2(:,2),pi/2),2);
            temp1_indecies = find(E2(:,2) == temp1);
            H_plane = E2(temp1_indecies,[1 3]);
            
            
            temp2 = E2(find_nearest(E2(:,2),0),2);
            temp2_indecies = find(E2(:,2) == temp2);
            E_plane = E2(temp2_indecies,[1 3]);
            E_plane_info = E2(temp2_indecies,[2]);
            
            
            plot_index_E = find(db_correction(:,2) == 0);
            plot_index_H = find(db_correction(:,2) == pi/2 | db_correction(:,2) == -pi/2);
            
            
            
            subplot(1,2,1)
            polar(E_plane(:,1),10*log10(E_plane(:,2))+30)
            hold all
            if length(plot_index_E) > 0
                polar(db_correction(plot_index_E,1),db_correction(plot_index_E,3)+30,'o')
            end
            view([-90 0 180]);
            subplot(1,2,2)
            
            
            polar(H_plane(:,1),10*log10(H_plane(:,2))+30)
            hold all
            if length(plot_index_H) > 0
                polar(db_correction(plot_index_H,1),db_correction(plot_index_H,3)+30,'o')
            end
            view([-90 0 180]);

            
        elseif extra_plotting == 2
            %%% Plot the results in 3D space
            [x y z] = sph2cart(E2(:,1),E2(:,2),10*log10(E2(:,3))+30);
            
            plot3(x,y,z,'.')
            xlim([-30 30])
            ylim([-30 30])
            zlim([-30 30])
            ylabel('YAxis')
            xlabel('XAxis')
            zlabel('ZAxis')
        end

    
    
    
end


