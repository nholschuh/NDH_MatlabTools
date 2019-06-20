function reducebyline(datafile,first,last,type)
% Takes an aggregated data or pick file and reduces it to just the
% sub-lines provided in linenums. type=0 for data, type=1 for picks

loadstring = ['load ',datafile];
eval(loadstring);
datarange = start_indecies(first):(start_indecies(last+1)-1);

start_indecies = start_indecies-start_indecies(first)+1;
start_indecies = start_indecies(first:(last+1));

if type == 0
    AggregatedData = AggregatedData(:,datarange);
    Data_Vals = Data_Vals(datarange,:);
    
    savestring = ['save ',datafile,' AggregatedData DV_info Data_Vals Time start_indecies'];
    eval(savestring);
    
elseif type == 1
    Picks = Picks(datarange,:);
    
    savestring = ['save ',datafile,' Picks Picks_info start_indecies'];
    eval(savestring);
end

end