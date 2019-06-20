function GZplot(GZ,index,xmin,xmax,ymin,ymax)

% Plots grounding zone data (GZ) for either the grounding line (index = 1)
% flexure point (2) or the other things (3)
counter = 0 ;


for i = 1:length(GZ)
    if GZ(i,4) == index
        counter = counter+1;
        if counter == 1
            pinit = i;
        end
    end
end
    
if max(abs(GZ(:,2))) <= 90
    [x,y] = polarstereo_fwd(GZ(pinit:(pinit+counter),2),GZ(pinit:(pinit+counter),1));
else
    x = GZ(pinit:(pinit+counter),2);
    y = GZ(pinit:(pinit+counter),1);
end

if exist('xmin','var') == 0
    xmin = min(x);
end
if exist('xmax','var') == 0
    xmax = max(x);
end
if exist('ymin','var') == 0
    ymin = min(y);
end
if exist('ymax','var') == 0
    ymax = max(y);
end

counter = 1
for i = 1:length(x)
    if x(i) > xmin
        if x(i) < xmax
            if y(i) > ymin
                if y(i) < ymax
                    mat(counter,:) = [x(i) y(i)];
                    counter = counter+1;
                end
            end
        end
    end
end

mattest = distance_sorter(mat,1,2);

final = mattest;

plot(final(:,1),final(:,2),'Color','black')
end
