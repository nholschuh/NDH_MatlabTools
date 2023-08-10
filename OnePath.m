function output = OnePath();

if exist('C:/Users/nick/OneDrive/Matlab_Code/NDH_Tools','dir') == 7
     output = 'C:/Users/nick/OneDrive/';
elseif exist('C:/Users/Nick/Google Drive/Matlab_Code/') == 7
    output = 'C:/Users/Nick/Google Drive/';
elseif exist('C:/Users/nickh/Google_Drive2/Matlab_Code/') == 7
    output = 'C:/Users/nickh/Google_Drive2/';
elseif exist('C:/Users/Nick/Google_Drive2/Matlab_Code/') == 7
    output = 'C:/Users/Nick/Google_Drive2/';
elseif exist('D:/Users/Nick/Google_Drive2/Matlab_Code/') == 7
    output = 'D:/Users/Nick/Google_Drive2/';
elseif exist('D:/Users/Nick/Google_Drive/Matlab_Code/') == 7
    output = 'D:/Users/Nick/Google_Drive/';
elseif exist('C:/Users/nickh/Google_Drive/Matlab_Code/') == 7
    output = 'C:/Users/nickh/Google_Drive/';
elseif exist('G:/My Drive/Matlab_Code/') == 7
    output = 'G:/My Drive/';
elseif exist('/users/nholschuh/Matlab_Code/') == 7
	output = '/users/nholschuh/';
elseif exist('/Users/Lionheart/OneDrive/Matlab_Code/NDH_Tools','dir') == 7
	output = '/Users/Lionheart/OneDrive/Matlab_Code/NDH_Tools';
elseif exist('/data/rd00/Users/holschuh/Matlab_Code/') == 7
    output = '/data/rd00/Users/holschuh/';
elseif exist('/mnt/NDH_data/Google_Drive2/Matlab_Code/') == 7
    output = '/mnt/NDH_data/Google_Drive2/';
else
    output = [];
end
