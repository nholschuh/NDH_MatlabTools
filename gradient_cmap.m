function newmap = gradient_cmap(color_cell_in,cmin_input,cmax_input,color_num,centered_or_not);

if exist('color_num') == 0
    color_num = 250;
end

if exist('centered_or_not') == 0
    centered_or_not = 1;
end

%% control the figure caxis
lims = get(gca, 'CLim');   % get figure caxis formation
caxis([cmin_input cmax_input])


%% Set the stepwise colors
%%%%%%%%%%%%%% The case where you are choosing from one of the default
%%%%%%%%%%%%%% color options
if length(color_cell_in) == 1 && iscell(color_cell_in) == 0
    
    if color_cell_in == 1
        %%%% Blue to Red, (b2r)
        color_input = [[0 0 1];  [1 1 1];  [1 0 0]];
        oldsteps = linspace(-1, 1, length(color_input));        
    elseif color_cell_in == 2
        %%%% Cyan to Blue to Red to Yellow, (b2r2)
        color_input = [[0 1 1]; ...
            [0 0 1]; ...
            [230 230 245]/255; ...
            [1 1 1]; ...
            [245 230 230]/255; ...
            [1 0 0]; ...
            [1 1 0]];
        oldsteps = [-1 -0.4 -0.1 0 0.1 0.4 1];
    elseif color_cell_in == 3
        %%%% Blue to Orange, (formerly b2o2)
        color_input = [[0 1 1]; ...
            [0 154 218]/255; ...
            [230 230 230]/255; ...
            [1 1 1]; ...
            [230 230 230]/255; ...
            [242 101 34]/255; ...
            [1 1 0]];
        oldsteps = [-1 -0.4 -0.1 0 0.1 0.4 1];
    end
    
else
    
    for i = 1:length(color_cell_in)
        if isstr(color_cell_in{i}) == 1
            color_mat(i,:) = color_call(color_cell_in{i})/255;
        else
            color_mat(i,:) = color_cell_in{i};
        end
    end
    
    %%%%%%%%%%%%%% The case where you have supplied two of the endmember colors
    color_input = color_mat;
    oldsteps = linspace(-1,1,length(color_cell_in));
end


%% color interpolation
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