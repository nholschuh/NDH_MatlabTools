function select_grid(grid1,name)
% Extracts a grid covering the selected region in grid 1. For some reason
% this only works if the sub-set region is produced in a clockwise fashion.

plotnum = 1;

grdplot(grid1,1)
hold all

[gridx gridy gridz] = grdread(grid1);

xspacing = abs(gridx(1)-gridx(2));
yspacing = abs(gridy(1)-gridy(2));

gridvec = zeros(length(gridx)*length(gridy),3);
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


Y = gridvec;
[result_index angles]= within_ndh(Y,1,2,X,10);

counter = 1;
for i = 1:length(result_index)
    if result_index(i) == 1
        result_ivec(counter) = i;
        counter = counter+1;
    end
end

[result] = Y(result_ivec,:);
angles = angles(result_ivec);


xind_min = min(result(:,1));
xind_max = max(result(:,1));
yind_min = min(result(:,2));
yind_max = max(result(:,2));

newgridx = xind_min:xspacing:xind_max;
xindecies = (result(:,1)-xind_min+xspacing)/xspacing;

newgridy = yind_min:yspacing:yind_max;
yindecies = (result(:,2)-yind_min+yspacing)/yspacing;

newgridz = zeros(length(newgridy),length(newgridx));
for i = 1:length(newgridy)
    for j = 1:length(newgridx)
        newgridz(i,j) = NaN;
    end
end


for i = 1:length(result)
   newgridz(yindecies(i),xindecies(i)) = result(i,3);
end

grdwrite(newgridx,newgridy,newgridz,name)

end
