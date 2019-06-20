function output = find_num_in_str(input);
%% Finds all numbers contained in a strung

cont_num = 0;
val_counter = 1;
output = [];

for i = 1:length(input)
    
    if cont_num == 0
        if isstrprop(input(i),'digit')
            start_val = input(i);
            cont_num = 1;
        end
    elseif cont_num == 1
        if isstrprop(input(i),'digit') | input(i) == '.'
            start_val = [start_val input(i)];
            cont_num = 1;
            
            if i == length(input)
                output(val_counter) = eval(start_val);
            end
        else
            output(val_counter) = eval(start_val);
            val_counter = val_counter+1;
            cont_num = 0;
        end
    end
    
end


end