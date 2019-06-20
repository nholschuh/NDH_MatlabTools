function keep = find_continuous(input,method)
%%%%% This function finds either (method == 0) the longest continuous
%%%%% section of the matrix or (method > 0) continuous sections that exceed
%%%%% a particular length.


dx = median(diff(input));

input2 = round(input/dx);

di = diff(input2);

jump_inds = [0; find(di > 1); length(input2)];
gap_between_jumps = diff(jump_inds);


if method == 0
    keep = find(max(gap_between_jumps));
    keep = jump_inds(keep)+1:jump_inds(keep+1);

else
    keep_2 = find(gap_between_jumps > method);

    
    keep = [];
    for j = 1:length(keep_2)
        keep3 = jump_inds(keep_2(j))+1:jump_inds(keep_2(j)+1);
        
        keep = [keep keep3];
    end
end


