function output = isnum(input)

output = 0;

isnum_ind = find(isstrprop(input,'digit') == 1);
isnotnum_ind = find(isstrprop(input,'digit') == 0);

if length(isnotnum_ind) == 1
    if input(isnotnum_ind) == '.' | input(isnotnum_ind) == '-'
        output = 1;
    end
end

if length(isnotnum_ind) == 2
    if input(isnotnum_ind(1)) == '.' | input(isnotnum_ind(1)) == '-'
        if input(isnotnum_ind(2)) == '.' | input(isnotnum_ind(2)) == '-'
            output = 1;
        end
    end
end

if length(isnum_ind) > 0 & length(isnotnum_ind) == 0
    output = 1;
end