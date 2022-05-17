function result = interpNaN(series)
%% This function takes a series that includes NaNs, and interpolates over the NaN sections

interp_method = 'linear';
interp_method = 'nearest';

result = series;
axis_vals = 1:length(series);

% Determine How many interpolation steps are necessary
replace_ind = find(isnan(series) == 1);
if length(replace_ind) ~= 0 & length(replace_ind) ~= length(series)
    interp_cutoff = [0];
    for i = 1:length(replace_ind)-1
        if replace_ind(i+1) ~= replace_ind(i)+1
            interp_cutoff = [interp_cutoff i];
        end
    end
    if replace_ind(end) ~= length(series)
        interp_cutoff = [interp_cutoff length(replace_ind)];
    end
    
    
    
    % Accomodates an issue where there are NaNs at the beginning of the series
    if replace_ind(1) == 1
        result(1:replace_ind(interp_cutoff(2))+2) = interp1(axis_vals(replace_ind(interp_cutoff(2)))+1:axis_vals(replace_ind(interp_cutoff(2)))+2, ...
            series(replace_ind(interp_cutoff(2))+1:replace_ind(interp_cutoff(2))+2), ...
            axis_vals(1:replace_ind(interp_cutoff(2))+2),...
            interp_method,'extrap');
        starter = 2;
    else
        starter = 1;
    end
    
    % NaNs in the interior of the series
    for i = starter:length(interp_cutoff)-1
        result(replace_ind(interp_cutoff(i)+1)-1:replace_ind(interp_cutoff(i+1))+1) = interp1([axis_vals(replace_ind(interp_cutoff(i)+1)-1) axis_vals(replace_ind(interp_cutoff(i+1))+1)], ...
            [series(replace_ind(interp_cutoff(i)+1)-1) series(replace_ind(interp_cutoff(i+1))+1)], ...
            axis_vals(replace_ind(interp_cutoff(i)+1)-1:replace_ind(interp_cutoff(i+1))+1), ...
            interp_method);
    end
    
    % Accomodates NaNs at the end of the series
    if replace_ind(end) == length(axis_vals)
        result(replace_ind(interp_cutoff(end)+1)-2:end) = interp1(axis_vals(replace_ind(interp_cutoff(end)+1)-2:replace_ind(interp_cutoff(end)+1)-1), ...
            series(replace_ind(interp_cutoff(end)+1)-2:replace_ind(interp_cutoff(end)+1)-1), ...
            axis_vals(replace_ind(interp_cutoff(end)+1)-2:end),...
            interp_method,'extrap');
    end
    
    
    debug = 0;
    if debug == 1
        hold off
        plot(axis_vals,series,'o','Color','black')
        hold all
        plot(axis_vals,result,'.','Color','red')
        for i = 1:length(replace_ind)
            plot_indicator_lines(axis_vals(replace_ind(i)),2,'blue')
        end
    end
elseif length(replace_ind) == length(series)
        result = ones(size(series));
end
end

