function bedmap_overlay(x,y,elevation,time_or_depth,pitchroll)
%% Reads the bedmap Surface elevation and bed elevation for the chosen line and plots the associated surfaces on the radargram

if exist('time_or_depth') == 0
    time_or_depth = 0;
end

if max(abs(y)) < 90
    [x y] = polarstereo_fwd(x,y);
end

dists = distance_vector(x,y);
scaler = floor(500/(dists(2)-dists(1)));

[bx by surface] = bedmap2_surface(min(x),max(x),min(y),max(y),0);
[bx by bed] = bedmap2(min(x),max(x),min(y),max(y),0);
[bx by correction] = bedmap2_geoidcorr(min(x),max(x),min(y),max(y),0);

surface = surface-correction;
bed = bed-correction;

for i = 1:floor(length(x)/scaler)
   surfvec(i) = surface(find_nearest(by,y((i-1)*scaler+1)),find_nearest(bx,x((i-1)*scaler+1)));
   bedvec(i) = bed(find_nearest(by,y((i-1)*scaler+1)),find_nearest(bx,x((i-1)*scaler+1)));
end

axes_info2 = findobj(gcf,'type','axes');
for j = 1:length(axes_info2);
    axes_info = get(axes_info2(j),'Children');
    for i = 1:length(axes_info)
        if length(get(axes_info(i),'Type')) == 5
            if get(axes_info(i),'Type') == 'image'
                break
            end
        end
    end
end

xaxis = get(axes_info(i),'XData');

if length(xaxis) == 2
    xaxis = linspace(xaxis(1),xaxis(2),floor(length(x)/scaler));
else
    xaxis = linspace(xaxis(1),xaxis(end),floor(length(x)/scaler));
end

cice_import;
cair_import;

if exist('pitchroll') == 0
    surfvec2 = 2*(elevation(1:scaler:scaler*(length(surfvec)-1)+1)-surfvec)/cair;
    bedvec2 = surfvec2 + 2*(surfvec-bedvec)/cice;
else
    surfvec2 = 2*(elevation(1:scaler:scaler*(length(surfvec)-1)+1)-surfvec)./cos(pitchroll(1,(1:scaler:scaler*(length(surfvec)-1)+1)))./cos(pitchroll(2,(1:scaler:scaler*(length(surfvec)-1)+1)))/cair;
    bed_pitch = pitchroll*cice/cair;
    bedvec2 = surfvec2 + 2*(surfvec-bedvec)./cos(bed_pitch(1,(1:scaler:scaler*(length(surfvec)-1)+1)))./cos(bed_pitch(2,(1:scaler:scaler*(length(surfvec)-1)+1)))/cice;
end

hold all

plot(xaxis,surfvec2,'Color','cyan','LineWidth',2)
plot(xaxis,bedvec2,'Color','red','LineWidth',2)

end
