function bearing = latlon_bearing(lat1,lon1,lat2,lon2)


lat1 = deg2rad(lat1);
lat2 = deg2rad(lat2);
lon1 = deg2rad(lon1);
lon2 = deg2rad(lon2);


   bearing=rad2deg(mod(atan2(sin(lon2-lon1)*cos(lat2),cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(lon2-lon1)),2*pi));
   
end