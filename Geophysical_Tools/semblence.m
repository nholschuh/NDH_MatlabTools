function semb = semblence(traces,offsets,ts,velocities,window)
% Performs Semblence Analysis

window = (window-1)/2;
iterations = length(traces(:,1))-2*window;

semb = zeros(length(ts),length(velocities));

for n = 1:length(velocities)
    nmo_results = NMO(traces,offsets,ts,velocities(n));
    
    for k = (1:iterations)+window
        % Calculate the semblance for this NMO velocity over timewindows of
        % 'gate' samples length.
        % (Sheriff & Geldart (1995) eq. 9.59)
        semb(k,n)=(sum(sum(nmo_results((k-window):(k+window),:),2).^2)./...
            sum(sum(nmo_results((k-window):(k+window),:).^2,2))).*...
            1/(length(offsets));
    end
end