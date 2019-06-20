function maximize(quadrant)
% (C) Nick Holschuh - University of Washington - 2017
% Fits current figure to a fraction of the window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% quadrant -    0: Maximized
%               1: 1st Quadrant    
%               2: 2nd Quadrant
%               3: 3rd Quadrant
%               4: 4th Quadrant
%               5: Left Half
%               6: Right Half
%               7: Top Half
%               8: Bottom Half

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('quadrant') == 0
    quadrant = 0;
end


Pix_SS = get(0,'screensize');

top_menu = 75;
bottom_menu = 41;

    if quadrant == 0 %%%%%%%%%%%%%% Maximized
        set(gcf,'Position',[1 bottom_menu Pix_SS(3) Pix_SS(4)-top_menu-bottom_menu])
    elseif quadrant == 1 %%%%%%%%%% 1st Quadrant
        set(gcf,'Position',[Pix_SS(3)/2 (Pix_SS(4))/2-top_menu Pix_SS(3)/2 Pix_SS(4)/2-top_menu-bottom_menu])
    elseif quadrant == 2 %%%%%%%%%% 2nd Quadrant
        set(gcf,'Position',[1 (Pix_SS(4))/2-top_menu Pix_SS(3)/2 Pix_SS(4)/2-top_menu-bottom_menu])
    elseif quadrant == 3 %%%%%%%%%% 3rd Quadrant
        set(gcf,'Position',[1 bottom_menu Pix_SS(3)/2 Pix_SS(4)/2-top_menu-bottom_menu])
    elseif quadrant == 4 %%%%%%%%%% 4th Quadrant
        set(gcf,'Position',[Pix_SS(3)/2 bottom_menu Pix_SS(3)/2 Pix_SS(4)/2-top_menu-bottom_menu])
    elseif quadrant == 5 %%%%%%%%%% Left Half
        set(gcf,'Position',[1 bottom_menu Pix_SS(3)/2 Pix_SS(4)-top_menu-bottom_menu])
    elseif quadrant == 6 %%%%%%%%%% Right Half
        set(gcf,'Position',[Pix_SS(3)/2 bottom_menu Pix_SS(3)/2 Pix_SS(4)-top_menu-bottom_menu])
    elseif quadrant == 7 %%%%%%%%%% Top Half
        set(gcf,'Position',[1 (Pix_SS(4))/2-top_menu Pix_SS(3) Pix_SS(4)/2-top_menu-bottom_menu])
    elseif quadrant == 8 %%%%%%%%%% Bottom Half
        set(gcf,'Position',[1 bottom_menu Pix_SS(3) Pix_SS(4)/2-top_menu-bottom_menu])
    end
    
end