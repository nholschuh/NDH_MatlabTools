function quiver_point(xs,ys,us,vs,scaler_opt,color_opt)
if exist('color_opt') == 0
    color_opt = 'blue';
end
if exist('scaler_opt') == 0
    scaler_opt = 1;
end
for i = 1:length(xs)
    quiver(xs(i),ys(i),us(i),vs(i),scaler_opt,'Color',color_opt)
end