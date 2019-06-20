function Average_WellSpectrum(filelist);
%%
varargin = {'WEDL6','WEEL5','WEGL7','WEUL1','WI_L3','WI_L4'};

twtt = [];
well_data = [];
total_amp = [];
total_f = [];

for i = 1:length(varargin)
    well_temp = ReadWells(varargin{i}); 
    twtt = [twtt; well_temp.TWTT/1000];
    well_data = [well_data; well_temp.AI];
    
    [amp f] = fft_ndh(well_temp.AI,well_temp.TWTT/1000,2,0);
    total_amp = [total_amp; amp];
    total_f = [total_f f];
    
end
total_f = total_f';

new_f_ind = find(f > 0);
new_f = f(new_f_ind);
new_tf_ind = find(total_f > 0);
new_tf = total_f(new_tf_ind);

a = polyfit(log(new_tf),log(total_amp(new_tf_ind)),1);

debugger = 0;
if debugger == 1
subplot(3,1,1)
plot(twtt,well_data,'o')
subplot(3,1,2)
plot(total_f,total_amp,'o')
hold all
plot(new_f,new_f.^a(1)*exp(a(2)),'Color','black')

subplot(3,1,3)
plot(log(abs(total_f)),log(total_amp),'o');
hold all
plot(log(new_tf),polyval(a,log(new_tf)),'Color','black')
end
