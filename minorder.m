function result = minorder(val)
% Finds the minimum order present in the data
%%
start_order = order(val);
result = start_order;
val_temp = val/10^start_order;

while mod(val_temp,1) > 0.0001 && 1-mod(val_temp,1) > 0.0001
    mod(val_temp,1)
    val_temp = val_temp*10
    pause(1)
    result = result-1;
end

end
    
