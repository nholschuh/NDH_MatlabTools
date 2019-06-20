function output = running_max(input);

ss = size(input);
if ss(1) > ss(2)
    vert_flag = 1;
else
    vert_flag = 0;
end


if vert_flag == 1
    ds = diff(input,[],1);
    ds(find(ds < 0)) = 0;
    output = [input(1,:); input(1,:)+cumsum(ds)];
else
    ds = diff(input,[],2);
    ds(find(ds < 0)) = 0;
    output = [input(:,1) input(:,1)+cumsum(ds)];
end

end