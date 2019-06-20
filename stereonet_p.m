function stereonet_p(strike,dip,rad_deg)
% Plots the trace of a plane on an equal angle stereonet
figure
if rad_deg == 1
    strike = deg2rad(strike);
    dip = deg2rad(dip);
end

R = 1;
rake = 0:pi/180:pi;
cmap = bone(length(strike));
for i=1:length(strike);
    plunge = asin(sin(dip(i)).*sin(rake));
    trend = strike(i) + atan2(cos(dip(i)).*sin(rake), cos(rake));
    rho = -(pi/4-(plunge/2))/pi*4;
    % polarb plots ccl from 3:00, so convert to cl from 12:00
    if i == 1
        polarhg(trend,rho,'tdir','ClockWise','linestyle','-','rlim',[0 1],'rtick',[ 1/3 2/3 ],'tstep',30,'torig','Up','color',cmap(i,:))
        set(findall(gcf, 'String', '1'),'String', ' 0^o ');
        set(findall(gcf, 'String', '0.33333'),'String', ' 60^o ');
        set(findall(gcf, 'String', '0.66667'),'String', ' 30^o ');
        set(findall(gcf, 'String', '0.66667'),'String', ' 30^o ');
        num2 = findall(gcf, 'String', '0');
        set(num2(1),'String', ' temp');
        num2 = findall(gcf, 'String', '0');
        set(num2,'String', '  ');
        num2 = findall(gcf, 'String', ' temp');
        set(num2,'String', ' 90^o');
        hold on
    else
        h1 = polar(trend,rho);
        set(h1,'Color',cmap(i,:),'LineWidth',2)
    end

end
colormap(bone(length(strike)));
c1 = colorbar;
caxis([0 length(strike)]);
set(get(c1,'Ylabel'),'string','Sample #')
end