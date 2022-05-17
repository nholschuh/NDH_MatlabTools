function output = round_to(input,rt_value)
%% Rounds to a prescribed degree of precision (can be any value)

scaler = 1/rt_value;
output = round(input*scaler)/scaler;

%%%%%%%%%%% There are some funny precision problems that show up here, for
%%%%%%%%%%% large rt_values. I think this shouldn't cause major problems,
%%%%%%%%%%% but check here first if it does...
if max(mod(output,rt_value)) ~= 0
    output = round(output);
end

end