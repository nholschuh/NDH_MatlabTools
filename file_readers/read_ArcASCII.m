function [x y z] = read_ArcASCII(filename)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This function reads in ArcASCII (or ESRI) grids. This was originally
% written to read in Daniel Shapiro's basal shear-stress output grids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - string containing the relative or full path to the file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%
% x - vector containing the coordinates for cell centers of the columns
% y - vector containing the coordinates for cell centers of the rows
% z - matrix containing the data field for the grid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%%%%%% Read the header information
formatSpec = '%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
hvals = textscan(fileID, formatSpec, 6, 'Delimiter',' ', 'MultipleDelimsAsOne', true, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
hvals = hvals{1};

%%%%% hvals has the structure
%%%%%%%%%% (1) number of columns
%%%%%%%%%% (2) number of rows
%%%%%%%%%% (3) X - lower left cell corner
%%%%%%%%%% (4) Y - lower left cell corner
%%%%%%%%%% (5) cell width
%%%%%%%%%% (6) NaN Value
% (Remember, matlab coordinates are for cell center, not corner)

z = dlmread(filename,' ',6,0);
z(find(z == hvals(6))) = NaN;
z = flipud(z);

if hvals(1) ~= length(z(1,:))
    disp(['The number of data columns does not match the stated number - forcing fit'])
    hvals(1) = length(z(1,:));
end

if hvals(2) ~= length(z(:,1))
    disp(['The number of data rows does not match the stated number - forcing fit'])
    hvals(2) = length(z(:,1));
end

x = hvals(3)-hvals(5)/2 + (1:hvals(1))*hvals(5);
y = hvals(4)-hvals(5)/2 + (1:hvals(2))*hvals(5);

end

