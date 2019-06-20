function stress = driving_stress(x,y,surf,bed,smoothing);

if exist('smoothing') == 0
    smoothing = 1;
end

dx = x(2)-x(1);
dy = y(2)-y(1);

rho = 0.917; %kg/m^3
g = 9.8; %m/s
h = surf-bed;

surf = smooth_ndh(surf,smoothing);

%%%%% Calculate the sin(alpha) term
[dzdx dzdy] = gradient(surf);
dzdx = -dzdx/dx;
dzdy = -dzdy/dy;
sinalpha = sqrt(dzdx.^2+dzdy.^2);


stress = rho*g.*h.*sinalpha;

end


