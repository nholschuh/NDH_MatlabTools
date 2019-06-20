LastDir = pwd;

%num = input(sprintf('1 - Google Drive\n2 - One Drive\n '));
num = 1;

if num == 1
    dir1 = OnePath;
    dir2 = ['/Users/Lionheart/Google Drive'];
    if exist(dir1,'dir') == 7
        cd(OnePath)
    end
    if exist(dir2,'dir') == 7
        cd /Users/Lionheart/Google' Drive'
    end
elseif num == 2
    dir1 = ['C:\Users\Nick\OneDrive\'];
    dir2 = ['/Users/Lionheart/OneDrive'];
    if exist(dir1,'dir') == 7
        cd C:\Users\Nick\OneDrive\
    end
    if exist(dir2,'dir') == 7
        cd /Users/Lionheart/OneDrive
    end
end



clear dir1 dir2 num