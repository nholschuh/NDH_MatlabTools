function output = get_figurebox();
%%%%%%%%%%%%%%%%%% Picks out the four points that define the current figure
%%%%%%%%%%%%%%%%%% boundaries

xs = get(gca,'XLim');
ys = get(gca,'YLim');

output = [xs(1) ys(1); ...
    xs(2) ys(1); ...
    xs(2) ys(2); ...
    xs(1) ys(2); ...
    xs(1) ys(1)];

end