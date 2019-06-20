function output = water_routing(x,y,hp,start_point,method,output_type)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This function is a wrapper fream stream computation that allows you to
% calculate any combination of the downstream water pathway, the upstream
% catchment area, and the full domain stream network
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% x - The X axis defining the hydraulic potential grid
% y - The Y axis defining the hydraulic potential grid
% hp - The hydraulic potential grid
% start_point - The point of interest within the domain
% method - d8 (0) or d-inf (1) drainage calculation
% output_type - Three element vector [0/1 0/1 0/1] to indicate if you want:
%              1 - The downstream flowpath
%              2 - The upstream catchment
%              3 - The full drainage
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


[X Y] = meshgrid(x,y);
DEM = GRIDobj(X,Y,hp);

if method == 0
    FD = FLOWobj(DEM,'preprocess','fill');
elseif method == 1
    FD = FLOWobj(DEM,'Dinf');
end

%%%% Set the minimum area required to drain into a stream before it is
%%%% considered a "stream". Smaller numbers increases the coverage of the
%%%% final stream network. 

S = STREAMobj(FD,'minarea',40);

%%%%%%%%%%%%%%%%% This method extracts the downstream pathway for water
%%%%%%%%%%%%%%%%% flowing nearest to "start_point"
if output_type(1) == 1
    node_chain{1} = find_nearest_xy([S.x S.y],start_point);
    ind_chain{1} = find(S.ix == node_chain{1});
    stream_xy{1} = [S.x(node_chain{1}) S.y(node_chain{1})];
    
    endflag = 0;
    counter = 1;
    
    %%%%%%%%%%%%% The dINF method can branch downstream, so additional code
    %%%%%%%%%%%%% is required to accomodate that.
    branch = 1;
    cb = 1;
    
    while cb <= branch
        
        if length(ind_chain{cb}) > 1
            counter = length(ind_chain{cb});
        end
        
        while endflag == 0
            node_chain{cb}(counter+1) = S.ixc(ind_chain{cb}(counter));
            if isempty(find(S.ix == node_chain{cb}(counter+1)))
                endflag = 1;
            else
                next_nodes = find(S.ix == node_chain{cb}(counter+1));
                
                %%%%% Here we deal with a branching case
                if length(next_nodes) > 1
                    for j = 2:length(next_nodes)
                        branch = branch+1;
                        ind_chain{branch} = ind_chain{cb};
                        ind_chain{branch}(counter+1) = next_nodes(j);
                        stream_xy{branch} = stream_xy{cb};
                        node_chain{branch} = node_chain{cb};
                        stream_xy{branch}(counter+1,:) = [S.x(node_chain{branch}(counter+1)) S.y(node_chain{branch}(counter+1))];
                    end
                end
                
                ind_chain{cb}(counter+1) = next_nodes(1);
                stream_xy{cb}(counter+1,:) = [S.x(node_chain{cb}(counter+1)) S.y(node_chain{cb}(counter+1))];
            end
            counter = counter+1;
        end
        output.stream = stream_xy;
        cb = cb+1;
    end
end

%%%%%%%%%%%%%%%%% This method extracts the upstream catchment for water
%%%%%%%%%%%%%%%%% flowing into that point
if method == 0
    if output_type(2) == 1
        output.catchment = drainagebasins(FD,start_point(1),start_point(2));
    end
end

%%%%%%%%%%%%%%%%% This method extracts the upstream catchment for water
%%%%%%%%%%%%%%%%% flowing into that point    
if output_type(3) == 1
    output.streamnet = S;
end

end













