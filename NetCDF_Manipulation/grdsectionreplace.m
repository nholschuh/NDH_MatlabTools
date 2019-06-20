function grdsectionreplace(grid1,grid2,outputname,difference)
%% Allows an interactive selection of a region from grid1, and replaces 
%% that section with data from grid2.

grdregrid(grid2,grid1,[grid2 '_regridded']);
grid2 = [grid2 '_regridded'];


if exist('difference') == 0
    difference = 0;
end

if difference == 0
    plotnum = 2;
    subplot(1,2,1)
    grdplot(grid1)
    c_info = get(gca,'CLim');
    hold all
    subplot(1,2,2)
    grdplot(grid2)
    caxis(c_info)
    hold all
    [gridx gridy gridz] = grdread(grid1);
else
    plotnum = 2;
    subplot(1,2,1)
    grdmath(grid1,grid2,2,'temp.nc')
    grdplot('temp.nc')
    [gridx gridy gridz] = grdread(grid1);
    c_info = get(gca,'CLim');
    caxis([max(abs(c_info))*-1 max(abs(c_info))]);
        hold all
    subplot(1,2,2)
    grdplot(grid1)
        hold all
end

[gridx gridy gridz] = grdread(grid1);


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



 
   xmin = min(gridx)
   xmax = max(gridx);
   ymin = min(gridy);
   ymax = max(gridy);

   xrange = xmax-xmin
   yrange = ymax-ymin;
   
   zoominfactor =  .8;                   %Value between 0-1
   zoomoutfactor = 1/zoominfactor;

contour_storage = [];

i = 1;
start = 1;
temp = zeros(1,3);

while i == 1
    temp = zeros(1,3);
    [temp(1),temp(2),temp(3)] = ginput(1);
    contour_storage(i,:) = temp;
    ContourPicker_KeyFunctions      %Tool set for zooming, next line
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

[yes_no] = within(xy,1,2,X,1);
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

result2 = grdsearch(result,grid2);

for i = 1:length(result)
    if isnan(result2(i,1)) == 0
        gridz(result(i,5),result(i,4)) = result2(i,1);
    end
end



str1 = sprintf('%s %s','delete',grid2);

if difference == 1
    str2 = sprintf('%s %s','delete temp.nc');
    eval(str2)
end    
    

eval(str1)

grdwrite(gridx,gridy,gridz,outputname)
end

    
        

