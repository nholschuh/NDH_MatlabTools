function location = particle_tracking(startx,starty,x,y,u,v,distances,dx,plotter,grid_plotmethod,particle_tracking_method)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% Computes Particle Paths for all values provided for startx and starty
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
% %
% startx - x coordinates for the start of traced particles
% starty - y coordinates for the start of traced particles
% x - x-axis or mesh for your velocity grid
% y - y-axis or mesh for your velocity grid
% u - x velocities
% v - y velocities
% distances - the total distance you want the particle to travel along its path
% dx - the step distance for a particle along its path (default is one grid cell width)
% grid_plotmethod - (0) is a quiver plot (1) is a speed field
% plotter - (0) runs without plotting, (1) plots the traced particle paths
% particle_tracking_method - [0] trace each tracer individually, 1 do it
%                           simultaneously
%
%
%%%%%%%%%%%%%%%
% The outputs are:
%
% location - is a structure where location{i}(:,1) is the ith particles x
% position, and location{i}(:,2) is the ith particles y position
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


particle_tracking_method = 0;

%%%%%% This is for testing - method 0 iterates over the points and the
%%%%%% steps, method 1 only interates over the steps;


if exist('particle_tracking_method') == 0
    particle_tracking_method = 0;
end
if exist('grid_plotmethod') == 0
    grid_plotmethod = 1;
end
if exist('plotter') == 0
    plotter = 0;
end
if exist('dx') == 0
    dx = x(2)-x(1);
end
if dx == 0
    dx = x(2)-x(1);
end

update_flag = 1;

%%%%%%%%%%%%%% This portion identifies if the x and y values are axes or a
%%%%%%%%%%%%%% mesh:

if min(size(x)) == 1
    vec_or_mesh = 0;
else
    vec_or_mesh = 1;
end

xs_size = size(startx);
if max(xs_size) > 1 & length(startx(:,1)) == 1
    startx = startx';
    starty = starty';
end


steps = ceil(distances/dx);

if plotter == 1
    if grid_plotmethod == 1
        if vec_or_mesh == 0
            imagesc(x,y,90-rad2deg(atan2(v,u)))
        elseif vec_or_mesh == 1
            pcolor(x,y,90-rad2deg(atan2(v,u)))
            shading interp
        end
        cc = colorbar();
        ylabel(cc,'Particle Trajectory')
        axis equal
        set(gca,'YDir','normal')
        pause(0.1)
        hold all
    else
        quiver(x,y,u,v,4);
        pause(0.1)
        hold all
    end
end

%%%%% This part generates the edge locations in case the points fall
%%%%% outside the particle tracking grid:

if vec_or_mesh == 0
    [x y] = meshgrid(x,y);
    et = combvec(x,y(1))';
    eb = combvec(x,y(end))';
    el = combvec(x(1),y)';
    er = combvec(x(end),y)';
elseif vec_or_mesh == 1
    et = [x(1,:)' y(1,:)'];
    eb = [x(end,:)' y(end,:)'];
    el = [x(:,1) y(:,1)];
    er = [x(:,end) y(:,end)];
