function indrange = find_overlap(in1,in2)
    fi = find_nearest(in1,in2(1));
    li = find_nearest(in1,in2(end));
    
    if fi > li
        indrange = [li:fi]
    else
        indrange = [fi:li]
    end
    