function [image,xaxis,yaxis,p,t]=enviread(fname);

% enviread          	- read envi image (V. Guissard, Apr 29 2004)
%                       - modified (N. Holschuh, 11/7/2012)
%
% 				Reads an image of ENVI standard type 
%				to a [col x line x band] MATLAB array
%
% SYNTAX
%
% image=enviread(fname)
% [image,p]=enviread(fname)
% [image,p,t]=enviread(fname)
%
% INPUT :
%
% fname	string	giving the full pathname of the ENVI image to read.
%
% OUTPUT :
%
% image	c by l by b array containing the ENVI image values organised in
%				c : cols, l : lines and b : bands.
% p		1 by 3	vector that contains (1) the nb of cols, (2) the number.
%				of lines and (3) the number of bands of the opened image.
%
% t		string	describing the image data type string in MATLAB conventions.
%
% NOTE : 			enviread needs the corresponding image header file generated
%				automatically by ENVI. The ENVI header file must have the same name
%				as the ENVI image file + the '.hdf' exention.
%
%%%%%%%%%%%%%

% Parameters initialization
elements={'samples ' 'lines   ' 'bands   ' 'data type ' 'map info '};
d={'bit8' 'int16' 'int32' 'float32' 'float64' 'uint16' 'uint32' 'int64' 'uint64'};
% Check user input
if ~ischar(fname)
    error('fname should be a char string');
end


% Open ENVI header file to retreive s, l, b & d variables
rfid = fopen(strcat(fname,'.hdr'),'r');

% Check if the header file is correctely open
if rfid == -1
    error('Input header file does not exist');
end;

% Read ENVI image header file and get p(1) : nb samples,
% p(2) : nb lines, p(3) : nb bands and t : data type
while 1
    tline = fgetl(rfid);
    if ~ischar(tline), break, end
    [first,second]=strtok(tline,'=');
    
    switch first
        case elements(1)
            [f,s]=strtok(second);
            p(1)=str2num(s);
        case elements(2)
            [f,s]=strtok(second);
            p(2)=str2num(s);
        case elements(3)
            [f,s]=strtok(second);
            p(3)=str2num(s);
        case elements(4)
            [f,s]=strtok(second);
            t=str2num(s);
            switch t
                case 1
                    t=d(1);
                case 2
                    t=d(2);
                case 3
                    t=d(3);
                case 4
                    t=d(4);
                case 5
                    t=d(5);
                case 12
                    t=d(6);
                case 13
                    t=d(7);
                case 14
                    t=d(8);
                case 15
                    t=d(9);
                otherwise
                    error('Unknown image data type');
            end
        case elements(5)
            [f,s]=strtok(second);
            vals = regexp(s, '([^,]*)', 'match');
            minx = str2num(cell2mat(vals(4)));
            maxy = str2num(cell2mat(vals(5)));
            xspacing = str2num(cell2mat(vals(6)));
            yspacing = str2num(cell2mat(vals(7)));
    end
end
fclose(rfid);

t=t{1,1};
% Open the ENVI image and store it in the 'image' MATLAB array
disp([('Opening '),(num2str(p(1))),('cols x '),(num2str(p(2))),('lines x '),(num2str(p(3))),('bands')]);
disp([('of type '), (t), (' image...')]);
fid=fopen(fname);
image=fread(fid,t);
image=reshape(image,[p(1),p(2),p(3)]);
image = flipud(image');
xlength = length(image(1,:));
ylength = length(image(:,1));
xaxis = minx:xspacing:(minx+xspacing*xlength-xspacing);
yaxis = (maxy-yspacing*ylength+yspacing):yspacing:maxy;
fclose(fid);
%disp([('Image data type : '),(t)])

end