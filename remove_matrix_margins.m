function [output inds newx newy] = remove_matrix_margins(matrix,xs,ys,pad)
    
    [yind xind] = find(matrix ~= 0);
    
    output = matrix(min(yind)-pad:max(yind)+pad,min(xind)-pad:max(xind)+pad);
    
    inds = {min(xind)-pad:max(xind)+pad,min(yind)-pad:max(yind)+pad};
    
    if exist('xs') == 1
        newx = xs(min(xind)-pad:max(xind)+pad);
        newy = ys(min(yind)-pad:max(yind)+pad);
    else
        newx = NaN;
        newy = NaN;
    end
end
