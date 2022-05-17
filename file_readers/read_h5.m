function [output]=read_h5(h5_file,keep_vars)
% (C) Nick Holschuh - University of Washington - 2017 (Holschuh@uw.edu)
% This function reads in the IceSAT .h5 file produced through the NASA SDC
% system, using the land ice algorithm produced by Ben Smith
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% h5_file - string containing either the local or full paht the ATL06 file
% keep_vars - cell array of names to load in
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - structure containing the .h5 information
%       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('keep_vars') == 1
    name_comp = 1;
else
    name_comp = 0;
    keep_vars = {};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Note: For files that use the LZF filter, it must be downloaded,
%%%%%%% compiled, and the Windows environment variable HDF5_PLUGIN_PATH must
%%%%%%% be set to the compilation directory. This required me to compile a
%%%%%%% dll in visual studio and registere the filter using 

I=h5info(h5_file,'/');

    for i = 1:length(I.Datasets)
        wrt_str = ['output.',remove_illegalcharacters(I.Datasets(i).Name),' = h5read(h5_file,[''/',I.Datasets(i).Name,''']);'];
        eval(wrt_str)
        
        for ll = 1:length(I.Datasets(i).Attributes)
            wrt_str = ['output.',remove_illegalcharacters(I.Datasets(i).Attributes(ll).Name),' = I.Datasets(i).Attributes(ll).Value;'];
            eval(wrt_str)
        end
    end

%%%%%%%%%%%%%%% This extracts the attributs of the hd5 file itself, and
%%%%%%%%%%%%%%% saves it to the object GranuleMeta
for i = 1:length(I.Attributes)
    wrt_str = ['output.Meta.',remove_illegalcharacters(I.Attributes(i).Name),' = I.Attributes(i).Value;'];
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
    
    
    %%%%%%%%%%%%%%%%% Here we either read all the data or just the
    %%%%%%%%%%%%%%%%% subsetted data:
    
    %%%%% Loop through the datasets for this group
    for j = 1:length(I.Groups(i).Datasets)
        vardims = I.Groups(i).Datasets(j).Dataspace.Size;
        varname = I.Groups(i).Datasets(j).Name;
        if name_comp == 0 | strcmp_ndh(keep_vars,varname) == 1
            
            wrt_str = ['output',rn3,varname,' = h5read(h5_file,[''',rn,''',''/'',''',varname,''']);'];
            eval(wrt_str)
            
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% Loop into the subgroups
    for j = 1:length(I.Groups(i).Groups)
        %%%%% Get the new naming structure
        rn = I.Groups(i).Groups(j).Name;
        rn2 = strsplit(rn,'/');
        rn_str = ['rn3 = strcat('];
        for k = 1:length(rn2) %%%%%%% This deals with h5 named structures that are numbers (check with ben?)
            if length(rn2{k}) > 0
                if ~isnan(str2double(rn2{k}(1))) | rn2{k}(1) == '-'
                    rn2{k} = ['coord_',rn2{k}];
                end
            end
            rn2{k}(find(rn2{k} == '-')) = 'n';
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
                
                wrt_str = ['output',rn3,varname,' = h5read(h5_file,[''',rn,''',''/'',''',varname,''']);'];
                eval(wrt_str)
                
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% Loop into the subgroups one more time
        for k = 1:length(I.Groups(i).Groups(j).Groups)
            %%%% Get the new naming structure
            rn = I.Groups(i).Groups(j).Groups(k).Name;
            rn2 = strsplit(rn,'/');
            rn_str = ['rn3 = strcat('];
            for l = 1:length(rn2)
                rn_str = [rn_str,'''',rn2{l},''',''.'','];
            end
            rn_str = [rn_str(1:end-1),');'];
            eval(rn_str);
            
            %%%% Loop through the attributes and save them into the meta
            %%%% substructure
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
                    
                    
                    wrt_str = ['output',rn3,varname,' = h5read(h5_file,[''',rn,''',''/'',''',varname,''']);'];
                    eval(wrt_str)
                    
                end
            end
            
        end
        
    end
    
    
    
    
end

    
    
    
end