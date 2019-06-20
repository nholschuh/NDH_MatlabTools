function meanvec =  moving_mean(Data,Window)
% Calculates a moving average for a given time-series of spatial series data. Please use an odd window size

%%% Testing Parameters
% Window = 5
% Data = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2];

data_orientation = size(Data);
if data_orientation(1) > data_orientation(2)
    Data = Data';
end

if mod(Window,2) == 0
    Window = Window+1;
end
WC = ones(1,Window)/Window;
WT = -(Window-1)/2:(Window-1)/2;

% Set up time index axis (with a start at 0)
DT = [1-fliplr(1:Window) 1:length(Data) length(Data)+(1:Window)];

% Pad the start and end so that the computed average at 0 is the value at 0
D_Pad_1 = ones(1,(Window))*Data(1);
D_Pad_2 = ones(1,(Window))*Data(end);
Data2 = [D_Pad_1 Data D_Pad_2];


filter = ones(Window)/Window;
[amp] = convolution(Data2,WC,DT,WT);

meanvec = amp(Window+1:Window+length(Data));


% %%
% stepnum = length(Data)-Window+1;
% meanvec = ones(1,floor(Window/2))*NaN;
% 
% 
% for i = 1:stepnum
%     %calcvec = removeNaN(Data(i:(i+Window-1)));
%     calcvec = Data(i:(i+Window-1));
%     if length(calcvec) == 0
%         meanvec = [meanvec NaN];
%     else
%         meanvec = [meanvec mean(calcvec)];
%     end
% end
% 
% meanvec = [meanvec ones(1,floor(Window/2))*NaN];

end