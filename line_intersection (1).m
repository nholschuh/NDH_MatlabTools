function [intersect_mat intersect_point intersect_ind] = line_intersections(lines)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
% Calculates the intersections between all input lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% lines - A cell array containing vertical [x y] vectors for the lines
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%
% intersect_mat - a matrix with flags indicating which lines intersect
% intersect_point - a cell array with the same size of intersect_mat
%                   indicating the precise coordinate of the intersection
% intersect_ind - a cell array with the same size of intersect_mat
%                 indicating the indecies that correspond to the 
%                 observations adjacent to the intersection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


%%%%%%%%%% This minimizes the number of segments in each line, based on
%%%%%%%%%% segments that don't have bearing deviations > 5 degrees

lines2 = reduce_linecomplexity(lines,5,0);
intersect_mat = zeros(length(lines2));


tic
disp(['Initiating intersection discovery for ',num2str(length(lines)),' lines.'])
for i = 1:length(lines2)         % Compare each line
    for j = i+1:length(lines2)   % to every other line
        for k = 1:length(lines2{i}(:,1))-1         % Compare all segments in each line
            for kk = 1:length(lines2{j}(:,1))-1    % To all segments in the other lines
                
                [iflag ipoint] = segment_intersect(lines2{i}(k:k+1,:),lines2{j}(kk:kk+1,:),0);
                if iflag == 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% This finds an intersection for the simplified lines,
%%%%%%%%%%%%%%%%%%%%%% but a refinement is required in order to find the
%%%%%%%%%%%%%%%%%%%%%% true intersection
                    
                   intersect_mat(i,j) = iflag;
                   intersect_mat(j,i) = iflag;

%%%%%%%%%%%%%%%%%%%%%% We need to find the nearest points to the purported
%%%%%%%%%%%%%%%%%%%%%% intersection along the original lines:

                    indi = find_nearest_xy(lines{i},ipoint);
                    if indi == length(lines{i}(:,1))
                        indi = indi-1;
                    end

                    indj = find_nearest_xy(lines{j},ipoint);
                    if indj == length(lines{j}(:,1))
                        indj = indj-1;
                    end

                    midii1 = indi; midii2 = indi;
                    midjj1 = indj; midjj2 = indj;
                    
                    iflag2 = 0; % Identifies the intersect segment
                    search_range = 0;

                    while iflag2 ~= 1
                        
                        startii = max([1 indi-search_range]);
                        endii = min([indi+search_range length(lines{i}(:,1))-1]);
                        startjj = max([1 indj-search_range]);
                        endjj = min([indj+search_range length(lines{j}(:,1))-1]);

                        iirange = [startii:endii];
                        jjrange = [startjj:endjj];
                        for ii = iirange
                            for jj = jjrange
                                [iflag2 ipoint2] = segment_intersect(lines{i}(ii:ii+1,:),lines{j}(jj:jj+1,:),0);

                                if iflag2 == 1
                                    intersect_point{i,j} = ipoint2;
                                    intersect_point{j,i} = ipoint2; 
                                   
                                    intersect_ind{i,j} = [ii ii+1; jj jj+1];
                                    intersect_ind{j,i} = [jj jj+1; ii ii+1];
                                    break
                                end
                            end
                            if iflag2 == 1
                                break
                            end
                        end 
                        search_range = search_range+5;
                        if search_range > 200
                                %disp(['Refinement Failed - ',num2str(i),',',num2str(j)])
                                intersect_mat(i,j) = 0;
                                intersect_mat(j,i) = 0;
                                break
                                
                            keyboard
                             
                            plot(lines{i}(:,1),lines{i}(:,2),'Color','red')
                            hold all
                            plot(lines{j}(:,1),lines{j}(:,2),'Color','blue')
                            plot(lines{i}(iirange,1),lines{i}(iirange,2),'Color','red','LineWidth',2)
                            plot(lines{j}(jjrange,1),lines{j}(jjrange,2),'Color','blue','LineWidth',2)

                        end
                    end
                    break 
                end
            end
            if iflag == 1
                break
            end
            
        end
    end
    disp(['Completed Line ',num2str(i),' of ',num2str(length(lines2)),' - ',num2str(sum(intersect_mat(i,:))),' intersections - ',num2str(round_to(toc,0.1)),'s'])
end

end


