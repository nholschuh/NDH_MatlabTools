function moveimage_back(down_or_bottom,numtimes);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Move the most recently plotted image to the back of the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('down_or_bottom') == 0
    down_or_bottom = 1;
end

if exist('numtimes') == 0
    numtimes = 1;
end

cs = get(gca,'Children');

if down_or_bottom == 0
    
        uistack(cs(1),'down',numtimes)

else
    uistack(cs(1),'bottom')
end
