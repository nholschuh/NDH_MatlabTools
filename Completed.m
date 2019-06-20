LastDir = pwd;

if exist('C:\Users\Nick\OneDrive\Completed_Projects','dir') == 7
		 cd C:\Users\Nick\OneDrive\Completed_Projects
end
if exist('/Users/Lionheart/OneDrive/Completed_Projects','dir') == 7
		 cd /Users/Lionheart/OneDrive/Completed_Projects
end
if exist([OnePath,'Completed_Projects'],'dir') == 7
    cd([OnePath,'Completed_Projects']);
end