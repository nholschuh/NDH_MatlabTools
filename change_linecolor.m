function change_linecolor(color_in);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inp1 - Change the color of the last plotted line
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

    cds = get(gca,'Children');
    
    
    line_ind = [];
    counter = 1;
    
    for i = 1:length(cds)
        if length(cds(i).Type) == 4
            if min(cds(i).Type == 'line') == 1
                line_ind(counter) = i;
                counter = counter+1;
                break
            end
        end
    end
    
    set(cds(line_ind),'Color',color_call(color_in));
end
    
    