function grdNaN(grid1,outputname)
%Replaces values in the provided grid with NaN's based on a selected
%region.


plotnum = 1;

grdplot(grid1,1)
hold all

[gridx gridy gridz] = grdread(grid1);

xspacing = abs(gridx(1)-gridx(2));
yspacing = abs(gridy(1)-gridy(2));

gridvec = zeros(length(gridx)*length(gridy),5);
for i = 1:length(gridx)
    for j = 1:length(gridy)
        gridvec((i-1)*length(gridy)+j,1) = gridx(i);
        gridvec((i-1)*length(gridy)+j,2) = gridy(j);
        gridvec((i-1)*length(gridy)+j,3) = gridz(j,i);
        gridvec((i-1)*length(gridy)+j,4) = i;
        gridvec((i-1)*length(gridy)+j,5) = j;
    end
end



 
   xmin = min(gridx);
   xmax = max(gridx);
   ymin = min(gridy);
   ymax = max(gridy);

   
   xrange = xmax-xmin;
   yrange = ymax-ymin;
      
   zoominfactor =  .4;                   %Value between 0-1
   zoomoutfactor = 1/zoominfactor;

contour_storage = [];

i = 1;
start = 1;
temp = zeros(1,3);

while i == 1
    temp = zeros(1,3);
    [temp(1),temp(2),temp(3)] = ginput(1);
    contour_storage(i,:) = temp;
    ContourPicker_KeyFunctions;      %Tool set for zooming, next line
    i = i+1;
end
if i > 1
    while contour_storage(i-1,3) ~= 113
        if contour_storage(i-1,3) == 110
            contour_storage(i-1,:) = [0 0 10];
            start = i;
        end
       
        temp = zeros(1,3);
        [temp(1),temp(2),temp(3)] = ginput(1);
        contour_storage(i,:) = temp;

        ContourPicker_KeyFunctions;
        
        i = i+1;
    end
end


close all
pause(1)


X = contour_storage((1:length(contour_storage(:,1))-2),:);

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


for i = 1:length(gridx)
    if exist('cutoffx1') == 0
        if gridx(i) < minX
            cutoffx1 = i;
        end
    end
    if gridx(i) > maxX
        cutoffx2 = i;
    break
    end
end


Y = gridvec;
result = [];

if exist('cutoffx1') == 0
    cutoffx1 = 1;
end

if exist('cutoffx2') == 0
    cutoffx2 = length(gridx);
end

Y = Y(((cutoffx1-1)*length(gridy)+1):((cutoffx2-1)*length(gridy)+1),:);
    
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


counter = 1;
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
        result(counter,:) = Y(i,:);
        counter = counter+1;
    end
end

for i = 1:length(result)
    if isnan(result(i,3)) == 0
        gridz(result(i,5),result(i,4)) = NaN;
    end
end

grdwrite(gridx,gridy,gridz,outputname)
end

