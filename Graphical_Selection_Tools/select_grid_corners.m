function grdextract(grid1,name)
%allows you to subset a dataset based on drawn value boundaries

[xvec yvec zvec] = grdread(grid1);


figure1 = figure(1);
imagesc(xvec,yvec,zvec)
set(gca,'YDir','Normal')
hold all

vertices = graphical_selection(1);

newdata = [];
counter = 1;

maxx = max(vertices(:,1));
minx = min(vertices(:,1));
maxy = max(vertices(:,2));
miny = min(vertices(:,2));


xvecfinal = [];
xvecindex = [];
yvecfinal = [];
yvecindex = [];

counter = 1;
hold off

for i = 1:length(xvec)
    if xvec(i) <= maxx & xvec(i) >= minx
        xvecfinal(counter) = xvec(i);
        xvecindex(counter) = i;
        counter = counter+1;
    end
end

counter = 1;

for i = 1:length(yvec)
    if yvec(i) <= maxy & yvec(i) >= miny
        yvecfinal(counter) = yvec(i);
        yvecindex(counter) = i;
        counter = counter+1;
    end
end

Data = zvec(yvecindex,xvecindex);


x = xvecfinal;
y = yvecfinal;
z = Data;


imagesc(x,y,z);
set(gca,'YDir','Normal')

grdwrite(x,y,z,name)

end
