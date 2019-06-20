function output = shared_size(target_var,varlist)
%%%% Run this function by typing whos in for varlist

for i = 1:length(varlist)
    if length(varlist(i).name) == length(target_var)
        if varlist(i).name == target_var
            ts = varlist(i).size;
            break
        end
    end
end

varlist(i) = [];
counter = 1;
keep_ind = [];
for i = 1:length(varlist)
    if max(varlist(i).size(1) == ts) == 1  & varlist(i).size(1) ~= 1
        keep_ind(counter) = i;
        counter = counter+1;
    elseif max(varlist(i).size(2) == ts) == 1 & varlist(i).size(2) ~= 1
        keep_ind(counter) = i;
        counter = counter+1;
    end
end

disp(' ')
disp(['Similar Variables ------------'])
if length(keep_ind) > 0
    for i = 1:length(keep_ind)
        output{i} = varlist(i).name;
        disp(['     ',varlist(keep_ind(i)).name,'   ',num2str(varlist(keep_ind(i)).size(1)),'x',num2str(varlist(keep_ind(i)).size(2))]);
    end
else
    disp('     ''none''')
end
disp(' ')
end
