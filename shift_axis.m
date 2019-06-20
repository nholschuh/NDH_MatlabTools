function shift_axis(amount)

ps = get(gca,'Position');
ps(1) = ps(1)+amount;
set(gca,'Position',ps);