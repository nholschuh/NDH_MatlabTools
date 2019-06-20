function [output]=read_GLAH12_h5(h5_file,subset_flag,subset_poly)
% (C) Nick Holschuh - University of Washington - 2017 (Holschuh@uw.edu)
% This function reads in the IceSAT .h5 file produced through the NASA SDC
% system, using the land ice algorithm produced by Ben Smith
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% h5_file - string containing either the local or full paht the ATL06 file
% output_type - a flag allowing you to choose from the following:
%     0: Full output, following the .h5 file structure [default]
%     1: Reduced output, containing only the surface heights (corrected for
%     saturation), lat/lon, reflectivity, and quality flags
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - structure containing the .h5 information
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

keep_vars = {'d_lat','d_lon','d_elev','d_reflectUC','elev_use_flg','Quality','i_track','DS_UTCTime_1','DS_UTCTime_40'};

if exist('subset_flag') == 0
    subset_flag = 0;
    startcount = 0;
    countnum = 0;
end

if subset_flag == Inf | subset_flag == 2
    name_comp = 1;
else
    name_comp = 0;
end

I=h5info(h5_file,'/');

if subset_flag == 1 | subset_flag == 2
    
    subset_group = 1;
    lat40 = h5read(h5_file,['/Data_40HZ/Geolocation/d_lat']);
    lon40 = h5read(h5_file,['/Data_40HZ/Geolocation/d_lon']);
    
    lat1 = h5read(h5_file,['/Data_1HZ/Geolocation/d_lat']);
    lon1 = h5read(h5_file,['/Data_1HZ/Geolocation/d_lon']);
    
    length_40 = length(lat40);
    length_1 = length(lon1);
    
    if max(subset_poly(:,1)) < 0
        ant_flag = 1;
    else
        ant_flag = 0;
    end
    
    if ant_flag == 1
        [x40 y40] = polarstereo_fwd(lat40,lon40,0);
        [x1 y1] = polarstereo_fwd(lat1,lon1,0);
        [polyx polyy] = polarstereo_fwd(subset_poly(:,1),subset_poly(:,2),0);
    else
        [x40 y40] = polarstereo_fwd(lat40,lon40,2);
        [x1 y1] = polarstereo_fwd(lat1,lon1,2);
        [polyx polyy] = polarstereo_fwd(subset_poly(:,1),subset_poly(:,2),0);
    end
    
    inds40 = find(within(x40,y40,polyx,polyy) & abs(lat40) <= 90);
    inds1 = find(within(x1,y1,polyx,polyy) & abs(lat1) <= 90);
    
else
    subset_group = 0;
    length_40 = 0;
    length_1 = 0;
    inds40 = 0;
    inds1 = 0;
end



%%%%%%%%%%%%%%% This extracts the attributs of the hd5 file itself, and
%%%%%%%%%%%%%%% saves it to the object GranuleMeta
for i = 1:length(I.Attributes)
    wrt_str = ['output.GranuleMeta.',I.Attributes(i).Name,' = I.Attributes(i).Value;'];
    eval(wrt_str)
end

