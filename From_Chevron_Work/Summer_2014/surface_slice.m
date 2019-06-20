function results = surface_slice(segy_compare_results,import_surface_results)

xaxis = import_surface_results{1};
yaxis = import_surface_results{2};
grid = import_surface_results{3};

x_coords = segy_compare_results{4};
y_coords = segy_compare_results{5};

time = segy_compare_results{6};



for i = 1:length(x_coords)
    grid_ind_x(i) = find_nearest(xaxis,x_coords(i));
    grid_ind_y(i) = find_nearest(yaxis,y_coords(i));
    time_values(i) = grid(grid_ind_y(i),grid_ind_x(i));
    if isnan(grid(grid_ind_y(i),grid_ind_x(i))) == 1
        depth_ind(i) = NaN;
    else
        depth_ind(i) = find_nearest(time*-1,grid(grid_ind_y(i),grid_ind_x(i)));
    end
end


results = [time_values;depth_ind];

end