


LastDir = pwd;
drive_letters = getdrives;
input_string = [];
for i = 1:length(drive_letters);
    if i < length(drive_letters)
        input_string = sprintf([input_string,num2str(i),' - ',drive_letters{i},'\n']);
    else
        input_string = sprintf([input_string,num2str(i),' - ',drive_letters{i},'\n..']);
    end
end
num = input(input_string);


cd(drive_letters{num})

clear dir1 dir2 num