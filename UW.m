LastDir = pwd;

if exist(OnePath,'dir') == 7
        dir1 = ['''',OnePath,'UW_1st_Year\'''];
        num = input(sprintf('1 - UW 1st Year\n'));
        
        loadstring = ['cd ',eval(['dir',num2str(num)])];
        eval(loadstring)
end

clear dir1 dir2 dir3 dir4 dir5 num loadstring

