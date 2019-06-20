%%%%%%%%%%%%


a = subplot(1,3,1)
Greenland_Topography(8,'a',0,0,0,1);

b = subplot(1,3,2)
G_Velocity(1,'s',0,'a',0,0,0,1);
caxis([0 100])

c = subplot(1,3,3)
Greenland_Imagery('a');

linkaxes([a b c],'xy')



