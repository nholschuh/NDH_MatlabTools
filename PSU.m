LastDir = pwd;

if exist(OnePath,'dir') == 7
        dir1 = ['''',OnePath,'PSU_1st_Year\'''];
        dir2 = ['''',OnePath,'PSU_2nd_Year\'''];
        dir3 = ['''',OnePath,'PSU_3rd_Year\'''];
        dir4 = ['''',OnePath,'PSU_4th_Year\'''];
        dir5 = ['''',OnePath,'PSU_5th_Year\'''];
        num = input(sprintf('1 - PSU 1st Year\n2 - PSU 2nd Year\n3 - PSU 3rd Year\n4 - PSU 4th Year\n5 - PSU 5th Year\n'));
        
        loadstring = ['cd ',eval(['dir',num2str(num)])];
        eval(loadstring)
end

clear dir1 dir2 dir3 dir4 dir5 num loadstring

