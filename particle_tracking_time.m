function [location times] = particle_tracking_time(startx,starty,x,y,u,v,dt,time,grid_plotmethod,plotter)
% (C) Nick Holschuh - Penn State University - 2015r (Nick.Holschuh@gmail.com)
% Computes Particle Paths for all values provided for startx and starty
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
% %
% startx - x coordinates for the start of traced particles
% starty - y coordinates for the start of traced particles
% x - x-axis for your velocity grid
% y - y-axis for your velocity grid
% u - x velocities
% v - y velocities
% distances - the total distance you want the particle to travel along its path
% dx - the step distance for a particle along its path (default is one grid cell width)
% grid_plotmethod - (0) is a quiver plot (1) is a speed field
% plotter - (0) runs without plotting, (1) plots the traced particle paths
% %
%
%%%%%%%%%%%%%%%
% The outputs are:
%
% location - is a structure where location{i}(:,1) is the ith particles x
% position, and location{i}(:,2) is the ith particles y position
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if exist('grid_plotmethod') == 0
    grid_plotmethod = 1;
end
if exist('plotter') == 0
    plotter = 0;
end
if exist('dt') == 0
    dt = (x(2)-x(1))/max(max(u));
end
if dt == 0
    dt = (x(2)-x(1))/max(max(u));
end

steps = ceil(time/dt);
times = 0:dt:time;


if plotter == 1
    if grid_plotmethod == 1
        imagesc(x,y,v./u)
        colormap(b2r2(-1,1));
        set(gca,'YDir','normal')
        pause(0.1)
        hold all
    else
        quiver(x,y,u,v,4);
        pause(0.1)
        hold all
    end
end

 tic
 for i = 1:length(startx)
     
     if startx(i) > max(x) | startx(i) < min(x) | starty(i) < min(y) | starty(i) > max(y)
         
         xy_pairs = combvec(x,y)';
         [ind val] = find_nearest_xy(xy_pairs(:,[1 2]),[startx(i) starty(i)]);
         location{i}(1,:) = val;
     else
         location{i}(1,:) = [startx(i) starty(i)];
     end
     
     
     for j = 1:steps
         
         
         % Find the three closest points to the data
         if max(isnan(location{i}(j,:))) == 1
             break
         else
             [xinds xvals xranges] = find_nearest(x,location{i}(j,1),2);
             [yinds yvals yranges] = find_nearest(y,location{i}(j,2),2);
             uvals = reshape(u(yinds,xinds),[4 1]);
             vvals = reshape(v(yinds,xinds),[4 1]);
             temp = sortrows(combvec(xranges,yranges)')';
             distances = reshape((temp(1,:).^2+temp(2,:).^2).^0.5,[4 1]);
             weights = 1./distances;
             if max(weights) == inf
                 index = find(weights == inf);
                 if index < 3
                     xind_temp = min(xinds);
                 else
                     xind_temp = max(xinds);
                 end
                 if mod(index,2) == 0
                     yind_temp = max(yinds);
                 else
                     yind_temp = min(yinds);
                 end
                 u_temp = u(yind_temp,xind_temp);
                 v_temp = v(yind_temp,xind_temp);
             else
                 u_temp = sum(uvals.*weights)/sum(weights);
                 v_temp = sum(vvals.*weights)/sum(weights);
             end
             unitu = u_temp;
             unitv = v_temp;
             location{i}(j+1,:) = location{i}(j,:) + [unitu unitv];
             % If partical moves outside the domain
             if location{i}(j+1,1) > max(x) | location{i}(j+1,1) < min(x) | location{i}(j+1,2) > max(y) | location{i}(j+1,2) < min(y)
                 
                 break
             end
         end
         
         
         if plotter == 1
             plot(location{i}(:,1),location{i}(:,2),'Color','black','LineWidth',2)
             pause(0.1)
         end
         
     end
     disp(['Completed line ',num2str(i),' of ',num2str(length(startx)),' - ',num2str(round(toc)),'s'])
 end
        
    
end