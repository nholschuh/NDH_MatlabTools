function rotating_colormap(cmap_name,rotations);

cvals = caxis;
lengths = floor(255/rotations);


eval(['ctemp =',cmap_name,'(lengths);']);

colormap(repmat(ctemp,rotations,1))
end