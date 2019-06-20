function addpath_subfolders(target_dir)

currdir = pwd;

target_dir = [OnePath,'Matlab_Code/MATGPR_R3/'];

addpath(target_dir);
cd(target_dir)

fds = folders(target_dir);

for i = 1:length(fds)
    addpath(fds(i).name)
    cd(fds(i).name)
    
    fds1 = folders();
    
    for j = 1:length(fds1)
        addpath(fds1(j).name)
        cd(fds1(j).name)
        
        fds2 = folders();
        
        for k = 1:length(fds2)
            addpath(fds2(k).name)
            cd(fds2(k).name)
            
            fds3 = folders();
            
            for l = 1:length(fds3)
                addpath(fds3(l).name)
                cd ..
            end
            cd ..
        end
        cd ..
    end
    cd ..
end


cd(currdir)

end
    
    
    
    
    
    