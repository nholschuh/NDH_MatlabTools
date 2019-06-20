function outputmat = rgb_scaling(inputmat,start_end_percentage)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Rescales values in an rgb matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inputmat - 
% start_end_percentage - either a 1 value vector (how much to trim from
%       start and end), a 2 value vector (with the amount to trim off the 
%       top and bottom), or a 2x3 matrix with start and end values for each
%       band.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outputmat - the output data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

mins(1) = min(min(inputmat(:,:,1)));
mins(2) = min(min(inputmat(:,:,2)));
mins(3) = min(min(inputmat(:,:,3)));

maxs(1) = max(max(inputmat(:,:,1)));
maxs(2) = max(max(inputmat(:,:,2)));
maxs(3) = max(max(inputmat(:,:,3)));


if min(size(start_end_percentage)) == 1
    if length(start_end_percentage) == 1
        for i = 1:3
            minval(i) = (maxs(i)-mins(i))*start_end_percentage+mins(i);
            maxval(i) = maxs(i)-(maxs(i)-mins(i))*start_end_percentage;
        end        
    elseif length(start_end_percentage) == 2
        for i = 1:3
            minval(i) = (maxs(i)-mins(i))*start_end_percentage(1)+mins(i);
            maxval(i) = maxs(i)-(maxs(i)-mins(i))*start_end_percentage(2);
        end         
    end
elseif min(size(start_end_percentage)) == 2
    for i = 1:3
        minval(i) = (maxs(i)-mins(i))*start_end_percentage(1,i)+mins(i);
        maxval(i) = maxs(i)-(maxs(i)-mins(i))*start_end_percentage(2,i);
    end
end


for i = 1:3
    tempmat = inputmat(:,:,i)-minval(i);
    tempmat(find(tempmat <= 0)) = 0;
    tempmat(find(tempmat >= maxval(i)-minval(i))) = maxval(i)-minval(i);
    tempmat = tempmat/(maxval(i)-minval(i));
    
    outputmat(:,:,i) = tempmat;    
end
    
    
    
end

