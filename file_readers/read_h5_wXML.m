function [output]=read_h5_wXML(h5_file)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Note: For files that use the LZF filter, it must be downloaded,
%%%%%%% compiled, and the Windows environment variable HDF5_PLUGIN_PATH must
%%%%%%% be set to the compilation directory. This required me to compile a
%%%%%%% dll in visual studio and registere the filter using

I=h5info(h5_file,'/');

for i = 2:length(I.Datasets)
    wrt_str = ['output.',remove_illegalcharacters(I.Datasets(i).Name),' = h5read(h5_file,[''/',I.Datasets(i).Name,''']);'];
    eval(wrt_str)
    
    for ll = 1:length(I.Datasets(i).Attributes)
        temp = I.Datasets(i).Attributes(ll).Value;
        temp_struct = parse_xmlstring(temp{1});
        new_temp_struct = [];
        for lll = 1:length(temp_struct.Children);
            if length(temp_struct.Chidren(lll).Children) == 1
                wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Name,' = ',temp_struct.Chidren(lll).Children.Data];
                eval(wrt_str);
            elseif length(temp_struct.Chidren(lll).Children) == 5
                wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Children(2).Data,' = ',temp_struct.Chidren(lll).Children(4).Data];
                eval(wrt_str);
            end
        end
        
        wrt_str = ['output.',remove_illegalcharacters(I.Datasets(i).Attributes(ll).Name),' = new_temp_struct;'];
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
        wrt_str = ['output',rn3,'Meta.',remove_illegalcharacters(I.Groups(i).Attributes(j).Name),' = I.Groups(i).Attributes(j).Value;'];
        eval(wrt_str)
    end
    
    %%%%% Loop through the datasets for this group
    for j = 1:length(I.Groups(i).Datasets)
        wrt_str = ['output',rn3,remove_illegalcharacters(I.Groups(i).Datasets(j).Name),' = h5read(h5_file,[''',rn,''',''/'',''',I.Groups(i).Datasets(j).Name,''']);'];
        eval(wrt_str)
        
        for ll = 1:length(I.Groups(i).Datasets(j).Attributes)
            temp = I.Groups(i).Datasets(j).Attributes(ll).Value;
            temp_struct = parse_xmlstring(temp{1});
            new_temp_struct = [];
            for lll = 1:length(temp_struct.Children);
                if length(temp_struct.Chidren(lll).Children) == 1
                    wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Name,' = ',temp_struct.Chidren(lll).Children.Data];
                    eval(wrt_str);
                elseif length(temp_struct.Chidren(lll).Children) == 5
                    wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Children(2).Data,' = ',temp_struct.Chidren(lll).Children(4).Data];
                    eval(wrt_str);
                end
            end
            
            wrt_str = ['output.',remove_illegalcharacters(I.Datasets(i).Attributes(ll).Name),' = new_temp_struct;'];
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
            for ll = 1:length(I.Groups(i).Groups(j).Datasets(k).Attributes)
                temp = I.Groups(i).Groups(j).Datasets(k).Attributes(ll).Value;
                temp_struct = parse_xmlstring(temp{1});
                new_temp_struct = [];
                for lll = 1:length(temp_struct.Children);
                    if length(temp_struct.Chidren(lll).Children) == 1
                        wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Name,' = ',temp_struct.Chidren(lll).Children.Data];
                        eval(wrt_str);
                    elseif length(temp_struct.Chidren(lll).Children) == 5
                        wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Children(2).Data,' = ',temp_struct.Chidren(lll).Children(4).Data];
                        eval(wrt_str);
                    end
                end
                
                wrt_str = ['output.',remove_illegalcharacters(I.Groups(i).Groups(j).Datasets(k).Attributes(ll).Name),' = new_temp_struct;'];
                eval(wrt_str)
            end
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
                for ll = 1:length(I.Groups(i).Groups(j).Groups(k).Datasets(l).Attributes)
                    temp = I.Groups(i).Groups(j).Groups(k).Datasets(l).Attributes(ll).Value;
                    
                    if iscell(temp) == 0
                        temp = {temp};
                    end
                    
                    if str_contain(temp{1},'<');
                        temp_struct = parse_xmlstring(temp{1});
                        new_temp_struct = [];
                        for lll = 1:length(temp_struct.Children);
                            if length(temp_struct.Children(lll).Children) == 1
                                wrt_str = ['new_temp_struct.',remove_illegalcharacters(temp_struct.Children(lll).Name,' .()'),' = temp_struct.Children(lll).Children.Data;'];
                                eval(wrt_str);
                            elseif length(temp_struct.Children(lll).Children) == 5
                                if length(temp_struct.Children(lll).Children(4).Children) > 0
                                    wrt_str = ['new_temp_struct.',remove_illegalcharacters(temp_struct.Children(lll).Children(2).Children.Data,' .()'),' = temp_struct.Children(lll).Children(4).Children.Data;'];
                                    eval(wrt_str);
                                end
                            end
                        end
                        wrt_str = ['output',rn3,remove_illegalcharacters(I.Groups(i).Groups(j).Groups(k).Datasets(l).Attributes(ll).Name),' = new_temp_struct;'];
                        eval(wrt_str)
                        
                    else
                        temp_struct = strsplit(temp{1},{':',','},'CollapseDelimiters',false);
                        for lll = 1:length(temp_struct)/2
                            wrt_str = ['new_temp_struct.',temp_struct{lll*2-1},' = ',temp_struct{lll*2},';'];
                            eval(wrt_str);
                        end
                        wrt_str = ['output',rn3,remove_illegalcharacters(I.Groups(i).Groups(j).Groups(k).Datasets(l).Attributes(ll).Name),' = new_temp_struct;'];
                        eval(wrt_str)
                    end
                end
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% Loop into the subgroups one more time
            for kk = 1:length(I.Groups(i).Groups(j).Groups(k).Groups)
                %%%%% Get the new naming structure
                rn = I.Groups(i).Groups(j).Groups(k).Groups(kk).Name;
                rn2 = strsplit(rn,'/');
                rn_str = ['rn3 = strcat('];
                for l = 1:length(rn2)
                    rn_str = [rn_str,'''',rn2{l},''',''.'','];
                end
                rn_str = [rn_str(1:end-1),');'];
                eval(rn_str);
                
                %%%%% Loop through the attributes and save them into the meta
                %%%%% substructure
                for l = 1:length(I.Groups(i).Groups(j).Groups(k).Groups(kk).Attributes)
                    if max(rn3 == '-') == 1
                        rn3(find(rn3 == '-')) = [];
                    end
                    wrt_str = ['output',rn3,'Meta.',I.Groups(i).Groups(j).Groups(k).Groups(kk).Attributes(l).Name,' = I.Groups(i).Groups(j).Groups(k).Groups(kk).Attributes(l).Value;'];
                    eval(wrt_str)
                end
                
                %%%%% Loop through the datasets for this group
                for l = 1:length(I.Groups(i).Groups(j).Groups(k).Groups(kk).Datasets)
                    wrt_str = ['output',rn3,remove_illegalcharacters(I.Groups(i).Groups(j).Groups(k).Groups(kk).Datasets(l).Name),' = h5read(h5_file,[''',rn,''',''/'',''',I.Groups(i).Groups(j).Groups(k).Groups(kk).Datasets(l).Name,''']);'];
                    eval(wrt_str)
                    for ll = 1:length(I.Groups(i).Groups(j).Groups(k).Groups(kk).Datasets(l).Attributes)
                        temp = I.Groups(i).Groups(j).Groups(k).Groups(kk).Datasets(l).Attributes(ll).Value;
                        temp_struct = parse_xmlstring(temp{1});
                        new_temp_struct = [];
                        for lll = 1:length(temp_struct.Children);
                            if length(temp_struct.Chidren(lll).Children) == 1
                                wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Name,' = ',temp_struct.Chidren(lll).Children.Data];
                                eval(wrt_str);
                            elseif length(temp_struct.Chidren(lll).Children) == 5
                                wrt_str = ['new_temp_struct.',temp_struct.Chidren(lll).Children(2).Data,' = ',temp_struct.Chidren(lll).Children(4).Data];
                                eval(wrt_str);
                            end
                        end
                        
                        wrt_str = ['output',rn3,remove_illegalcharacters(I.Datasets(i).Attributes(ll).Name),' = new_temp_struct;'];
                        eval(wrt_str)
                    end
                end
                
                
            end
        end
    end
end
end