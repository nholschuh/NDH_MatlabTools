function [sr sr_meta] = strainrate_calculator(x_axis,y_axis,u,v,strain_selections);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% This calculates the maximum longitudinal strain ("along flow"), the
% minimum longitudinal strain ("across flow"), and the maximum shear, using
% properties of the eigenvectors and eigenvalues of DV tensor. This
% solution is presented in (Hackl et al. 2009), although it is foundational
% theory in continuum mechanics.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% x_axis - The xaxis values that are associated with the velocity grids
% y_axis - The yaxis values that are associated with the velocity grids
% u - The velocity component in the orientation of the x axis
% v - The velocity component in the orientation of the y axis
% strain_selections - This input allows you to select which of the output
%   products you would like to retain. It should be a matrix with 0s and 1s
%   in the following positions, to indicate which values you are most
%   interested in.
%%%%%%%
% 1 - Max Longitudinal Strain Rate
% 2 - Min Longitudinal Strain Rate
% 3 - Max Shear Strain Rate
% 4 - Max Longitudinal Orientation
% 5 - Min Longitudinal Orientation
% 6 - Rotation Matrix
% 7 - Vertical Strain Rate (assuming incompressibility)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Output is as follows:
% sr - a Cell array, containing 6 entries.
% 1 - The principle longitudinal strain rate (scaler)
% 2 - The secondary longitudinal strian rate (scaler)
% 3 - The maximum shear strain rate (scaler)
% 4 - The orientation of maximum longitudinal strain (vector)
% 5 - The orientation of minimum longitudinal strain (vector)
% 6 - The rotation matrix (matrix, with positions corresponding to:
%        [  1   2;
%           3   4  ]
% 7 - The vertical strain rate value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%% First, fill the strain_selections matrix to the correct size
while length(strain_selections) < 7
    strain_selections = [strain_selections 0];
end

% Initialize the principle eigenvector matrix (1), if desired
if strain_selections(1) == 1
    e1 = zeros([size(u) 1]);
else e1 = 0;
end
% Initialize the principle eigenvector matrix (2), if desired
if strain_selections(2) == 1
    e2 = zeros([size(u) 1]);
else e2 = 0;
end
% Initialize the principle eigenvector matrix (3), if desired
if strain_selections(3) == 1
    ss = zeros([size(u) 1]);
else ss = 0;
end
% Initialize the principle eigenvector matrix (4), if desired
if strain_selections(4) == 1
    ev1 = zeros([size(u) 2]);
else ev1 = 0;
end
% Initialize the secondary eigenvector matrix (5), if desired
if strain_selections(5) == 1
    ev2 = zeros([size(u) 2]);
else ev2 = 0;
end
% Initialize the rotation matrix (6), if desired
if strain_selections(6) == 1
    rm = zeros([size(u) 4]);
else rm = 0;
end
% Initialize the vertical strain rate matrix (7), if desired
if strain_selections(7) == 1
    vs = zeros([size(u) 1]);
else vs = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization Complete

% Generate the change in velocity components
[du_x du_y] = gradient(u);
[dv_x dv_y] = gradient(v);

dx = x_axis(2)-x_axis(1);
dy = y_axis(2)-y_axis(1);

dudx = du_x/dx;
dudy = du_y/dy;
dvdx = dv_x/dx;
dvdy = dv_y/dy;


% Fill in the components of the strain rate tensor
shear1 = 0.5*(dudy+dvdx);

rotation1 = 0.5*(dudy-dvdx);
rotation2 = 0.5*(dvdx-dudy);

zeromat = zeros(size(shear1));


for i = 1:length(zeromat(:,1))
    for j = 1:length(zeromat(1,:))
        %%%%% Either collects the eigen vector information
        if strain_selections(4) == 1 | strain_selections(5) == 1
            [e_val e_vec] = eig([dudx(i,j) 0.5*(dudy(i,j)+dvdx(i,j)); ...
                    0.5*(dudy(i,j)+dvdx(i,j)) dvdy(i,j)]);
             e_val = diag(e_val);
        %%%%% or never bothers...
        else
            [e_val] = eig([dudx(i,j) 0.5*(dudy(i,j)+dvdx(i,j)); ...
                    0.5*(dudy(i,j)+dvdx(i,j)) dvdy(i,j)]);
        end
           
        % Store the maximum Longitudinal Strain
        if strain_selections(1) == 1
            e1(i,j) = e_val(1);
        end
        % Store the minimum Longitudinal Strain
        if strain_selections(2) == 1
            e2(i,j) = e_val(2);
        end
        % Store the maximum Shear Stress
        if strain_selections(3) == 1
            ss(i,j) = (max(e_val)-min(e_val))/2;
        end
        % Store the orientation of maximum longitudinal strain (first
        % eigenvector)
        if strain_selections(4) == 1
            ev1(i,j,:) = e_vec(:,1);
        end
        % Store the orientation of maximum longitudinal strain (second
        % eigenvector)
        if strain_selections(5) == 1
            ev1(i,j,:) = e_vec(:,2);
        end
        % Store the rotation matrix
        if strain_selections(6) == 1
            rm(i,j,:) = [0 rotation1(i,j) rotation2(i,j) 0];
        end
        % Compute and store the vertical strain rate values
        if strain_selections(7) == 1
            vs(i,j) = -e_val(1)-e_val(2);
        end       
        
    end
end


debug_flag = 0;
if debug_flag == 1
    test_vs = -dudx-dudy;
    imagesc(vs-test_vs)
    caxis([-0.01 0.01])
end


sr = {e1,e2,ss,ev1,ev2,rm,vs};
sr_meta = {'Max Longitudinal Strain Rate', ...
    'Min Longitudinal Strain Rate', ...
    'Max Shear Strain Rate', ...
    'Max Longitudinal Orientation', ...
    'Min Longitudinal Orientation', ...
    'Rotation Matrix', ...
    'Vertical Strain Rate'};



end



