function stitch_cresis(fileprefix,numberrange)



for i = 1:length(numberrange)
    files{i} = [fileprefix,'_',sprintf('%03.f',numberrange(i)),'.mat'];
end

file_stitch(files);