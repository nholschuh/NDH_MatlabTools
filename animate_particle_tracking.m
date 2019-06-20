function [htemp_x htemp_y] = animate_particle_tracking(paths,x,y,ugrid,vgrid,dt,total_time,surface_repeat,movie);
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% Animates the evolution of surfaces along particle flow paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
% 
% paths - output from "particle_tracking"
% x - x-axis for your velocity grids
% y - y-axis for your velocity grids
% ugrid - x velocities
% vgrid - y velocities
% dt - the time step used to evolve the surface
% total time - the total time you want the particle to travel along its path
% surface_repeat - the number of time steps before the next surface is
%                   generated at the original coordinates
% movie - Name of directory for generation of animation frames

%%%%%%%%%%%%%%%
% There are no outputs:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delay = 0;

if exist('movie') == 0
    movie = 0;
end

if length(movie) > 1
    mkdir(['./',movie])
end

%%%%%%%%% This section takes coordinates from the traced paths and extracts
%%%%%%%%% the velocities at those locations
disp('Extracting Velocities')
for i = 1:length(paths)
    paths{i} = removeNaN(paths{i});
    upath{i} = grdsearch2(paths{i},x,y,ugrid);
    vpath{i} = grdsearch2(paths{i},x,y,vgrid);
    distances{i} = distance_vector(paths{i}(:,1),paths{i}(:,2)); % This computes the distance between successive points on the traced path (used later to find the right particle velocity)
    current_distance_start(i) = distances{i}(2); % Indicates the first threshold distance that needs to be crossed before velocities are updated
    current_u(i) = upath{i}(1);
    current_v(i) = vpath{i}(1);
end

disp('Plotting')
tsteps = round(total_time/dt);

%%%%%%%%%% Initialize the horizon to be tracked
for i = 1:length(paths)
    htemp_x(i) = paths{i}(1,1);
    htemp_y(i) = paths{i}(1,2);
end

%%%%%%%%%% These are the initial values applied when a new horizon starts
velindex_start = ones(1,length(paths))*2;
distvec_start = zeros(1,length(paths));

velindex = velindex_start; % this is the index of the point in the tracked particle path nearest the current horizon location
distvec = distvec_start;
current_distance = current_distance_start; % this indicates how far a particle has travelled so far

dont_delete_flag = 1;
plot_ind = 1;

for j = 1:tsteps    

    
    stepvec(1,:) = [distvec(1,:) > current_distance(1,:)]; % This decides if the velocity index needs to be incremented (IE, the horizon has passed the next path coordinate)
    velindex(1,:) = velindex(1,:) + stepvec(1,:); % This increments the velocity index
    
    for i = 1:length(paths)
        if velindex(1,i) > length(distances{i}) % Exception handling, for if the point goes off the end of the grid
            current_u(1,i) = 0;
            current_v(1,i) = 0;
            current_distances(1,i) = Inf;
        else
            if distvec(1,i) > current_distance(1,i) % If the time step is too long, it is possible the index needs to be incremented more than one
                velindex(1,i) = find_nearest_xy(paths{i},[htemp_x(j,i) htemp_y(j,i)]) + 1; % The code finds the nearest point on the path, and binds the surface there.
                if velindex(1,i) > length(distances{i}) % Again, determines if the point has moved off the end of the grid.
                    current_u(1,i) = 0;
                    current_v(1,i) = 0;
                    current_distances(1,i) = Inf;
                else
                    current_distance(1,i) = distances{i}(velindex(1,i));
                    current_u(1,i) = upath{i}(velindex(1,i));
                    current_v(1,i) = vpath{i}(velindex(1,i));
                    distvec(1,i) = distances{i}(velindex(1,i));
                end
            else
                current_distance(1,i) = distances{i}(velindex(1,i));
                current_u(1,i) = upath{i}(velindex(1,i));
                current_v(1,i) = vpath{i}(velindex(1,i));
            end
        end
    end
    dx = current_u(1,:)*dt;
    dy = current_v(1,:)*dt;
    distvec(1,:) = [distvec(1,:) + abs(dx+dy*sqrt(-1))];
    htemp_x(j+1,:) = htemp_x(j,:)+dx;
    htemp_y(j+1,:) = htemp_y(j,:)+dy;
    
    %%%%% HACK IN FOR AGU 2015 PLOTS - ablates after 730km
    htemp_y(j+1,find(htemp_x(j+1,:) > 740)) = NaN;
    %%%%%

    
    for k = 1:length(plot_ind)
        if dont_delete_flag == 0;
            delete(eval(['a',num2str(k)]))
        end
        if j > delay
            plotname = ['a',num2str(k)];
            plot_string = [plotname,' = plot(htemp_x(plot_ind(k),:),htemp_y(plot_ind(k),:),''o-'',''MarkerSize'',2,''Color'',''black'');'];
            eval(plot_string)
            dont_delete_flag = 0;
        end
    end
    
    if dont_delete_flag == 0
        pause(0.01)
        if length(movie) > 1
            I = getframe(gcf);
            imwrite(I.cdata,['./',movie,'/Frame_',sprintf('%04d',j),'.jpg']);
        end
    else
        disp(['Step ',num2str(j),' of ',num2str(delay),' before plotting'])
    end
    
    if mod(j,surface_repeat) == 0
        plot_ind(k+1) = 1;
        plotname = ['a',num2str(k+1)];
        plot_string = [plotname,' = plot(htemp_x(plot_ind(k+1),:),htemp_y(plot_ind(k+1),:),''o-'',''MarkerSize'',2,''Color'',''black'');'];
        eval(plot_string)
    end
    
    plot_ind = plot_ind+1;
end
    
    
    
    







    

