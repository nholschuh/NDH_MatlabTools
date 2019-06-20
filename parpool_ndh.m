function parpool_ndh(worker_num)


t = gcp('nocreate');

if length(t) == 0
    parpool(worker_num)
elseif length(t) == 1 & t.NumWorkers == worker_num
    
else 
    delete(t)
    parpool(worker_num)
end