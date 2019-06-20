LastDir = pwd;

if exist([OnePath,'Research_Projects']) == 7
		cd_string = ['cd ''',OnePath,'Research_Projects'''];
        eval(cd_string)
        clearvars cd_string
end

