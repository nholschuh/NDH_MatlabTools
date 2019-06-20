function [NMO_corrected depthaxis] = NMO(traces,offset,ts,velocity);
% Takes an input geophsyical data set (traces) from a CMP, and uses the
% associated offets (offset), sampling axis (ts), and seismic velocity to
% compute the NMO corrected series.


for i = 1:length(traces(1,:))
    ts_temp = sqrt(ts.^2 - offset(i)^2/velocity^2);
    for j = 1:length(ts_temp)
        if imag(ts_temp(j)) == 0
            starts = j;
            break
        end
    end
    ts_temp = ts_temp(starts:end);
    use_traces = traces(starts:end,i);
    
    NMO_corrected(:,i) = interp1(ts_temp,use_traces,ts,'spline');
end

depthaxis = ts/2*velocity;
end
	