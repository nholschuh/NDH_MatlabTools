LastDir = pwd;

if exist([OnePath,'Proposals'],'dir') == 7
		cd_string = ['cd ''',OnePath,'Proposals'''];
        eval(cd_string)
        clearvars cd_string
end



