function val = min_order(input)
% Computes the order of magnitude for the minimum significant figure

val = 0;

if mod(input,1) == 0
    while mod(input,1) == 0
        input = input/10;
        val = val+1;
    end
    val = val-1;
    
elseif  max(mod(input,1)) > 0
    while max(mod(input,1)) > 0
        input = input*10;
        val = val-1;
    end    
else
    
end

