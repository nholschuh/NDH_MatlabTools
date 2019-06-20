function remove_pickline(filename,rowinds)

load(filename)

picks.samp1(rowinds,:) = [];
picks.samp2(rowinds,:) = [];
picks.samp3(rowinds,:) = [];
picks.time(rowinds,:) = [];
picks.picknums(rowinds) = [];

if exist('picks.corrected_power_dB') == 1
    picks.corrected_power.dB = [];
end

rss = resave_string(filename);
eval(rss);

end

