function meanvec =  TwoD_moving_mean(Data,Window)
% Calculates a moving average for a given time-series of spatial series data. Please use an odd window size

stepnum1 = length(Data(:,1))-Window+1;
stepnum2 = length(Data(1,:))-Window+1;
meanvec = ones(floor(Window/2),floor(Window/2))*NaN;


for i = 1:stepnum1
    for j = 1:stepnum2
        %calcvec = removeNaN(Data(i:(i+Window-1),j:(j+Window-1)));
        calcvec = Data(i:(i+Window-1),j:(j+Window-1));
        if length(calcvec) == 0
            meanvec(i,j) = [NaN];
        else
            meanvec(i,j) = [mean(mean(calcvec))];
        end
    end
    if (mod(i-1,round(stepnum1/10))) == 0
        (i-1)/round(stepnum1/10)/10
    end
end

meanvec = [ones(floor(Window/2),length(Data(1,:)))*NaN; ...
    ones(length(meanvec(:,1)),floor(Window/2))*NaN meanvec ones(length(meanvec(:,1)),floor(Window/2))*NaN; ...
    ones(floor(Window/2),length(Data(1,:)))*NaN];

end