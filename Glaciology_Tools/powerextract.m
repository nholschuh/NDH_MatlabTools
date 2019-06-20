function power_vals = powerextract(picks,Data);
% Extracts the power values based on pick index.

for i = 1:length(picks)
    if isnan(picks(i))==1
        power_vals(i) = NaN;
    else
        power_vals(i) = Data(picks(i),i);
    end
end

end