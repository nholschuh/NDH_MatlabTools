function output = get_figurebox(round_quantity);
%%%%%%%%%%%%%%%%%% Picks out the four points that define the current figure
%%%%%%%%%%%%%%%%%% boundaries

if exist('round_quantity') == 0
    round_quantity = 1;
end
if round_quantity == 0;
    round_quantity = 1;
end

xs = round_to(get(gca,'XLim'),round_quantity);
ys = round_to(get(gca,'YLim'),round_quantity);

output = [xs(1) ys(1); ...
    xs(2) ys(1); ...
    xs(2) ys(2); ...
    xs(1) ys(2); ...
    xs(1) ys(1)];

disp(' ')
disp(['xs = [',num2str(xs(1)),',',num2str(xs(2)),'];'])
disp(['ys = [',num2str(ys(1)),',',num2str(ys(2)),'];'])
disp(' ')
disp('xs(1),xs(2),ys(1),ys(2)')
end