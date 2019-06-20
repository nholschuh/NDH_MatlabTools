function shapewrite_ndh(x,y,filename,stereo0_or_latlon1);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function writes a shapefile (polygon')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inp1 - 
% inp2 - 
% inp3 - 
% inp4 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
% out2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('stereo0_or_latlon1') == 0
    stereo0_or_latlon1 = 0;
end

%%%%%%%%%%% Another option is line or point, but we use polygon here
if stereo0_or_latlon1 == 0
    if length(x) == 1
        S = mapshape(x,y,'Geometry','point','Name','point');
    else
        S = mapshape(x,y,'Geometry','polygon','Name','polygon');
    end
elseif stereo0_or_latlon1 == 1
    if length(x) == 1
        S = geoshape(x,y,'Geometry','point','Name','point');
    else
        S = geoshape(x,y,'Geometry','polygon','Name','polygon');
    end
end

dbfspec = makedbfspec(S);
shapewrite(S,filename,'DbfSpec',dbfspec);

