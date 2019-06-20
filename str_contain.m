function [result index] = str_contain(str1,str2)
% Determines whether or not str1 contains str2;

loops = length(str1) - length(str2) + 1;
if loops < 1
    result = 0;
    index = NaN;
else

    for i = 1:loops
        temp(i) = strcmp(str1(i:(i+length(str2)-1)),str2);
    end
    
    result = max(temp);
    if result == 1
        [trash index_temp] = find(max(temp)==temp);
        index = [index_temp index_temp+length(str2)-1];
    else
        index = NaN;
    end
end