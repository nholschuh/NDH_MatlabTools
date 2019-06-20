function total = Aggregate_Files(name_prefix,name_suffix,save_flag,save_name,exclude_opts,include_opts,info_from_name_ind);
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This is designed to aggregate files with a similar structure, such that
% it combines variables of like name into a single complete variable for
% all the data sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% name_prefix - String that defines the first part of the filenames ([]),
%               or a cell array containing the explicit file names
% name_suffix - String that defines the last part of the filenames ([])
% save_flag - 1 = write output to a file with the name...
% save_name
% info_from_name_ind - If desired, these are the indecies that correspond
% to a number in the name of the files that you want appended to the
% entries associated with that file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('save_flag') == 0
    save_flag = 0;
end
if exist('save_name') == 0
    save_flag = 0;
    save_name = 0;
end

if exist('exclude_opts') == 0
    exclude_opts = {};
end
if iscell(exclude_opts) == 0
    exclude_opts = {exclude_opts};
end

if exist('include_opts') == 0
    include_opts = {};
end

if iscell(name_prefix) == 1
    for i = 1:length(name_prefix)
        files(i).name = name_prefix{i};
    end
else
    files = dir([name_prefix,'*',name_suffix]);
end


for i = 1:length(files);
    sv_max = 0;
    load(files(i).name)
    %%%%% Initialize the variables:
    if i == 1
        file_obj = matfile(files(i).name);
        var_list = whos(file_obj); 
        
        %%%%% This is designed to identify the variable to count when
        %%%%% aggregating
        sv_max = max(var_list(1).size);
        sv_max_ind = 1;
        
        %%%%% Find those variables that contain the name 'meta', to not
        %%%%% aggregate, and identify the orientation of the different
        %%%%% variables
        exclude_flag = zeros(length(var_list),1);
        orientation_flag = zeros(length(var_list),1);
        
        exclude_flag = ones(length(var_list),1);
        for j = 1:length(var_list)
            
            if length(include_opts) == 0
                if str_contain(var_list(j).name,'meta')
                    exclude_flag(j) = 1;
                end
                
                for k = 1:length(exclude_opts)
                    if length(var_list(j).name) == length(exclude_opts{k});
                        if var_list(j).name == exclude_opts{k}
                            exclude_flag(j) = 1;
                            break
                        end
                    end
                end
            else
                 for k = 1:length(include_opts)
                    if length(var_list(j).name) == length(include_opts{k});
                        if var_list(j).name == include_opts{k}
                            exclude_flag(j) = 0;
                            break
                        end
                    end
                end               
            end
            
            if max(var_list(j).size) > sv_max;
                sv_max = max(var_list(j).size);
                sv_max_ind = j;
            end
            if var_list(j).size(1) > var_list(j).size(2)
                orientation_flag(j) = 1;
            else
                orientation_flag(j) = 2;
            end
            if length(var_list(j).class) == 6
                if var_list(j).class == 'struct'
                    struct_flag(j) = 1;
                else
                    struct_flag(j) = 0;
                end
            else
                struct_flag(j) = 0;
            end
            
            %%%%%%%%%%%%%%%% This sets up an exception for image data from
            %%%%%%%%%%%%%%%% radar files
            if length(var_list(j).name) == 4; if var_list(j).name == 'data'
                 orientation_flag(j)  = 2;   
            end;end;
            if length(var_list(j).name) == 7; if var_list(j).name == 'migdata' | var_list(j).name == 'nmodata' 
                 orientation_flag(j) = 2;    
            end;end;            
            if length(var_list(j).name) == 8; if var_list(j).name == 'filtdata'
                 orientation_flag(j) = 2;   
            end;end; 
        end
        
        %%%%% Initialize all of the total variables with those contained in
        %%%%% the first file, including the meta variables
        for j = 1:length(var_list)
                    add_str = ['total.',var_list(j).name,' = [',var_list(j).name,'];'];
                    eval(add_str);
        end
        
        total.file_num = ones(sv_max,1)*i;
        if exist('info_from_name_ind') == 1
            info = files(i).name(info_from_name_ind);
            info = eval(info);
            total.info = ones(sv_max,1)*info;
        end
    %%%%% for all subsequent files
    else
        for j = 1:length(var_list)         
            if exclude_flag(j) == 0 & struct_flag(j) == 0
                if orientation_flag(j) == 1
                    add_str = ['total.',var_list(j).name,' = [total.',var_list(j).name,'; ',var_list(j).name,'];'];
                    eval(add_str);
                else
                    add_str = ['total.',var_list(j).name,' = [total.',var_list(j).name,' ',var_list(j).name,'];'];
                    eval(add_str);
                end
            elseif struct_flag(j) == 1 & exclude_flag(j) == 0
                add_str = ['total.',var_list(j).name,'(j) = [',var_list(j).name,'];'];
                eval(add_str);
            end
        end
        
        sv_max = max(size(eval(var_list(sv_max_ind).name)));
        total.file_num = [total.file_num; ones(sv_max,1)*i];
        if exist('info_from_name_ind') == 1
            info = files(i).name(info_from_name_ind);
            info = eval(info);
            total.info = [total.info; ones(sv_max,1)*info];
        end
    end

end


if save_flag == 1
    save_str = ['save(''',save_name,'.mat'','];
    fs = fields(total);
    for i = 1:length(fs)
        rename_str = [fs{i},' = total.',fs{i},';'];
        eval(rename_str)
        save_str = [save_str,'''',fs{i},''','];
    end
    save_str = [save_str(1:end-1),');'];
    eval(save_str) 
end

