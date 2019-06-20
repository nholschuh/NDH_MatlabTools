%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ReWrite_SeaRiseData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x y z] = grdread('SeaRiseData_5km_dev1.2.nc',Inf);


[x y] = polarstereo_fwd(z.lat,z.lon,1);

x = round_to(x,1000);
y = round_to(y,1000);

xs = x(:,1)';
ys = y(1,:)';


fields = {'surftemp','airtemp2m','smb','runoff','bheatflx','dhdt'};


for i = 1:length(fields);
grdwrite(xs,ys,eval(['z.',fields{i}])',['SeaRise_39_',fields{i},'.nc'])
end

%%%% Then run bash function convert_39 SeaRise_*.nc






