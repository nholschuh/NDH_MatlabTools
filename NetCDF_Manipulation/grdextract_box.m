function grdextract_box(grid1,name)
% Extracts a grid spanning the defined corners.

plotnum = 1;

grdplot(grid1)
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

X = contour_storage((1:length(contour_storage(:,1))-1),:);

x1 = find_nearest(gridx,min(X(:,1)));
x2 = find_nearest(gridx,max(X(:,1)));
y1 = find_nearest(gridy,min(X(:,2)));
y2 = find_nearest(gridy,max(X(:,2)));

newgridx=gridx(x1:x2);
newgridy=gridy(y1:y2);

newgridz=gridz(y1:y2,x1:x2);



grdwrite(newgridx,newgridy,newgridz,name)
