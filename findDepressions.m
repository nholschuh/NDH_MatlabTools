function [dMask, dDepths] = findDepressions( heights )
%FINDDEPRESSIONS Finds the depressions on a surface.
%  [dMask, dDepths] = findDepressions(heights) returns a mask indicating
%   area of depressions on the surface.
%   INPUT:
%       heights - 2D matrix defining the surface (any numeric)
%   OUTPUT:
%       dMask   - 2D logical indicating true where depressions exist
%       dDepths - 2D numeric of depression depths
%   
%
%   CONCEPT:
%       This was written to model lake formation on a theoretical surface.
%       The goal is to determine where pools of water would form on the
%       surface if the only drainage point were the edge of the surface.
%       For this reason, outside the edge is considered -inf and is ignored
%       as a depression. 
%       
%       It uses nearest 8 neighbors for neighbor detection, but I left in 
%       the function for nearest 4 if you'd prefer that.
%
%
%   EXAMPLE: 
%         %Using createFractalTerrain from:
%         %http://knight.temple.edu/~lakamper/courses/cis350_2004/assignments/assignment_02.htm
%         d = createFractalTerrain(2^6+1,100,0.95);
%         f = figure();
%         ax(1) = axes('visible','on','parent',f);
%         contourf(ax(1),d,15);
% 
%         [lakes,lakeDepths] = findDepressions(d);
%         ax(2) = axes('visible','off','color','none');
%         lakesPlot = double(lakes);
%         lakesPlot(~lakes) = NaN;
%         lakesPlot(lakes) = -inf;
%         h = pcolor(ax(2),lakesPlot);
%         set(h,'edgecolor','none');
% 
%         tmp = hot;
%         tmp(1,:) = [0 0 0.85]; %Want lakes to be light blue
%         colormap(ax(1),tmp);
%         set(ax(2),'color','none');
%
%
%   Written by:
%   Luke Winslow
%   Limnology and Oceanography PhD Student
%   University of Wisconsin - Madison
%   USA, 2012
%
%   lawinslow@gmail.com
%   

% find the local mins

if(~isnumeric(heights) && length(size(d)) ~= 2)
    error('Heights must be a 2D numeric matrix');
end

[~,~,~,imin]=extrema2(heights);



dMask = false(size(heights));
dDepths = nan(size(heights));

siz = size(heights);
%% now for each of the minima, fill with 'water'
for i = 1:length(imin)
    [x,y] = ind2sub(siz,imin(i));
    if(x == 1 || x == siz(1) || y == 1 || y == siz(2))
        continue;
    end
    if(dMask(x,y))
        continue;
    end
    
    tmpM = false(size(heights));
    tmpM(x,y) = true;
    [tmpM,tmpH] = fillLake(tmpM,heights,dMask);
    
    dDepths(tmpM) = tmpH;
    dMask = dMask | tmpM;
end


dDepths = dDepths - heights;


end

% ======================================================
% LOCAL FUNCTIONS
% ======================================================

function [lakeMask, height]= fillLake(startM,hs,currLakes)

    height = -inf;
    heightI = uint32(1);
    order = ones(size(startM),'uint32')*inf;
    
    order(startM) = 0;

    indx = 1;
    siz = size(hs);

    while(true)
        nMask = get8neighborMask(startM);

        [minV,minI] = min(hs(nMask));

        %Because we operate on the subset, we need to grab indexes for the
        %subset
        maskIs = find(nMask);

        %found the mind, so set it to true to indicate it is wet now
        startM(maskIs(minI(1))) = true;


        %if height increased, increase index and set new max height
        
        if(minV > height)
            height = minV;
            heightI = indx;
        end
        order(maskIs(minI(1))) = indx;
        indx = indx + 1;

        % if the new index we just found is an edge, stop
        [x,y] = ind2sub(siz,maskIs(minI(1)));
        if(x == 1 || x == siz(1) || y == 1 || y == siz(2))
            break;
        end
        % if it is currently a lake, we're done too
        if(currLakes(x,y))
            break;
        end
    end

    lakeMask = order < heightI;


end

function nmask = get4NeighborMask(mask)

    %pad mask
    pMask = false(size(mask)+2);
    pMask(2:end-1,2:end-1) = mask;
    mask = pMask;
    
    nmask = false(size(mask));

    % handle core of mask (minus edges)
    for i=2:size(mask,1)-1
        for j=2:size(mask,2)-1
            if(~mask(i,j) && (mask(i-1,j) || mask(i,j-1) || mask(i+1,j) || mask(i,j+1)))
                nmask(i,j) = true;
            end
        end
    end
    

    nmask = nmask(2:end-1,2:end-1);

end
% TODO: This function is a major speed bottleneck. Rewrite to be faster.
function nmask = get8neighborMask(mask)

    %pad mask
    pMask = false(size(mask)+2);
    pMask(2:end-1,2:end-1) = mask;
    mask = pMask;
    
    nmask = false(size(mask));

    % handle core of mask (minus edges)
    for i=2:size(mask,1)-1
        for j=2:size(mask,2)-1
            if(~mask(i,j) && (mask(i-1,j) || mask(i,j-1) || mask(i+1,j) || mask(i,j+1)))
                nmask(i,j) = true;
            end
        end
    end

    nmask = nmask(2:end-1,2:end-1);
    
end


