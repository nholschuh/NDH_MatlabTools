function moveimage_back(down0_or_bottom1,numtimes);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Move the most recently plotted image to the back of the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% down0_or_bottom1 - 0, to the bottom of the figure layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
% down0_or_bottom1 -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('down0_or_bottom1') == 0
    down0_or_bottom1 = 1;
end

if exist('numtimes') == 0
    numtimes = 1;
end

cs = get(gca,'Children');

if down0_or_bottom1 == 0
    
    uistack(cs(1),'down',numtimes)

else
    uistack(cs(1),'bottom')
end
