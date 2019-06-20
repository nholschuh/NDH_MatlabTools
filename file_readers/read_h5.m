function [output]=read_h5(h5_file)
% (C) Nick Holschuh - University of Washington - 2017 (Holschuh@uw.edu)
% This function reads in the IceSAT .h5 file produced through the NASA SDC
% system, using the land ice algorithm produced by Ben Smith
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% h5_file - string containing either the local or full paht the ATL06 file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - structure containing the .h5 information
%       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


I=h5info(h5_file,'/');

    for i = 1:length(I.Datasets)
        wrt_str = ['output.',remove_illegalcharacters(I.Datasets(i).Name),' = h5read(h5_file,[''/',I.Datasets(i).Name,''']);'];
        eval(wrt_str)        
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
        wrt_str = ['output',rn3,'Meta.',remove_illegalcharacters(I.Groups(i).Attributes(j).Name),' = I.Groups(i).Attributes(j).Value;'];
        eval(wrt_str)
    end
    
    %%%%% Loop through the datasets for this group
    for j = 1:length(I.Groups(i).Datasets)
        wrt_str = ['output',rn3,remove_illegalcharacters(I.Groups(i).Datasets(j).Name),' = h5read(h5_file,[''',rn,''',''/'',''',I.Groups(i).Datasets(j).Name,''']);'];
        eval(wrt_str)        
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
            wrt_str = ['output',rn3,I.Groups(i).Groups(j).Datasets(k).Name,' = h5read(h5_file,[''',rn,''',''/'',''',I.Groups(i).Groups(j).Datasets(k).Name,''']);'];
            eval(wrt_str)
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
            for l = 1:length(I.Groups(i).Groups(j).Groups(k).Datasets)
                wrt_str = ['output',rn3,remove_illegalcharacters(I.Groups(i).Groups(j).Groups(k).Datasets(l).Name),' = h5read(h5_file,[''',rn,''',''/'',''',I.Groups(i).Groups(j).Groups(k).Datasets(l).Name,''']);'];
                eval(wrt_str)
            end
            
        end
        
    end
end
    
    
    
end