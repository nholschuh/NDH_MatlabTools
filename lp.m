function result = lp(data,amp0_or_power1);
% Takes the log power of amplitude data

if exist('amp0_or_power1') == 0
    amp0_or_power1 = 0;
end

if amp0_or_power1 == 0
    result = 10*log10(abs(data).^2);
else
    result = 10*log10(abs(data));
end
end