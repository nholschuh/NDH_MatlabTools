function [yes_no_final angle_storage] = within(data,xcol,ycol,boundaries,skipper)
% Determines whether or not the data within a given set of boundaries
% defined by their vertices. Skipper value is an efficiency algorithm,
% higher values makes the code run faster, but runs the risk of missing
% fine details. Angle_storage is used for debugging.

if exist('skipper') == 0
    skipper = 1;
end

boundaries(length(boundaries(:,1))+1,:) = boundaries(1,:);


counter = 1;
data_addition = [1:length(data(:,1))];
data = [data data_addition'];
data_width = length(data(1,:));
include_vec = [];

for i = 1:length(data(:,1))
    if data(i,xcol) > min(boundaries(:,1)) & data(i,xcol) < max(boundaries(:,1))
        if data(i,ycol) > min(boundaries(:,2)) & data(i,ycol) < max(boundaries(:,2))
            include_vec(counter) = i;
            counter = counter+1;
        end
    end
end



yes_no = zeros(length(data),1);
angle_storage = zeros(length(data),1);


data = data(include_vec,:);

skipped_tracker = [];
subcounter = 1;

tic

for i = 1:length(data(:,1))
    % This is an addition to the code where only every fourth item in the
    % data list is checked. If #1 and #5 are both inside, the code assumes
    % all 1-5 are inside. If one is inside, and one outside, the code
    % checks each of the inbetween values as well.
    
    %%%% This part skips over the options between 1 and skipper
    if subcounter > 1 & subcounter < skipper
        yes_no(data(i,data_width)) = temp_yes_no(i-1);
        temp_yes_no(i) = temp_yes_no(i-1);
        subcounter = subcounter + 1;
        skipped_tracker(i) = 1;
        
    %%%% Once it reaches the last entry to be skipped
    elseif subcounter == skipper && skipper ~= 1
        yes_no(data(i,data_width)) = temp_yes_no(i-1);
        temp_yes_no(i) = temp_yes_no(i-1);
        subcounter = 1;
        skipped_tracker(i) = 1;
        
    %%%% This does the actual data check (either because it has skipped the
    %%%% requisite number of points, or it is the first time through).
    else
        

        %angle = [];  %%%%% If you're having memory problems, uncomment
        %this section, and change all angle(i,j) or angle(k,j) to just
        %angle(j)
        
        dp = [];
        cp = [];
        for j = 1:(length(boundaries(:,1))-1)
            point1 = [boundaries(j,1) boundaries(j,2) 0];
            point2 = [data(i,xcol) data(i,ycol) 0];
            point3 = [boundaries(j+1,1) boundaries(j+1,2) 0];
            avec = point1-point2;
            bvec = point3-point2;
            dp(j) = dot(avec,bvec);
            cp(j,:) = cross(avec,bvec);
            angle(i,j) = rad2deg(asin(norm(cp(j,:))/(norm(avec)*norm(bvec))));
 
            if dp(j) < 0 
                angle(i,j) = 180-angle(i,j);
            end
            
            angle(i,j) = angle(i,j)*sign(cp(j,3));

        end
        if abs(sum(angle(i,:))) > 359 
            yes_no(data(i,data_width)) = 1;
            temp_yes_no(i) = 1;
            angle_storage(data(i,data_width)) = sum(angle(i,:));
            subcounter = 2;
        else
            yes_no(data(i,data_width)) = 0;
            temp_yes_no(i) = 0;
            angle_storage(data(i,data_width)) = sum(angle(i,:));
            subcounter = 2;
        end
        
        skipped_tracker(i) = 0;
        
        
        if i > skipper
            % This portion checks to see if the two nearest values are the
            % same, and if they are not, it recalculates the intervening
            % values.
            
            
            if temp_yes_no(i) ~= temp_yes_no(i-skipper)
                for k = (i-skipper+1):(i-1)
                    %angle = [];
                    dp = [];
                    cp = [];
                    for j = 1:(length(boundaries(:,1))-1)
                        point1 = [boundaries(j,1) boundaries(j,2) 0];
                        point2 = [data(k,xcol) data(k,ycol) 0];
                        point3 = [boundaries(j+1,1) boundaries(j+1,2) 0];
                        avec = point1-point2;
                        bvec = point3-point2;
                        dp(j) = dot(avec,bvec);
                        cp(j,:) = cross(avec,bvec);
                        angle(k,j) = rad2deg(asin(norm(cp(j,:))/(norm(avec)*norm(bvec))));

                        if dp(j) < 0 
                            angle(i,j) = 180-angle(i,j);
                        end
                        angle(i,j) = angle(i,j)*sign(cp(j,3));
                        
                    end
                    if abs(sum(angle(k,:))) > 359
                        yes_no(data(k,data_width)) = 1;
                        angle_storage(data(k,data_width)) = sum(angle(k,:));
                        temp_yes_no(k) = 1;
                    else
                        yes_no(data(k,data_width)) = 0;
                        angle_storage(data(k,data_width)) = sum(angle(k,:));
                        temp_yes_no(k) = 0;
                    end
                    
                    skipped_tracker(k) = 0;
                end
            end
            
            
        end
        
        
    end
    if i == 1
        times = toc;
        disp(['The First Sample took ',num2str(round(times*1000)),'ms'])
        disp(['There are a total of ',num2str(length(data(:,1))),' samples'])
        disp(['Predicted total time - ',num2str(length(data(:,1))*times),'s'])
    end
end


yes_no_final = yes_no;


end