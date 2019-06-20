function result = lp(data);
% Takes the log power of amplitude data


result = 10*log10(abs(data).^2);
end