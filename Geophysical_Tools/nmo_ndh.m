function corrected_traces = nmo_ndh(traces,t0,x,velocity_depth);
% Performs an NMO correction of a set of traces

start = min(find(t0 >= 0));
traces = traces(start:end,:);
t0 = t0(start:end);

for i = 1:length(traces)
    t_correction(i,:) = t0(i)*(sqrt(1+(x/(velocity_depth(i)*t0(i))).^2)-1);
end

t_times = t0'*ones(1,length(x))-t_correction;
t_times = NaN2value(t_times,0);

for i = 1:length(x)
    if isnan(max(traces(:,i))) == 1
        corrected_traces(:,i) = traces(:,i);
    else
        corrected_traces(:,i) = interp1(t_times(:,i),traces(:,i),t0','spline');
    end
end

corrected_traces = [ones(start-1,length(x)); corrected_traces];

end

