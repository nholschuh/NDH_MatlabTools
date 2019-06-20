function [squares square_mat] = find_subsquares(input);
% (C) Nick Holschuh - University of Washington - '17, (holschuh@uw.edu)
% This function is designed to take a matrix, and reduce it's complexity to
% the minimum number of perfect squares that can describe the values in the
% matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input - the input matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


%%%%%%%%%%%%%%%%%%% Flags for debugging
disp_flag = 0; %%%% Display the iteration step
debug_flag = 0;%%%% Plot the comparison matrix against the data


%%%%%%%%%%%%%%%%%%% Initiate the matrix that will be used to map in the
%%%%%%%%%%%%%%%%%%% square indecies
ms = size(input);
square_mat = zeros(ms);

%%%%%%%%%%%%%%%%%%% This is used to mitigate numerical noise that results
%%%%%%%%%%%%%%%%%%% from the convolution
min_ord = min_order(input)-3;

max_sq = min(ms);
if mod(max_sq,2) == 0
    max_sq = max_sq-1;
end

counter = 1;

if disp_flag == 1
    disp(['Total number of search sizes = ',num2str(length(1:2:max_sq))])
    tic
end


%%%%%%%%%%%%%%%%% Deal with NaN's, which ruin the convolution
input(isnan(input)) = 9999;

for i = 1:2:max_sq;
    
    
    %%%%%%%%%%%%% Convolve the original matrix with a filter of all
    %%%%%%%%%%%%% possible sizes, to figure out if the average value over a
    %%%%%%%%%%%%% square area is the same as the value
    output = conv2(input,ones(max_sq+1-i)/(max_sq+1-i)^2,'same');
    output = round_to(output,10^min_ord);
    [xinds yinds] = find(output == input);
    
    spacer = (max_sq-i)/2;

    %%%%%%%%%%%%% Debug area
    if debug_flag == 1
        if i > 151
            keyboard
        end
        imagesc(input-output)
        colormap(b2r2(-0.001,0.001))
    end
    
    
    %%%%%%%%%%%% Loop through the matrix cells that are found to be the
    %%%%%%%%%%%% same as their regional average
    for j = 1:length(xinds)
        xrange = xinds(j)-spacer:xinds(j)+spacer;
        yrange = yinds(j)-spacer:yinds(j)+spacer;
        
        %%%%%%%%%%%% Make sure the average was computed over a full square
        %%%%%%%%%%%% within the domain
        if min(xrange) > 0 & max(xrange) <= ms(1) & min(yrange) > 0 & max(yrange) <= ms(2)
            
            %%%%%%%%%%%% Make sure that no part of this square already got
            %%%%%%%%%%%% filled by a previous square of this size
            sample = square_mat(xrange,yrange);
            if max(max(sample)) == 0
                square_mat(xrange,yrange) = counter;
                squares(counter).boundary = [xinds(j)-spacer yinds(j)-spacer; xinds(j)+spacer yinds(j)+spacer];
                squares(counter).ind = [xinds(j) yinds(j)];
                squares(counter).val = input(xinds(j),yinds(j));
                input(xrange,yrange) = rand(1)*10000;
                counter = counter+1;
            end
        end
    end
    
    if disp_flag == 1 & mod(i,11) == 0
        disp(['------ Completed size ',num2str(max_sq+1-i),': ',num2str(round_to(toc,0.1)),'s, Number of squares - ',num2str(length(squares))]);
    end
        
    
end
    
    