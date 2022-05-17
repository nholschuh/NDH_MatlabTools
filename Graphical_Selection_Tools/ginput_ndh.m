function [out1,out2,out3] = ginput_ndh(arg1,arg2)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This is designed to be a lighter weight version of ginput, modified from
% the stointerpret picker function (stp_ginput).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 -
% out2 -
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%   Created: B. Youngblood - 1.12.08
%   Modification History:
%
%           Fixed bug that caused stopicker to die if you hit [enter]
%                                       B. Youngblood       5.25.08
%
%   Necessary variables:
%           Npoints                     number of points to collect
%           flags.ptype                 type of pick
%
%   Output variables:
%           ginputx                     location of event in pixel
%           ginputy                     coordinates
%
%           clickcoords.button          mouse button (1,2,3) or ASCII
%                                       values if the event was a keystroke
%
%   Syntax:
%   [ginputx,ginputy] = stp_ginput(1,flags.ptype);
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GINPUT Graphical input from mouse.
%   [X,Y] = GINPUT(N) gets N points from the current axes and returns
%   the X- and Y-coordinates in length N vectors X and Y.  The cursor
%   can be positioned using a mouse (or by using the Arrow Keys on some
%   systems).  Data points are entered by pressing a mouse button
%   or any key on the keyboard except carriage return, which terminates
%   the input before N points are entered.
%
%   [X,Y] = GINPUT gathers an unlimited number of points until the
%   return key is pressed.
%
%   [X,Y,BUTTON] = GINPUT(N) returns a third result, BUTTON, that
%   contains a vector of integers specifying which mouse button was
%   used (1,2,3 from left) or ASCII numbers if a key on the keyboard
%   was used.
%
%   Examples:
%       [x,y] = ginput;
%
%       [x,y] = ginput(5);
%
%       [x, y, button] = ginput(1);
%
%   See also GTEXT, UIRESTORE, UISUSPEND, WAITFORBUTTONPRESS.

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 5.32.4.9 $  $Date: 2006/12/20 07:19:10 $

out1 = []; out2 = []; out3 = []; y = [];


fig = gcf;
figure(gcf);
icon_type = 'standard';

how_many = 1;
b = [];

% Suspend figure functions
%state = uisuspend(fig);

toolbar = findobj(allchild(fig),'flat','Type','uitoolbar');
if ~isempty(toolbar)
    ptButtons = [uigettool(toolbar,'Plottools.PlottoolsOff'), ...
        uigettool(toolbar,'Plottools.PlottoolsOn')];
    ptState = get (ptButtons,'Enable');
    set (ptButtons,'Enable','off');
end

if strcmp(icon_type,'standard')==1
    inner_box = 2;
    pointershape = zeros(32)*NaN;
    pointershape(16,1:end-1) = 1;
    pointershape(:,16) = 1;
    pointershape(16,16-inner_box:16+inner_box) = NaN;
    pointershape(16-inner_box:16+inner_box,16) = NaN;
    pointershape([16-inner_box 16+inner_box],16-inner_box:16+inner_box) = 1;
    pointershape(16-inner_box:16+inner_box,[16-inner_box 16+inner_box]) = 1;

    ptag = [15,15];
end


set(fig,'pointer','custom','PointerShapeCData',pointershape,'PointerShapeHotSpot',ptag);

fig_units = get(fig,'units');
char = 0;

% We need to pump the event queue on unix
% before calling WAITFORBUTTONPRESS
drawnow

while how_many ~= 0
    ptr_fig = get(0,'CurrentFigure');
    
    % Use no-side effect WAITFORBUTTONPRESS
    waserr = 0;
    try
        keydown = wfbp;
    catch
        waserr = 1;
    end
    if(waserr == 1)
        if(ishandle(fig))
            set(fig,'units',fig_units);
            uirestore(state);
            error('MATLAB:ginput:Interrupted', 'Interrupted');
        else
            error('MATLAB:ginput:FigureDeletionPause', 'Interrupted by figure deletion');
        end
    end
    
    %       ptr_fig = get(0,'CurrentFigure');
    %       ptr_fig
    if(ptr_fig == fig)
        if keydown
            char = get(fig, 'CurrentCharacter');
            button = abs(get(fig, 'CurrentCharacter'));
            scrn_pt = get(0, 'PointerLocation');
            set(fig,'units','pixels')
            loc = get(fig, 'Position');
            % We need to compensate for an off-by-one error:
            pt = [scrn_pt(1) - loc(1) + 1, scrn_pt(2) - loc(2) + 1];
            set(fig,'CurrentPoint',pt);
        else
            button = get(fig, 'SelectionType');
            if strcmp(button,'open')
                button = 1;
            elseif strcmp(button,'normal')
                button = 1;
            elseif strcmp(button,'extend')
                button = 2;
            elseif strcmp(button,'alt')
                button = 3;
            else
                error('MATLAB:ginput:InvalidSelection', 'Invalid mouse selection.')
            end
        end
        pt = get(gca, 'CurrentPoint');
        
        how_many = how_many - 1;
        
%         if strcmp(arg2,'getpts')
%             if(char == 13) % & how_many ~= 0)
%                 % if the return key was pressed, char will == 13,
%                 % and that's our signal to break out of here whether
%                 % or not we have collected all the requested data
%                 % points.
%                 % If this was an early breakout, don't include
%                 % the <Return> key info in the return arrays.
%                 % We will no longer count it if it's the last input.
%                 break;
%             end
%         end
        
        out1 = [out1;pt(1,1)];
        y = [y;pt(1,2)];
        b = [b;button];
    end
end

%uirestore(state);
if ~isempty(toolbar) && ~isempty(ptButtons)
    set (ptButtons(1),'Enable',ptState{1});
    set (ptButtons(2),'Enable',ptState{2});
end
set(fig,'units',fig_units);

if nargout > 1
    out2 = y;
    if nargout > 2
        out3 = b;
    end
else
    out1 = [out1 y];
end

set(fig,'pointer','arrow')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function key = wfbp
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;
current_char = [];

% Now wait for that buttonpress, and check for error conditions
waserr = 0;
try
    h=findall(fig,'type','uimenu','accel','C');   % Disabling ^C for edit menu so the only ^C is for
    set(h,'accel','');
    % interrupting the function.
    keydown = waitforbuttonpress;
    
    current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
    if~isempty(current_char) && (keydown == 1)           % If the character was generated by the
        if(current_char == 3)                       % current keypress AND is ^C, set 'waserr'to 1
            waserr = 1;                             % so that it errors out.
        end
    end
    
    set(h,'accel','C');                                 % Set back the accelerator for edit menu.
catch
    waserr = 1;
end
drawnow;
if(waserr == 1)
    set(h,'accel','C');                                % Set back the accelerator if it errored out.
    error('MATLAB:ginput:Interrupted', 'Interrupted');
end

if nargout>0, key = keydown; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end