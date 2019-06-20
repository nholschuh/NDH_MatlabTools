function mask_grid = fill_closedpolygon(gridx,gridy,polygon);

%%%%%%%%%%%%%%% Calculate the grid spacing
dx = gridx(2)-gridx(1);
dxt = max(gridx)-min(gridx);
dy = gridy(2)-gridy(1);
dyt = max(gridy)-min(gridy);


%%%%%%%%%%%%%%% Start by forcing the first and last point to be the same
if polygon(1,:) ~= polygon(end,:)
    polygon(end+1,:) = polygon(1,:);
end

%%%%%%%%%%%%%%% Interpolate the polygon points if the distance between them
%%%%%%%%%%%%%%% exceeds the grid spacing
distances = distance_vector(polygon(:,1),polygon(:,2),1);
if mean(distances) > 0.5*dx
    [polygon] = line_fill(polygon,min([dx dy])/4,1);
end


%%%%%%%%%%%%%%% Identify which edges of the grid fall within the polygon
leftinds = length(find(polygon(:,1) < min(gridx)));
rightinds = length(find(polygon(:,1) > max(gridx)));
upinds = length(find(polygon(:,2) > min(gridy)));
downinds =  length(find(polygon(:,2) < max(gridy)));

isleft = [leftinds > rightinds];
isup = [upinds > downinds];


%%%%%%%%%%%%%%% Eliminate the points that fall outside of the grid
row_inds = find(polygon(:,1) <= max(gridx) & polygon(:,1) >= min(gridx));
polygon = polygon(row_inds,:);
row_inds = find(polygon(:,2) <= max(gridy) & polygon(:,2) >= min(gridy));
polygon = polygon(row_inds,:);

p_ind = [];
p_ind(:,1) = 1+round((polygon(:,1)-min(gridx))/dx); % column index
p_ind(:,2) = 1+round((polygon(:,2)-min(gridy))/dy); % row index
p_ind(end+1,:) = p_ind(1,:);


p_ind_dist = distance_vector(p_ind(:,1),p_ind(:,2),1);

jump_inds = find(p_ind_dist > 5);


%%%%%%%%%%%%%%%%%%%%% This adds in points along the edges where there are
%%%%%%%%%%%%%%%%%%%%% needed
for i = 1:length(jump_inds);
    %%% Distance from       (left)    (top)    (right)    (bottom)
    dists = [abs(p_ind(jump_inds(i),1)-1) abs(p_ind(jump_inds(i),2)-1) abs(p_ind(jump_inds(i),1)-length(gridx)) abs(p_ind(jump_inds(i),2)-length(gridy))];
    wall(i,1) = find(min(dists) == dists);
    dists = [abs(p_ind(jump_inds(i)+1,1)-1) abs(p_ind(jump_inds(i)+1,2)-1) abs(p_ind(jump_inds(i)+1,1)-length(gridx)) abs(p_ind(jump_inds(i)+1,2)-length(gridy))];
    wall(i,2) = find(min(dists) == dists);
    
    if wall(i,1) == 1
        insert_vec(1,:) = [1 p_ind(jump_inds(i),2)];
    elseif wall(i,1) == 2
        insert_vec(1,:) = [p_ind(jump_inds(i),1) 1];
    elseif wall(i,1) == 3
        insert_vec(1,:) = [length(gridx) p_ind(jump_inds(i),2)];
    elseif wall(i,1) == 4
        insert_vec(1,:) = [p_ind(jump_inds(i),1) length(gridy)];
    end
    
    if wall(i,2) == 1
        insert_vec(2,:) = [1 p_ind(jump_inds(i)+1,2)];
    elseif wall(i,1) == 2
        insert_vec(2,:) = [p_ind(jump_inds(i)+1,1) 1];
    elseif wall(i,1) == 3
        insert_vec(2,:) = [length(gridx) p_ind(jump_inds(i)+1,2)];
    elseif wall(i,1) == 4
        insert_vec(2,:) = [p_ind(jump_inds(i)+1,1) length(gridy)];
    end    
    
    skipvec = 2;
    
    
    if wall(i,1) ~= wall(i,2)
        if (wall(i,:) == [1 2] | wall(i,:) == [2 1])
            insert_vec = [insert_vec(1,:); 1 1; insert_vec(2,:)];
            skipvec = skipvec+1;
        elseif (wall(i,:) == [2 3] | wall(i,:) == [3 2])
            insert_vec = [insert_vec(1,:); length(gridx) 1; insert_vec(2,:)];
            skipvec = skipvec+1;
        elseif (wall(i,:) == [3 4] | wall(i,:) == [4 3])
            insert_vec = [insert_vec(1,:); length(gridx) length(gridy); insert_vec(2,:)];
            skipvec = skipvec+1;
        elseif(wall(i,:) == [4 1] | wall(i,:) == [1 4])
            insert_vec = [insert_vec(1,:); 1 length(gridy); insert_vec(2,:)];
            skipvec = skipvec+1;
            
            
        elseif wall(i,:) == [1 3]
            if isup == 1
                insert_vec = [insert_vec(1,:); 1 1; length(gridx) 1; insert_vec(2,:)];
            else
                insert_vec = [insert_vec(1,:); 1 length(gridy); length(gridx) length(gridy); insert_vec(2,:)];
            end
            skipvec = skipvec+2;
        elseif  wall(i,:) == [3 1]
            if isup == 1
                insert_vec = [insert_vec(1,:); length(gridx) 1; 1 1; insert_vec(2,:)];
            else
                insert_vec = [insert_vec(1,:); length(gridx) length(gridy); 1 length(gridy); insert_vec(2,:)];
            end
            skipvec = skipvec+2;
        elseif wall(i,:) == [2 4]
            if isleft == 1
                insert_vec = [insert_vec(1,:); 1 1; 1 length(gridy); insert_vec(2,:)];
            else
                insert_vec = [insert_vec(1,:); length(gridx) 1; length(gridx) length(gridy); insert_vec(2,:)];
            end
            skipvec = skipvec+2;
        elseif wall(i,:) == [4 2]
            if isleft == 1
                insert_vec = [insert_vec(1,:); 1 length(gridy); 1 1; insert_vec(2,:)];
            else
                insert_vec = [insert_vec(1,:); length(gridx) length(gridy); length(gridx) 1; insert_vec(2,:)];
            end
            skipvec = skipvec+2;
        end
    end
    
    p_ind = [p_ind(1:jump_inds(i),:); insert_vec; p_ind(jump_inds(i)+1:end,:)];
    jump_inds(i+1:end) = jump_inds(i+1:end)+skipvec;

end


%%%%%%%%%%%%%%% Interpolate the polygon points if the distance between them
%%%%%%%%%%%%%%% exceeds the grid spacing

p_ind = line_fill(p_ind,0.1,1);
p_ind = round(p_ind);


%%%%%%%%%%%%%%% Initiate the maskgrid, and fill the cells that contain
%%%%%%%%%%%%%%% points from the polygon
mask_grid = zeros(length(gridy),length(gridx));
start_ind = sub2ind([length(gridy) length(gridx)],p_ind(:,2),p_ind(:,1));
mask_grid(start_ind) = 1;

mask_grid = imfill(mask_grid,'holes');

plotter = 0;
if plotter == 1
    imagesc(gridx,gridy,mask_grid)
    colormap(gray)
    hold all
    plot(polygon(:,1),polygon(:,2),'o-','Color','red','LineWidth',2)
    set(gca,'YDir','normal')
end

end





