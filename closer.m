function outflag = closer(val,end1,end2);

if abs(val-end1) > abs(val-end2)
    outflag = 2;
else
    outflag = 1;
end

