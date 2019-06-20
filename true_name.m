function output = true_name(input_string)

replace_inds = find(input_string == '_' | input_string == '^');
add_vec_replace = (1:length(replace_inds))-1;
output = input_string;

for i = 1:length(replace_inds)
    output = [output(1:replace_inds(i)+add_vec_replace(i)-1),'\',output(replace_inds(i)+add_vec_replace(i):end)];
end


    
