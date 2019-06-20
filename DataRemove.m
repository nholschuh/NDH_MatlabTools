function results = DataRemove(Data,xcol,ycol)
% Uses a graphical interface to select and remove data
    [nonresults results] = graphical_selection_within(Data,xcol,ycol);
end