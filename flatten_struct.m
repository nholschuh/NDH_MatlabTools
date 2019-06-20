function output = flatten_struct(input)

    output = input(1);
    fds = fields(input);
    file_index = eval(['ones(size(input(1).',fds{1},'));']);
    for i = 2:length(input)
        
        for j = 1:length(fds)
            s1 = eval(['size(output.',fds{j},');']);
            s2 = eval(['size(input(i).',fds{j},');']);

            %%% This handles a case where the variable sizes aren't equal.
            %%% The code then just concatenates the last column of each
            %%% data set.
            if s1(2) ~= s2(2) & s1(1) ~= s2(1)
                add_string = ['output.',fds{j},' = [output.',fds{j},'(:,end); input(i).',fds{j},'(:,end)];'];
                eval(add_string);
            elseif s1(2) == s2(2)
                add_string = ['output.',fds{j},' = [output.',fds{j},'; input(i).',fds{j},'];'];
                eval(add_string);
            end
        end
        file_index = [file_index; eval(['ones(size(input(1).',fds{1},'));'])];
        
    end
