function stereonet_l(trend,plunge,rad0_deg1,symbol_type,color)
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Plots the point of a vector on an equal angle stereonet 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% trend - Horizontal trend direction (degress from N)
% plunge - Angle relative to the horizontal plane
% rad0_deg1 - 0, radians, or [1] degrees
% symbol_type - Plot symbol type
% color - Plot symbol color
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('rad0_deg1') == 0
    rad0_deg1 = 1;
end
if exist('symbol_type') == 0
    symbol_type = '.';
end
if exist('color') == 0
    color = 'black';
end


if rad0_deg1 == 1
    trend = deg2rad(trend);
    plunge = deg2rad(plunge);
end

flipinds = find(plunge < 0);
plunge(flipinds) = -plunge(flipinds);
trend(flipinds) = mod(pi+trend(flipinds),2*pi);


R = 1;
rho1 = (R.*pi/2-plunge)/(pi/2);


polarhg(trend,rho1,'tdir','ClockWise','linestyle',symbol_type,'rlim',[0 1],'rtick',[ 1/3 2/3 ],'tstep',30,'torig','Up','color',color);
hold all

set(findall(gcf, 'String', '1'),'String', ' 0^o ');
set(findall(gcf, 'String', '0.33333'),'String', ' 60^o ');
set(findall(gcf, 'String', '0.66667'),'String', ' 30^o ');
set(findall(gcf, 'String', '0.66667'),'String', ' 30^o ');

num1 = findall(gcf, 'String', '0');
num2 = findall(gcf, 'String', '0');
num3 = findall(gcf, 'String', ' temp');
if length(num1) > 0
    set(num1(1),'String', ' temp');
end
if length(num2) > 0
    set(num2,'String', '  ');
end
if length(num3) > 0
    set(num3,'String', ' 90^o');
end

end