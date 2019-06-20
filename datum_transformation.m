function ELL2=datum_transformation(ELL,a_e1,p,a_e2)

% dt performs 3D-transformation with 7 parameters, also called Helmert
% transformation or datum transformation (in geodesy and cartography).
% It performs transformations of geodetic coordinates from one ellipsoid to another using
% 7 datum parameters.
%
%% INPUT: 
% ELL is nx3-matrix to be transformed ELL=[longitude in degrees, latitude in degrees, height in meters]
%
% a_e1 is the ellipsoid vector of ELL, a_e1=[semimajor axis in meters, eccentricity]
%
% p is the vector of transformation parameters, p=[dx dy dz ex ey ez s],
% p=[dx in meters, dy in meters, dz in meters, ex in arc seconds, ey in arc seconds, ez in arc seconds, s in ppm]
%              dx,dy,dz = translations
%              ex,ey,ez = rotations
%                   1+s = scale factor
% a_e2 is the ellipsoid vector of ELL2, target ellipsoid, a_e=[semimajor axis in meters, eccentricity]
%
%% OUTPUT:
% ELL2 is nx3- result matrix, ELL=[longitude in degrees, latitude in
% degrees, height in meters] on the target ellipsoid
%
% Author:
% Milan KILIBARDA, Faculty of Civil Engineering, Department of Geodesy and
% Geoinformatics, University of Belgrade, Serbia
% kili@grf.bg.ac.yu



% Known Elipsoids
if 'WGS84'
    params = [6378137,0.081819190842621];
end



n=size(ELL,1);

XYZ1=zeros(size(ELL));

B=ELL(:,2)*pi/180;
L=ELL(:,1)*pi/180;

e2=a_e1(2)^2;

% Transverse radius
N=a_e1(1)./sqrt(1-e2*sin(B).^2);

% Cartesian coordinates
XYZ1(:,1)=(N+ELL(:,3)).*cos(B).*cos(L);
XYZ1(:,2)=(N+ELL(:,3)).*cos(B).*sin(L);
XYZ1(:,3)=(N.*(1-e2)+ELL(:,3)).*sin(B);

%----------------------------------------------------------------------------
%----------------------------------------------------------------------------

% Rotation matrix
p(4:6)=p(4:6)*(pi/180/60/60);
c=cos(p(4:6));
s=sin(p(4:6));
R=zeros(3);
R(:,1)=[c(2)*c(3) -c(2)*s(3) s(2)]';
R(:,2)=[s(1)*s(2)*c(3)+c(1)*s(3) -s(1)*s(2)*s(3)+c(1)*c(3) -s(1)*c(2)]';
R(:,3)=[-c(1)*s(2)*c(3)+s(1)*s(3) c(1)*s(2)*s(3)+s(1)*c(3) c(1)*c(2)]';

%Transformation
XYZ22=repmat([p(1);p(2);p(3)],1,n)+(1+p(7)*1e-6)*R*XYZ1';
XYZ2=XYZ22';


%----------------------------------------------------------------------------
%----------------------------------------------------------------------------
% Geodetic coordinates

ELL2=zeros(size(XYZ2));
% Longitude
ELL2(:,1)=atan2(XYZ2(:,2),XYZ2(:,1))*180/pi;
ELL2(ELL2(:,1)<0,:)=ELL2(ELL2(:,1)<0,:)+360;

% Latitude
B0=atan2(XYZ2(:,3),sqrt(XYZ2(:,1).^2+XYZ2(:,2).^2));
B=100*ones(size(B0));
e2=a_e2(2)^2;
while(any(abs(B-B0)>1e-10))
    N=a_e2(1)./sqrt(1-e2*sin(B0).^2);
    h=sqrt(XYZ2(:,1).^2+XYZ2(:,2).^2)./cos(B0)-N;
    B=B0;
    B0=atan((XYZ2(:,3)./sqrt(XYZ2(:,1).^2+XYZ2(:,2).^2)).*(1-e2*N./(N+h)).^(-1));
end
ELL2(:,2)=B*180/pi;
ELL2(:,3)=h;