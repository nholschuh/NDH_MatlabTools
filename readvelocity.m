function [vx,vy,x_axis,y_axis]= readvelocity(rootname)
% (C) Ian Joughin - University of Washington - 2016 
% -------------- Modified by Nick Holschuh - 2016 (nick.holschuh@gmail.com)
% Designed to read in velocity data produced by Ian Joughin, and output the
% velocity components and the axes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% rootname - the name of the velocity file without any extensions
%            (this reads ##.vx, ##.vy, ##.vx.geodat, ##.vy.geodat
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% vx - the horizontal velocity vector in m/a
% vy - the vertical velocity vector in m/a
% x_axis - the positions of the centers of the velocity cells
% y_axis - the positions of the centers of the velocity cells
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% (none)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get geodat info
%
xd=readgeodat(strcat(rootname,'.vx.geodat'));
%
% Vx component
%
fid = fopen(strcat(rootname,'.vx'),'r','ieee-be');
[vx,count]=fread(fid,[xd(1,1) xd(1,2)],'float32');
fclose(fid);
%
% Vy component
%
fid = fopen(strcat(rootname,'.vy'),'r','ieee-be');
[vy,count]=fread(fid,[xd(1,1) xd(1,2)],'float32');
fclose(fid);

vx = vx';
vy = vy';

x_axis = [0:xd(1,1)-1]*xd(2,1)+xd(3,1)*1000;
y_axis = [0:xd(1,2)-1]*xd(2,2)+xd(3,2)*1000;


end

%
% Read a geodat file
%
function xgeo=readgeodat(filein)
fid = fopen(filein,'r');
xgeo=zeros(3,2);
i=1;
while ~feof(fid),
  line=fgets(fid);
  [A,count]=sscanf(line,'%f %f',[1 2]);
  if(count == 2) 
     xgeo(i,:)=A;
     i=i+1;
  end
end
fclose(fid);

end