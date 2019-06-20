function [linematrix] = line_fill(segmat,value,density0_or_distance1,i_meth)
% Fills in data points with given 'density' along provided segments, with
% data provided in an nxm matrix, where n is the number of data, with the
% first 2 columns containing the x and y coordinates. The later columns can
% be other data that you wish to linearly interpolate between points.

s_dim = size(segmat);
turnflag = 2;

if min(s_dim) == 1
    remove_flag = 1;
    if s_dim(1) == 1
        segmat = [segmat' zeros(size(segmat'))];
        turnflag = 1;
    else
        segmat = [segmat zeros(size(segmat))];
        turnflag = 2;
    end
else
    remove_flag = 0;
end

if exist('i_meth') == 0
    i_meth = 'linear';
end


if density0_or_distance1 == 0
    linematrix = zeros(value*(length(segmat(:,1))-1)+1,length(segmat(1,:))); % Creates an empty vector with the value*# of original values
    
    for i = 1:length(segmat(:,1))-1
        rangevec = segmat(i+1,:) - segmat(i,:);
        incrementvec = rangevec/value;
        
        startingindex = 1+value*(i-1);
        linematrix(startingindex,:) = segmat(i,:);
        for j = 1:value-1
            linematrix(startingindex+j,:) = linematrix(startingindex+j-1,:)+incrementvec;
        end
    end
    linematrix(length(linematrix(:,1)),:) = segmat(length(segmat(:,1)),:);
else
    
    dist_vec2 = distance_vector(segmat(:,1),segmat(:,2),1);
    remove_rows = find(dist_vec2 == 0);
    segmat(remove_rows,:) = [];
    dist_vec = distance_vector(segmat(:,1),segmat(:,2));
    new_dist = 0:value:max(dist_vec);

    
    
    for i = 1:2
        linematrix(:,i) = interp1(dist_vec,segmat(:,i),new_dist,i_meth);
    end
    
    for i = 3:length(segmat(1,:))
        linematrix(:,i) = interp1(dist_vec,segmat(:,i),new_dist,'linear');
    end
    
end

if remove_flag == 1
    linematrix = linematrix(:,1:end-1);
end

if turnflag == 1
    linematrix = linematrix';
elseif turnflag == 2
    linematrix = linematrix;    
end



end