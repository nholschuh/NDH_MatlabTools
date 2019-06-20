function RayTracer(source_position,horizon_depths,domain_x,domain_z,domain_V,savename,plotter,video_flag)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Performs a ray tracing algorithm that finds the path of minimum time for
% a given set of sources to their targets.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% source_position - vector containing the x positions within domain_x for
%                   the ray source. The receiver will be -1*source_position
% horizon_depths - The depths to target horizons that will be used for
%                   reflection
% domain_x - The xaxis for the domain
% domain_z - The zaxis for the domain
% domain_V - 2D matrix containing the velocity values for the domain. If 0
%            is chosen, the domain will be generated using a standard firn column
% savename - The filename (without .mat) that the results will be saved to
% plotter - 0 or 1, for displaying the debug ray tracing plots
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('plotter') == 0
    plotter = 0;
end
if exist('video_flag') == 0
    video_flag = 0;
end


%%%%%%%%% This sets up the domain in the event that a zero is chosen
if length(domain_V) == 1
    %%%% In this case, we assume a domain with a starting snow density
    %%%% equal to dens_0
    dens_0 = 0.450;

    % Firn Density from Herron and Langway
    rho_p = firn_density(domain_z,dens_0)'*ones(1,length(domain_x));

    % Velocity from density - Robin 1975
    cair_import;
    domain_V = cair./(1+0.851*rho_p);
end


% Ray Tracer
start_x = source_position;
midpointz = horizon_depths;

converge_rate = 0.8; % Defines how quickly the angle approaches the assumed correct angle.
frame_counter = 1;

step_length = min([domain_x(2)-domain_x(1) domain_z(2)-domain_z(1)]);
% This is the size of the steps to be taken initially (should be only one grid cell in size);
distance = round(2*((max(domain_x)-min(domain_x))^2 + (max(domain_z) - min(domain_z))^2)^0.5); 
% This is the maximum travel distance for a ray before the code should crash

down_up_flag = 0; % This switches upon reflection

if plotter == 1;
    figure();
    set(gcf,'Position',[528         763        1102         550])
    subplot(2,4,[1 2 3 5 6 7])
    imagesc(domain_x,domain_z,rho_p);
    colormap(gray);
    NDH_Style()
    ylim([-1 max(domain_z)])
    hold all
    pause(1)
end

