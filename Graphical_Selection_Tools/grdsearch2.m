function zfinal = grdsearch2(inputvec,gridx,gridy,gridz)
% Takes all points provided in the first two columns of the inputvec and returns the value at that location in the grid. grid provided as a string containing the address of the grid file relative to the pwd.

x=inputvec(:,1);
y=inputvec(:,2);
z = zeros(length(x),1);

xmin = gridx(1);

if gridy(1) < gridy(length(gridy))
    ymin = gridy(length(1));
else
    ymin = gridy(length(gridy));
end

xspacing = abs(gridx(2)-gridx(1));
yspacing = abs(gridy(2)-gridy(1));

xsearch = x-xmin+.5*xspacing;
ysearch = y-ymin+.5*yspacing;

xsearch = floor(xsearch/xspacing)+1;

if gridy(1) < gridy(length(gridy))
    ysearch = floor(ysearch/yspacing)+1;
else
    ysearch = length(gridy) - floor(ysearch/yspacing)+1;
end


for i = 1:length(z)
    if xsearch(i) > length(gridx) | xsearch(i) < 1 | ysearch(i) > length(gridy) | ysearch(i) < 1 
        z(i) = NaN;
    else
        z(i) = gridz(ysearch(i),xsearch(i));
    end
end

zfinal = z;

