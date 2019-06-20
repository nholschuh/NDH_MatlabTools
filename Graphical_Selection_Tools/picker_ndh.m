function [picks index] = picker_ndh(time,offset,data,wiggle_or_image)

%% Compute the appropriate range of indecies to search around the line for a local mazimum;
temp_trace = data(:,round(length(data(1,:))/2));
plot(time,temp_trace)
[peaks] = findpeaks(temp_trace,time)
findpeaks(temp_trace,x);

%%


figure;
a = axes;
if wiggle_or_image == 1
wiggle_ndh(time,data,0,0)
elseif wiggle_or_image == 2
    imagesc(offset,time,data)
end
b = msgbox('Zoom to the Desired Initial Configuration');
waitfor(a,'YLim')

picks = graphical_selection(3);

if wiggle_or_image == 2
    
    time_picks = interp1(picks(:,1),picks(:,2),offset);
end
    