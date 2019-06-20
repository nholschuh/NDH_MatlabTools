function [final] = points_within(matrix,xcol,ycol,xrange,yrange)
% Determines whether or not points are within a certain range. [xmin xmax]

counter = 1;
final2 = [];

for i = 1:length(matrix(:,1))
    if matrix(i,xcol) <= xrange(2) & matrix(i,xcol) >= xrange(1)
        if matrix(i,ycol) <= yrange(2) & matrix(i,ycol) >=yrange(1)
            final2(counter,:) = matrix(i,:);
            counter = counter+1;
        end
    end
end

final = final2;
end