end

    xy_pairs = [et;eb;el;er];

    
    
 if length(startx) == 1
     startx = ones(size(starty))*startx;
 end
 if length(starty) == 1
     starty = ones(size(startx))*starty;
 end

 tic
 
 
 if particle_tracking_method == 0
     
    search_xy(:,:,1) = x;
    search_xy(:,:,2) = y;     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here, in this method, we iterate
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% over the points
     for i = 1:length(startx)
         
         if startx(i) > max(max(x)) | startx(i) < min(min(x)) | starty(i) < min(min(y)) | starty(i) > max(max(y))
             [ind val] = find_nearest_xy(xy_pairs(:,[1 2]),[startx(i) starty(i)]);
             location{i}(1,:) = [val 0];
         else
             location{i}(1,:) = [startx(i) starty(i) 0];
         end
         
         
         for j = 1:steps
             
             
             % Find the three closest points to the data
             if max(isnan(location{i}(j,:))) == 1
                 break
             else
                 
                 [inds vals distances] = find_nearest_xy(search_xy,location{i}(j,:),4);
                 uvals = reshape(u(inds),[1 4]);
                 vvals = reshape(v(inds),[1 4]);
                 weights = 1./distances;
                 
                 %% This deals with the case where our tracer lands exactly on a node;
                 if max(weights) == inf
                     node_ind = find(weights == inf);
                     u_temp = u(inds(node_ind));
                     v_temp = v(inds(node_ind));
                 else
                     u_temp = sum(uvals.*weights)/sum(weights);
                     v_temp = sum(vvals.*weights)/sum(weights);
                 end
                 unitu = u_temp/((u_temp^2+v_temp^2)^0.5)*dx;
                 unitv = v_temp/((u_temp^2+v_temp^2)^0.5)*dx;
                 dt = dx/((u_temp^2+v_temp^2)^0.5);
                 location{i}(j+1,:) = location{i}(j,:)+ [unitu unitv dt];
                 % If partical moves outside the domain
                 if location{i}(j+1,1) > max(max(x)) | location{i}(j+1,1) < min(min(x)) | location{i}(j+1,2) > max(max(y)) | location{i}(j+1,2) < min(min(y))
                     break
                 end
             end
             
             
             if plotter == 1
                 plot(location{i}(:,1),location{i}(:,2),'o-','Color','black','LineWidth',2)
                 pause(0.1)
             end
             
         end
         disp(['Completed line ',num2str(i),' of ',num2str(length(startx)),' - ',num2str(round(toc)),'s'])
     end
     
 else
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here, we solve for the new positions for all
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% starting points simultaneously
     
     %%%%%%%%%%% Maps the point onto an edge of the domain
     
     location_x = ones(length(startx),round(steps/2))*NaN;
     location_y = ones(length(startx),round(steps/2))*NaN;
     location_time = ones(length(startx),round(steps/2))*NaN;
     total_dist = zeros(length(startx),round(steps/2));
     
     for i = 1:length(startx)
         if startx(i) > max(max(x)) | startx(i) < min(min(x)) | starty(i) < min(min(y)) | starty(i) > max(max(y))
             [ind val] = find_nearest_xy(xy_pairs(:,[1 2]),[startx(i) starty(i)]);
             location_x(i,1) = [val(1)];
             location_y(i,1) = [val(2)];
             location_time(i,1) = [0];
         else
             location_x(i,1) = [startx(i)];
             location_y(i,1) = [starty(i)];
             location_time(i,1) = [0];
         end
     end
     
     search_inds = find(isnan(location_x(:,1)) == 0);

     for i = 1:steps
         u_temp = matsearch([location_x(search_inds,i) location_y(search_inds,i)],x,y,u,2);
         v_temp = matsearch([location_x(search_inds,i) location_y(search_inds,i)],x,y,v,2);
         
         unitu = u_temp./((u_temp.^2+v_temp.^2).^0.5)*dx;
         unitv = v_temp./((u_temp.^2+v_temp.^2).^0.5)*dx;
         dt = dx./((u_temp.^2+v_temp.^2).^0.5);
         
         location_x(search_inds,i+1) = location_x(search_inds,i)+unitu;
         location_y(search_inds,i+1) = location_y(search_inds,i)+unitv;
         location_time(search_inds,i+1) = location_time(search_inds,i)+dt;
         
         
         total_dist(search_inds,i+1) = sum(sqrt([([location_x(search_inds,i+1) location_y(search_inds,i+1)] ...
             -[location_x(search_inds,i+1) location_y(search_inds,i+1)]).^2]'))';
         
         
         if i > 5
            total_dist(:,i+1) = 0;
            total_dist(search_inds,i+1) = sum(sqrt([([location_x(search_inds,i-5) location_y(search_inds,i-5)] ...
             -[location_x(search_inds,i+1) location_y(search_inds,i+1)]).^2]'))';
         else
            total_dist(:,i+1) = ones(size(total_dist(:,i+1)))*dx*5;
         end
         
         %%%%%%%%%%%% This finds indecies within the grid and that are
         %%%%%%%%%%%% still moving away from their origin.
         search_inds = find(isnan(location_x(:,i+1)) == 0 & total_dist(:,i+1) > dx*3);
         
         if plotter == 1 & i > 1
             plot(location_x(:,1:i)',location_y(:,1:i)','o-','Color','black','LineWidth',2)
             pause(0.1)
         end
         disp(['Completed Step ',num2str(i),' (max ',num2str(steps),') - ',num2str(round(toc)),'s, ',num2str(length(search_inds)),'/',num2str(length(startx)),' tracers remaining'])
         
         if length(search_inds) == 0
             break
         end
     end
     
     for i = 1:length(location_x(:,1))
         store_inds = find(isnan(location_x(i,:)) == 0);
         location{i} = [location_x(i,store_inds)' location_y(i,store_inds)' location_time(i,store_inds)'];
     end
 end
     
     
end
        
    
    