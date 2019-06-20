function quiver_point(xs,ys,us,vs)

for i = 1:length(xs)
    quiver(xs(i),ys(i),us(i),vs(i),'Color','blue')
end