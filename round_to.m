function output = round_to(input,rt_value)
%% Rounds to a prescribed degree of precision (can be any value)

scaler = 1/rt_value;
output = round(input*scaler)/scaler;

end