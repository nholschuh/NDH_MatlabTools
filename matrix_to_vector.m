function [outvec matsize] = matrix_to_vector(data,horiz0_or_vert1,by_cols_or_rows)

if exist('horiz0_or_vert1') == 0
    horiz0_or_vert1 = 1;
end
if exist('by_cols_or_rows') == 0
    by_cols_or_rows = 0;
end

matsize = size(data);

if by_cols_or_rows == 1
    data = data';
end

if horiz0_or_vert1 == 1;
    outvec = reshape(data,prod(matsize),1);
elseif horiz0_or_vert1 == 0;
    outvec = reshape(data,1,prod(matsize));
end
end