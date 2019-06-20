function outmat = vector_to_matrix(data,matsize,by_cols_or_rows);

if exist('by_cols_or_rows') == 0
    by_cols_or_rows = 0;
end

outmat = reshape(data,matsize);

if by_cols_or_rows == 1
    outmat = outmat';
end