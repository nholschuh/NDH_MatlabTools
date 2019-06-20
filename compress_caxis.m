function compress_caxis(infrac)

cvals = caxis;
cdiff = cvals(2)-cvals(1);
cmid = mean(cvals);

cdist = cdiff*infrac/2;
caxis([cmid-cdist cmid+cdist])