tic
clear position
for m = 1:length(midpointz)
    for k = 1:length(start_x)
        
        % Approximate the initial downgoing angle
        start_angle = round(rad2deg(real(atan(abs(start_x(k))/midpointz(m))*(domain_V(1,1)/domain_V(end,1)))));
        angle_storage{k,m} = start_angle;
        
        
       % Initialize values for the while loop
        offset_dist = 5;
        pod = 100;
        ang_counter = 1;
        
       
        while abs(offset_dist) > 1

            
            if plotter == 1
                subplot(2,4,4)
                hold off
                if exist('ta') == 1
                    delete(ta)
                end
                ta = text(0.5,0.5,num2str(angle_storage{k,m}(ang_counter)),'HorizontalAlignment','center');
                title('Flight Angle')
                subplot(2,4,8)
                hold off
                if exist('tb') == 1
                    delete(tb)
                end
                tb = text(0.5,0.5,num2str(offset_dist),'HorizontalAlignment','center');
                title('Previous Offset dist')
                subplot(2,4,[1 2 3 5 6 7])
            end
            
            if angle_storage{k,m}(ang_counter) > 90
                position{k,m} = [NaN NaN NaN;
                    NaN NaN NaN;
                    NaN NaN NaN];
                end_position{k,m} = [start_x(k) 0];
                angle_storage{k,m}(ang_counter) = 90;
                distances(k,m) = 0;
                break
            end
            
            % Initialize values within the while loop
            down_up_flag = 0;
            position{k,m} = [start_x(k) 1];
            ang(1) = deg2rad(angle_storage{k,m}(ang_counter));
            
            

            Vs_indx = find_nearest(domain_x,position{k,m}(1,1));
            Vs_indz = find_nearest(domain_z,position{k,m}(1,2));
            Vs(1) = domain_V(Vs_indz,Vs_indx);
            distances(k,m) = 0;
            
            break_flag = 0;
            fail_flag = 0;
            
            for i = 1:round(distance/step_length)
                if break_flag == 1
                    break
                end
                % Determine if you are in a constant velocity zone, and
                % increase step size if so.
                if position{k,m}(i,2) > 200
                    steps = 80*step_length;
                elseif position{k,m} > 50
                    steps = step_length*10;
                elseif position{k,m} > 25
                    steps = step_length*2;
                else
                    steps = step_length;
                end
                unit_y = cos(ang(i))*steps;
                unit_x = sin(ang(i))*steps;
                if down_up_flag == 0
                    position{k,m}(i+1,1:2) = [position{k,m}(i,1)+unit_x position{k,m}(i,2)+unit_y];
                else
                    position{k,m}(i+1,1:2) = [position{k,m}(i,1)+unit_x position{k,m}(i,2)-unit_y];
                end
                Vs_indx = find_nearest(domain_x,position{k,m}(i+1,1));
                Vs_indz = find_nearest(domain_z,position{k,m}(i+1,2));
                Vs(i+1) = domain_V(Vs_indz(1),Vs_indx(1));
                position{k,m}(i+1,3) = Vs(i+1);
                ang(i+1) = asin(sin(ang(i))*Vs(i+1)/Vs(i));
                distances(k,m) = distances(k,m) + steps;
                
                if imag(ang(i+1)) ~=0
                    break_flag = 1;
                    fail_flag = 1;
                end
                
                % Find out if you cross the midpoint depth, if so define
                % your current location along the midpoint interface
                if position{k,m}(i+1,2) > midpointz(m)
                    down_up_flag = 1;
                    temp_pos = [position{k,m}(i,1)+unit_x position{k,m}(i,2)+unit_y];
                    subpath_length = (midpointz(m)-position{k,m}(i,2))/(temp_pos(2)-position{k,m}(i,2));
                    position{k,m}(i+1,1:2) = [position{k,m}(i,1)+unit_x*subpath_length position{k,m}(i,2)+unit_y*subpath_length];
                end
                
                if position{k,m}(i+1,2) < min(domain_z) || position{k,m}(i+1,1) > abs(start_x(k))+5
                    end_position{k,m} = position{k,m}(i+1,:);
                    offset_dist = position{k,m}(i+1,1)-abs(start_x(k));
                    break_flag = 1;
                    ang_counter = ang_counter + 1;
                    angle_storage{k,m}(ang_counter) = angle_storage{k,m}(ang_counter-1) - rad2deg(atan(offset_dist/(2*midpointz(m)))*converge_rate);
                    break
                end
                
                if plotter == 1
                    if exist('line_name') == 1
                        delete(line_name);
                    end
                    line_name = plot(position{k,m}(1:i+1,1),position{k,m}(1:i+1,2),'Color','blue','LineWidth',2);
                    pause(0.1)
                    if video_flag == 1
                        frames(frame_counter) = getframe(gcf);
                        frame_counter = frame_counter+1;
                    end
                end
                
                if ang_counter > 100
                    converge_rate = 0.01;                
                elseif ang_counter > 50
                    converge_rate = 0.05;
                elseif ang_counter > 20
                    converge_rate = 0.2;
                elseif ang_counter > 10
                    converge_rate = 0.4;
                else
                    converge_rate = 0.8;
                end
            end
            
            
            if fail_flag == 1
                position{k,m} = [NaN NaN NaN;
                    NaN NaN NaN;
                    NaN NaN NaN];
                end_position{k,m} = [start_x(k) 0];
                angle_storage{k,m}(ang_counter) = 90;
                distances(k,m) = 0;
                break
            end
            
            
            
            
            disp(['Iteration ',num2str(ang_counter-1),' (error ',sprintf('%0.3f',offset_dist),') - time = ',num2str(round(toc)),'s'])
            if abs(offset_dist) > 5*abs(pod)
                keyboard
            end
            pod = offset_dist;
        end

        disp(['Completed offset ',num2str(k),' of ',num2str(length(start_x)),' - Midpoint ',num2str(m),' of ',num2str(length(midpointz))])
    end
    save([savename,'.mat'],'position','start_x','midpointz','domain_x','domain_z','rho_p','distances','end_position','angle_storage','m','k')
end

if plotter == 1
    if video_flag == 1
        vid_ob = VideoWriter(['RayTracing.avi'],'Motion JPEG AVI');
        vid_ob.FrameRate = 15;
        vid_ob.Quality = 75;
        
        open(vid_ob)
        writeVideo(vid_ob,frames)
        close(vid_ob)
    end
end
