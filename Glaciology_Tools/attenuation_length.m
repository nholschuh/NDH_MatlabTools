function length = attenuation_length(att_rate)

length = 10^3*10*log10(exp(1))/att_rate;

end