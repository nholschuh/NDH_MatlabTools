function h=plot_segs(x, h, slope, W, linespec)


eval_string = ['h=plot([x(:)-W/2 x(:)+W/2]'', [h(:)-slope(:)*W/2 h(:)+slope(:)*W/2]'',', linespec,');'];
eval(eval_string);