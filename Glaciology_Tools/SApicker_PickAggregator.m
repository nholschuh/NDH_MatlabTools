function PickAggregator(interface_descriptor,directory_addon,pickprefix)
% Aggregates all picks from a stointerpret picked dataset. Interface
% descriptor values are 0=bed 1=internal 2=surface (Default 0).

currentdirectory = pwd;

if exist('directory_addon')==1
    currentdirectory = [currentdirectory '\' directory_addon];
    files_list = dir(['.\',directory_addon,'\',pickprefix,'_*.mat']);
else
    files_list = dir([pickprefix,'_*']);
end

[upperPath, savename, ~] = fileparts(currentdirectory);


if exist('interface_descriptor') == 0
    interface_descriptor = 0;
end


if interface_descriptor == 0
    ids = 'Bed';
elseif interface_descriptor == 1
    ids = 'Internal';
elseif interface_descriptor == 2
    ids = 'Surface';
end



start_indecies = [1];

Picks = [];

for i = 1:length(files_list)
    if exist('directory_addon')==1
        loadstring = ['load .\',directory_addon,'\',files_list(i).name];
    else
        loadstring = ['load ',files_list(i).name];
    end

    eval(loadstring)

    var_interest = who('*_*_*');
    var_rename_string = ['datavar = ',var_interest{i},';'];
    eval(var_rename_string);

    
    [x y] = polarstereo_fwd(datavar(:,8),datavar(:,9));
      
    Picks = [Picks; [x y datavar(:,8) datavar(:,9) datavar(:,1)]];
    
    start_indecies = [start_indecies start_indecies(i)+length(x)];
end

%start_indecies = start_indecies(1:(length(start_indecies)-1));

pickrename = [ids,'picks = Picks;'];
eval(pickrename);

Picks_info = {'x_coord','y_coord','latitude','longitude','interface_pick'};

savestring = ['save ',savename,'_',ids,'picks.mat ',ids,'picks Picks_info start_indecies'];
eval(savestring)

end
    
    



