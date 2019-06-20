function write_raw(input,outfile,precision)

if exist('precision') == 0
    precision = 16;
end

input = NaN2value(input,min(min(input)));
vr = linspace(min(min(input)),max(max(input)),2^precision);
d_vr = vr(2)-vr(1);
input2 = input-min(vr);
input2 = round_to(input2,d_vr)./d_vr;

fid=fopen([outfile,'.RAW'],'w+');
cnt=fwrite(fid,input2,['uint',num2str(precision)]);
fclose(fid);

fid=fopen([outfile,'.meta'],'w+');
fprintf(fid,'Image range [ %f to %f ], spacing %f',[vr(1),vr(end),d_vr]);
fclose(fid);

end



