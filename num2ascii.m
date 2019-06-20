function output = num2ascii(input)
% Takes a vector filled with integers and converts them to ascii text:

output = [];
for i = 1:length(input)
    output = [output sprintf('%s',input(i))];
end