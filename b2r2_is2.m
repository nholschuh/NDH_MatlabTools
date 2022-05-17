function newmap = b2r2_is2(cmin_input,cmax_input,centered_or_not,color_num)
%BLUEWHITERED   Blue, white, and red color map.
%   this matlab file is designed to draw anomaly figures, the color of
%   the colorbar is from blue to white and then to red, corresponding to
%   the anomaly values from negative to zero to positive, respectively.
%   The color white always correspondes to value zero.
%
%   You should input two values like caxis in matlab, that is the min and
%   the max value of color values designed.  e.g. colormap(b2r(-3,5))
%
%   the brightness of blue and red will change according to your setting,
%   so that the brightness of the color corresponded to the color of his
%   opposite number
%   e.g. colormap(b2r(-3,6))   is from light blue to deep red
%   e.g. colormap(b2r(-3,3))   is from deep blue to deep red
%
%   I'd advise you to use colorbar first to make sure the caxis' cmax and cmin
%
%   by Cunjie Zhang
%   2011-3-14
%   find bugs ====> email : daisy19880411@126.com
%
%   Examples:
%   ------------------------------
%   figure
%   peaks;
%   colormap(b2r(-6,8)), colorbar, title('b2r')
%


%% check the input
if nargin == 1
    cmax_input = max(cmin_input);
    color_num = length(cmin_input);
    cmin_input = min(cmin_input);
    centered_or_not = 1;
elseif nargin == 2
    color_num = 60;
    centered_or_not = 1;
elseif nargin == 3
    color_num = 250;
end

if centered_or_not == 1
    color_num = floor(2*max(abs([cmax_input cmin_input]))/(cmax_input-cmin_input))*color_num-1;
end


if nargin ~= 2 & nargin ~= 1 & nargin ~= 3 & nargin ~= 4;
    disp('input error');
    disp('input two variables, the range of caxis , for example : colormap(b2r(-3,3))')
end

if cmin_input >= cmax_input
    disp('input error')
    disp('the color range must be from a smaller one to a larger one')
end



%% control the figure caxis
lims = get(gca, 'CLim');   % get figure caxis formation
caxis([cmin_input cmax_input])

%% color configuration : from blue to light blue to white until to red
red_bottom = [54,0,0]/255;
red_top = [1 0 0];
orange = [255,140,0]/255;
yello_top_top = [1 1 0];
grey1 = [255 200 0]/255;
white_middle= [1 1 1];
grey2 = [200 200 230]/255;
blue_bottom = [0 0 1];
bright_blue_bottom = [0 1 1];

%% color interpolation

color_input = [blue_bottom; ...
    grey2; ...
    white_middle; ...
    grey1; ...
    orange; ...
    red_top; ...
    red_bottom];
oldsteps = [-1 -0.7 -0.3 0 0.2 0.4 1];

% color_input = [blue_bottom; ...
%     grey2; ...
%     white_middle; ...
%     grey1; ...
%     red_top];
% oldsteps = [-1 -0.5 0  0.5 1];


newsteps = linspace(-1, 1, color_num);

%% Category Discussion according to the cmin and cmax input

%  the color data will be remaped to color range from -max(abs(cmin_input,abs(cmax_input)))
%  to max(abs(cmin_input,abs(cmax_input))) , and then squeeze the color
%  data in order to make suere the blue and red color selected corresponded
%  to their math values

%  for example :
%  if b2r(-3,6) ,the color range is from light blue to deep red ,
%  so that the color at -3 is light blue while the color at 3 is light red
%  corresponded

%% Category Discussion according to the cmin and cmax input
% first : from negative to positive
% then  : from positive to positive
% last  : from negative to negative


newmap_all = NaN(size(newsteps,2),3);
if centered_or_not == 1
    if (cmin_input < 0)  &&  (cmax_input > 0) ;
        
        
        if abs(cmin_input) < cmax_input
            
            % |--------|---------|--------------------|
            % -cmax      cmin       0                  cmax         [cmin,cmax]
            %    squeeze(colormap(round((cmin+cmax)/2/cmax),size(colormap)))
            
            for j=1:3
                newmap_all(:,j) = min(max(transpose(interp1(oldsteps, color_input(:,j), newsteps)), 0), 1);
            end
            start_point = round((cmin_input+cmax_input)/2/cmax_input*color_num);
            newmap = squeeze(newmap_all(start_point:color_num,:));
            
        elseif abs(cmin_input) >= cmax_input
            
            % |------------------|------|--------------|
            %  cmin                0     cmax          -cmin         [cmin,cmax]
            %    squeeze(colormap(round((cmin+cmax)/2/cmax),size(colormap)))
            
            for j=1:3
                newmap_all(:,j) = min(max(transpose(interp1(oldsteps, color_input(:,j), newsteps)), 0), 1);
            end
            end_point = round((cmax_input-cmin_input)/2/abs(cmin_input)*color_num);
            newmap = squeeze(newmap_all(1:end_point,:));
        end
        
        
    elseif cmin_input >= 0
        
        if lims(1) < 0
            disp('caution:')
            disp('there are still values smaller than 0, but cmin is larger than 0.')
            disp('some area will be in red color while it should be in blue color')
        end
        % |-----------------|-------|-------------|
        % -cmax               0      cmin          cmax         [cmin,cmax]
        %    squeeze(colormap(round((cmin+cmax)/2/cmax),size(colormap)))
        
        for j=1:3
            newmap_all(:,j) = min(max(transpose(interp1(oldsteps, color_input(:,j), newsteps)), 0), 1);
        end
        start_point = round((cmin_input+cmax_input)/2/cmax_input*color_num);
        newmap = squeeze(newmap_all(start_point:color_num,:));
        
    elseif cmax_input <= 0
        
        if lims(2) > 0
            disp('caution:')
            disp('there are still values larger than 0, but cmax is smaller than 0.')
            disp('some area will be in blue color while it should be in red color')
        end
        
        % |------------|------|--------------------|
        %  cmin         cmax    0                  -cmin         [cmin,cmax]
        %    squeeze(colormap(round((cmin+cmax)/2/cmax),size(colormap)))
        
        for j=1:3
            newmap_all(:,j) = min(max(transpose(interp1(oldsteps, color_input(:,j), newsteps)), 0), 1);
        end
        end_point = round((cmax_input-cmin_input)/2/abs(cmin_input)*color_num);
        newmap = squeeze(newmap_all(1:end_point,:));
    end
else
    for j=1:3
        newmap(:,j) = interp1(oldsteps, color_input(:,j), newsteps);
    end
end
end



