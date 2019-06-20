function axis_to_pixels()
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Sets the figure to be the exact size of the image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
cds = get(gca,'Children');

for i = 1:length(cds)
    if length(cds(i).Type) == 5
        if min(cds(i).Type == 'image') == 1
            ss = size(cds(i).CData);
            break
        end
    end
end


set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[0 0 ss(2) ss(1)])
axis off

end