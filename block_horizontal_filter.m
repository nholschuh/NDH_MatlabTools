function outdata = block_horizontal_filter(indata)
%%

indata = data;



    trace_diff = smooth_ndh(sum(data,1),30);
    
    steps = find_local_max(trace_diff',1,[1:length(trace_diff)]',100,5000,1,0);
    steps = steps{1}(:,1);
    
    hold off
imagesc(lp(data))
plot_indicator_lines(steps,2,'red')
colormap(gray)
    