%%%%%%%%%%%%%%% Here we start looping into the different groups, to save
%%%%%%%%%%%%%%% their attributes and values
for i = 1:length(I.Groups)
    
    %%%%% Get the path into the hd5 file and the name to save into the
    %%%%% matlab structure
    rn = I.Groups(i).Name;
    rn2 = strsplit(rn,'/');
    rn_str = ['rn3 = strcat('];
    for j = 1:length(rn2)
        rn_str = [rn_str,'''',rn2{j},''',''.'','];
    end
    rn_str = [rn_str(1:end-1),');'];
    eval(rn_str);
    
    %%%%% Loop through the attributes and save them into the meta
    %%%%% substructure
    for j = 1:length(I.Groups(i).Attributes)
        wrt_str = ['output',rn3,'Meta.',I.Groups(i).Attributes(j).Name,' = I.Groups(i).Attributes(j).Value;'];
        eval(wrt_str)
    end
    
    
    %%%%% Loop through the datasets for this group
    for j = 1:length(I.Groups(i).Datasets)
        vardims = I.Groups(i).Datasets(j).Dataspace.Size;
        varname = I.Groups(i).Datasets(j).Name;
        
        if name_comp == 0 | strcmp_ndh(keep_vars,varname) == 1
            
            wrt_str = ['tdata = h5read(h5_file,[''',rn,''',''/'',''',varname,''']);'];
            eval(wrt_str)
            if length(vardims) == 1
                vardims = [1 vardims];
                h5rank = 1;
                long_tall = 0;
            else
                h5rank = 2;
                if length(tdata(1,:)) > length(tdata(:,1))
                    long_tall = 0;
                else
                    long_tall = 1;
                end
            end
            if subset_group == 1
                %%%%%%%%%%% The subset case for both photon counts and segment
                %%%%%%%%%%% counting variables
                if max(vardims) == length_40
                    if h5rank == 1
                        tdata = tdata(inds40);
                    else
                        if long_tall == 0
                            tdata = tdata(:,inds40);
                        else
                            tdata = tdata(inds40,:);
                        end
                    end
                elseif max(vardims) == length_1;
                    if h5rank == 1
                        tdata = tdata(inds1);
                    else
                        if long_tall == 0
                            tdata = tdata(:,inds1);
                        else
                            tdata = tdata(inds1,:);
                        end
                    end
                end
                
            end
            
            wrt_str = ['output',rn3,varname,' = tdata;'];
            eval(wrt_str);
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% Loop into the subgroups
    for j = 1:length(I.Groups(i).Groups)
        %%%%% Get the new naming structure
        rn = I.Groups(i).Groups(j).Name;
        rn2 = strsplit(rn,'/');
        rn_str = ['rn3 = strcat('];
        for k = 1:length(rn2)
            rn_str = [rn_str,'''',rn2{k},''',''.'','];
        end
        rn_str = [rn_str(1:end-1),');'];
        eval(rn_str);
        
        %%%%% Loop through the attributes and save them into the meta
        %%%%% substructure
        for k = 1:length(I.Groups(i).Groups(j).Attributes)
            wrt_str = ['output',rn3,'Meta.',I.Groups(i).Groups(j).Attributes(k).Name,' = I.Groups(i).Groups(j).Attributes(k).Value;'];
            eval(wrt_str)
        end
        
        
        %%%%% Loop through the datasets for this group
        for k = 1:length(I.Groups(i).Groups(j).Datasets)
            vardims = I.Groups(i).Groups(j).Datasets(k).Dataspace.Size;
            varname = I.Groups(i).Groups(j).Datasets(k).Name;
            
            if name_comp == 0 | strcmp_ndh(keep_vars,varname) == 1
                
                wrt_str = ['tdata = h5read(h5_file,[''',rn,''',''/'',''',varname,''']);'];
                eval(wrt_str)
                if length(vardims) == 1
                    vardims = [1 vardims];
                    h5rank = 1;
                    long_tall = 0;
                else
                    h5rank = 2;
                    if length(tdata(1,:)) > length(tdata(:,1))
                        long_tall = 0;
                    else
                        long_tall = 1;
                    end
                end
                if subset_group == 1
                    %%%%%%%%%%% The subset case for both photon counts and segment
                    %%%%%%%%%%% counting variables
                    if max(vardims) == length_40
                        if h5rank == 1
                            tdata = tdata(inds40);
                        else
                            if long_tall == 0
                                tdata = tdata(:,inds40);
                            else
                                tdata = tdata(inds40,:);
                            end
                        end
                    elseif max(vardims) == length_1;
                        if h5rank == 1
                            tdata = tdata(inds1);
                        else
                            if long_tall == 0
                                tdata = tdata(:,inds1);
                            else
                                tdata = tdata(inds1,:);
                            end
                        end
                    end
                    
                end
                
                wrt_str = ['output',rn3,varname,' = tdata;'];
                eval(wrt_str);
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% Loop into the subgroups one more time
            for k = 1:length(I.Groups(i).Groups(j).Groups)
                %%%%% Get the new naming structure
                rn = I.Groups(i).Groups(j).Groups(k).Name;
                rn2 = strsplit(rn,'/');
                rn_str = ['rn3 = strcat('];
                for l = 1:length(rn2)
                    rn_str = [rn_str,'''',rn2{l},''',''.'','];
                end
                rn_str = [rn_str(1:end-1),');'];
                eval(rn_str);
                
                %%%%% Loop through the attributes and save them into the meta
                %%%%% substructure
                for l = 1:length(I.Groups(i).Groups(j).Groups(k).Attributes)
                    if max(rn3 == '-') == 1
                        rn3(find(rn3 == '-')) = [];
                    end
                    wrt_str = ['output',rn3,'Meta.',I.Groups(i).Groups(j).Groups(k).Attributes(l).Name,' = I.Groups(i).Groups(j).Groups(k).Attributes(l).Value;'];
                    eval(wrt_str)
                end
                
                
                %%%%% Loop through the datasets for this group
                for kk = 1:length(I.Groups(i).Groups(j).Groups(k).Datasets)
                    vardims = I.Groups(i).Groups(j).Groups(k).Datasets(kk).Dataspace.Size;
                    varname = I.Groups(i).Groups(j).Groups(k).Datasets(kk).Name;
                    
                    if name_comp == 0 | strcmp_ndh(keep_vars,varname) == 1
                        
                        wrt_str = ['tdata = h5read(h5_file,[''',rn,''',''/'',''',varname,''']);'];
                        eval(wrt_str)
                        if length(vardims) == 1
                            vardims = [1 vardims];
                            h5rank = 1;
                            long_tall = 0;
                        else
                            h5rank = 2;
                            if length(tdata(1,:)) > length(tdata(:,1))
                                long_tall = 0;
                            else
                                long_tall = 1;
                            end
                        end
                        if subset_group == 1
                            %%%%%%%%%%% The subset case for both photon counts and segment
                            %%%%%%%%%%% counting variables
                            if max(vardims) == length_40
                                if h5rank == 1
                                    tdata = tdata(inds40);
                                else
                                    if long_tall == 0
                                        tdata = tdata(:,inds40);
                                    else
                                        tdata = tdata(inds40,:);
                                    end
                                end
                            elseif max(vardims) == length_1;
                                if h5rank == 1
                                    tdata = tdata(inds1);
                                else
                                    if long_tall == 0
                                        tdata = tdata(:,inds1);
                                    else
                                        tdata = tdata(inds1,:);
                                    end
                                end
                            end
                            
                        end
                        
                        
                        wrt_str = ['output',rn3,varname,' = tdata;'];
                        eval(wrt_str);
                        
                    end
                end
                
            end
            
        end
        
    end
    
    
end