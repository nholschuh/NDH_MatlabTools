function box_edge = remove_interior_points(polygons)



    xvert = [];
    yvert = [];
    segment = [];
    
    %%%%% This collects all of the corner values used to define the
    %%%%% ice-stream of interest, and converts them to box edge segments
    %%%%% for analysis.
    for i = 1:length(polygons)
        if polygons{i}(end,:) ~= polygons{i}(1,:)
            polygons{i}(end+1,:) = polygons{i}(1,:);
        end
        
        b_temp = polygons{i};
        region_box2{i} = b_temp;
        
        xvert = [xvert; b_temp(:,1)];
        yvert = [yvert; b_temp(:,2)];
        for j = 1:length(region_box2{i}(:,1))
            start = j;
            stop = j+1;
            if stop > length(region_box2{i}(:,1))
                stop = 1;
            end
            segment = [segment; region_box2{i}(start,1:2) region_box2{i}(stop,1:2)];
        end
    end
    
    %%%%%% Here, using the segments previously calculated, we add to the
    %%%%%% list of vertices all edge intersections (for the eventual
    %%%%%% drawing of the outline of the total area).
    for i = 1:length(segment)
        test_inds = 1:length(segment);
        test_inds(i) = [];
        for j = 1:length(test_inds)
            
            [int_flag temp] = segment_intersect([segment(i,1:2);segment(i,3:4)],[segment(j,1:2);segment(j,3:4)],0);
            if int_flag == 1
                xvert = [xvert; temp(1)];
                yvert = [yvert; temp(2)];
            end
        end
    end
    
    
    if 0 %%%%%%%%%%%%%%%%%%%%%%%%%%% This is for debugging
        %%
       for i = 1:length(segment)
           plot(segment(i,[1 3]),segment(i,[2 4]),'Color',[0.5 0.5 0.5])
           hold all
       end
        plot(xvert,yvert,'o')
    end
    
    %%%%%% Here we find which vertices lie entirely within a box, and
    %%%%%% remove them from the list of vertices used to draw the overall
    %%%%%% outline.
    exclude_vec = [];
    for i = 1:length(region_box2)
        [in on] = inpolygon(xvert,yvert,region_box2{i}(:,1),region_box2{i}(:,2));
        exclude_vec = [exclude_vec; find(in == 1 & on == 0)];
        
        if 0
            hold off
            plot(region_box2{i}(:,1),region_box2{i}(:,2),'Color',[0.5 0.5 0.5])
            hold all
            inds = find(in == 1 & on == 0);
            inds2 = find(in ~=1 | on ~= 0);
            plot(xvert(inds),yvert(inds),'o','Color','red')
            plot(xvert(inds2),yvert(inds2),'o','Color','blue')
            keyboard
        end
        
    end
    
    xvert(exclude_vec) = [];
    yvert(exclude_vec) = [];
    xy = [xvert yvert];
    xy = remove_duplicates(xy);
    
    %%%%%% Finally (in an act of extreme overkill), we use a genetic
    %%%%%% algorithm to solve the travelling salesman problem, and find the
    %%%%%% order of vertices which defines the total box outline.
    
    userConfig = struct('xy',xy,'numIter',1000*length(region_box2),'showProg',false,'showResult',false,'showWaitbar',false);
    tsp_results = tsp(userConfig);
    box_edge = xy([tsp_results.optRoute tsp_results.optRoute(1)],:);
    
    
    
    
    
end