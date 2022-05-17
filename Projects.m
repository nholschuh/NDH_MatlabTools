function LastDir = Projects(proj_num);

LastDir = pwd;

if exist('proj_num') == 0
    proj_num = [];
end

if length(proj_num) == 0
    if exist([OnePath,'Research_Projects']) == 7
        cd_string = ['cd ''',OnePath,'Research_Projects'''];
        eval(cd_string)
        clearvars cd_string
    end
else
    fs = folders([OnePath,'Research_Projects/']);
    for i = 1:length(fs)
        fnum(i) = eval(fs(i).name(1:2));
    end
    
    folder_ind = find(proj_num == fnum);
    if length(folder_ind) == 0
        
    else
        cd_string = ['cd ''',OnePath,'Research_Projects/',fs(folder_ind).name,''''];
        eval(cd_string)
        clearvars cd_string
    end
end

