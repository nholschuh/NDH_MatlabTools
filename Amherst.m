LastDir = pwd;

if exist([OnePath,'Amherst/'],'dir') == 7
		cd_string = ['cd ''',OnePath,'Amherst/'''];
        eval(cd_string)
        clearvars cd_string
end



