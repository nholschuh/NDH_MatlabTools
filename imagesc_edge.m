function output = imagesc_edge(x,y,C)
%% Plots an image based on cell boundaries in x and y
% Test Values for debugging
% x = [0 1];
% y = [0 0.1 0.2 0.6];
% C = [1;2;3];

dx = min(x(2:end)-x(1:end-1));
dy = min(y(2:end)-y(1:end-1));

xspace = 10^minorder(dx);
yspace = 10^minorder(dy);

xaxis = (min(x)+xspace/2):xspace:(max(x)-xspace/2);
yaxis = (min(y)+yspace/2):yspace:(max(y)-yspace/2);

ctemp = zeros(length(yaxis),length(xaxis));

for i = 1:length(yaxis)
    for j = 1:length(xaxis)
        cx_ind = find(x > xaxis(j));
        cx_ind = cx_ind(1)-1;
        cy_ind = find(y > yaxis(i));
        cy_ind = cy_ind(1)-1;
        
        ctemp(i,j) = C(cy_ind,cx_ind);
    end
end

imagesc(xaxis,yaxis,ctemp);

end
        
