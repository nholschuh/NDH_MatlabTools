function plot_trace(x,time,amp);

dx = x(2)-x(1);
amp_scale = max(max(amp));

for i = 1:length(x)
    
    trace = ones(size(time))*x(i)+amp(:,i)/amp_scale*dx*2;
    postrace = trace;
    negtrace = trace;
    postrace(find(trace <= x(i))) = x(i);
    negtrace(find(trace > x(i))) = x(i);
    
    fill([postrace; postrace(1)],[time; time(1)],[0.2 0.2 0.2]);
    hold all
    fill([negtrace; negtrace(1)],[time; time(1)],[0.8 0.8 0.8]);
    
    plot(trace,time,'Color','white');
end

set(gca,'Color','black')