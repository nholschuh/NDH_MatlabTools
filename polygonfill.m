function [a b border] = polygonfill(X,resolution,Y)
% Determine lattice points to grid the interior of a two dimensional
% polygon, defined by the vertices X containing two column vectors.
% Resolution defines the resolution of the grid, and Y is a vector of
% forced points if desired. a is a 3 column matrix of values with
% coordinates, b is a matrix containing the z values, and border is a
% vector containing coordinates and the values of the reference grid Y on
% the outer margins of the polygon.

% The code starts by defining functions to describe the polygon edges

linenum = length(X(:,1));
linedata = zeros(linenum,2);

for i = 1:(linenum)
    temp = zeros(2,2);
    if i < linenum
        temp(1,:) = [X(i,1) X(i,2)];
        temp(2,:) = [X(i+1,1) X(i+1,2)];
    end
    if i == linenum
        temp(1,:) = [X(i,1) X(i,2)];
        temp(2,:) = [X(1,1) X(1,2)] ;
    end
    [linedata(i,1) linedata(i,2)] = slopeintercept(temp(1,:),temp(2,:));
end

% This defines a central point that is used to determine which side of each
% face is within the polygon.

meanpoint = [mean(X(:,1)) mean(X(:,2))];

maxX = max(X(:,1));
minX = min(X(:,1));
maxY = max(X(:,2));
minY = min(X(:,2));

gtlt = zeros(1,1);

% gtlt defines an index for each line, showing which side of the line is
% 'inside' the polygon

for i = 1:linenum
    if linedata(i,1) == inf
        if meanpoint(1) > linedata(i,2)
            gtlt(i) = 1;
        else
            gtlt(i) = -1;
        end
    else
        if meanpoint(2) < linedata(i,1)*meanpoint(1)+linedata(i,2)
            gtlt(i) = -1;
        else
            gtlt(i) = 1;
        end
    end
end

% If a reference grid isn't provided, this section defines a regular grid
% that will be pared down to what is within the polygon

if exist('Y') == 0
    xgridnum = floor((maxX - minX)/resolution);
    ygridnum = floor((maxY - minY)/resolution);
    gridmatrix = ones(xgridnum,ygridnum);
    
    grida = zeros(xgridnum*ygridnum,2);
    
    for i = 1:xgridnum
        for j = 1:ygridnum
            grida(((i-1)*ygridnum+j),1) = minX + resolution*i;
            grida(((i-1)*ygridnum+j),2) = minY + resolution*j;
        end
    end
else
    resolution = max([abs(Y(1,1)-Y(2,1)) abs(Y(1,2)-Y(2,2))]);
end




counter = 1;
newgrid = [];


if exist('Y') == 1
    for i = 1:length(Y(:,1))
        temp = zeros(1,length(gtlt));
        for j = 1:length(gtlt)
            if linedata(j,1) == Inf
                if Y(i,1) > linedata(j,2)
                    temp(j) = gtlt(j)*1;
                else
                    temp(j) = gtlt(j)*-1;
                end
            else
                temp(j) = gtlt(j)*sign(Y(i,2) - (linedata(j,1)*Y(i,1)+linedata(j,2)));
            end
        end
        if sum(temp) == length(gtlt)
            newgrid(counter,:) = Y(i,:);
            counter = counter+1;
        end
    end
else
    for i = 1:length(grida(:,1))
        temp = zeros(1,length(gtlt));
        for j = 1:length(gtlt)
            if linedata(j,1) == Inf
                if grida(i,1) > linedata(j,2)
                    temp(j) = gtlt(j)*1;
                else
                    temp(j) = gtlt(j)*-1;
                end
            else
                temp(j) = gtlt(j)*sign(grida(i,2) - (linedata(j,1)*grida(i,1)+linedata(j,2)));
            end
        end
        if sum(temp) == length(gtlt)
            newgrid(counter,:) = grida(i,:);
            gridmatrix(i) = sum(temp);
            counter = counter+1;
        else
            gridmatrix(i) = NaN;
        end
%         if mod(counter,1000) == 0
%             counter
%         end
    end
end

% If there is a reference grid provided, this section determines the values
% at each of the points in the outside border.

bordertemp = [];
counter = 1;

if exist('Y') == 1
    for i = 1:length(newgrid(:,1))
        [q w] = ClosestPoint(newgrid(i,:),newgrid(setxor(1:length(newgrid(:,1)),i),:),resolution*1.3);
        if length(w(:,1)) < 4
            bordertemp(counter,:) = newgrid(i,:);
            counter = counter+1;
        end
    end
    gridmatrix = 'add later';
end


a = newgrid;

b = gridmatrix;

border = bordertemp;

end


       

       

            

        

