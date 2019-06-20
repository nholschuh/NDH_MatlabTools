function grdextract_selection(grid1,name)
% Extracts a grid covering the selected region in grid 1.

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

X = contour_storage((1:length(contour_storage(:,1))-2),:);

xy = matrix2vector(gridx,gridy,gridz);

[yes_no] = within(xy,1,2,X,10);
indexes = find(yes_no == 1);
result = xy(indexes,:);

%%%%%%%%%%%%% This is an incorrect section (but I'm not sure I can delete
%%%%%%%%%%%%% it yet, I have to make sure my fix works...)
% linenum = length(X(:,1));
% linedata = zeros(linenum,2);
% 
% for i = 1:(linenum)
%     temp = zeros(2,2);
%     if i < linenum
%         temp(1,:) = [X(i,1) X(i,2)];
%         temp(2,:) = [X(i+1,1) X(i+1,2)];
%     end
%     if i == linenum
%         temp(1,:) = [X(i,1) X(i,2)];
%         temp(2,:) = [X(1,1) X(1,2)] ;
%     end
%     [linedata(i,1) linedata(i,2)] = slopeintercept(temp(1,:),temp(2,:));
% end
% 
% % This defines a central point that is used to determine which side of each
% % face is within the polygon.
% 
% meanpoint = [mean(X(:,1)) mean(X(:,2))];
% 
% maxX = max(X(:,1));
% minX = min(X(:,1));
% maxY = max(X(:,2));
% minY = min(X(:,2));
% 
% gtlt = zeros(1,1);
% 
% % gtlt defines an index for each line, showing which side of the line is
% % 'inside' the polygon
% 
% for i = 1:linenum
%     if linedata(i,1) == inf
%         if meanpoint(1) > linedata(i,2)
%             gtlt(i) = 1;
%         else
%             gtlt(i) = -1;
%         end
%     else
%         if meanpoint(2) < linedata(i,1)*meanpoint(1)+linedata(i,2)
%             gtlt(i) = -1;
%         else
%             gtlt(i) = 1;
%         end
%     end
% end
% 
% 
% Y = gridvec;
% result = []
% 
% counter = 1;
% for i = 1:length(Y(:,1))
%     temp = zeros(1,length(gtlt));
%     for j = 1:length(gtlt)
%         if linedata(j,1) == Inf
%             if Y(i,1) > linedata(j,2)
%                 temp(j) = gtlt(j)*1;
%             else
%                 temp(j) = gtlt(j)*-1;
%             end
%         else
%             temp(j) = gtlt(j)*sign(Y(i,2) - (linedata(j,1)*Y(i,1)+linedata(j,2)));
%         end
%     end
%     if sum(temp) == length(gtlt)
%         result(counter,:) = Y(i,:);
%         counter = counter+1;
%     end
% end
% 


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
