function [output inds] = remove_matrix_margins_repeat(matrix,inds)
    

    xind = inds{1};
    yind = inds{2};
    
    output = matrix(min(yind):max(yind),min(xind):max(xind));


end
