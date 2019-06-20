function CreSIS_Aggregate_Subselect(ant_or_green)
%%
file = dir('*Aggregated*');
load(file.name)
name_start = strsplit(file.name,'_');

if exist('ant_or_green') == 0
    ant_or_green = 2;
end

if ant_or_green == 1
    figure();
    set(gcf,'Position',[394   142   713   713])
    groundingline(1)
else
    figure();
    set(gcf,'Position',[394   142   713   939])
    groundingline(5)
end

plot(Data_Vals(:,1),Data_Vals(:,2),'.','Color','blue')

[a b c d] = select_points_corners(Data_Vals,1,2);

varstr1 = ['Time_',name_start{1},'_',name_start{2},' = Time;'];
varstr2 = ['MetaData_',name_start{1},'_',name_start{2},' = Data_Vals(b,:);'];
varstr3 = ['Data_',name_start{1},'_',name_start{2},' = AggregatedData(:,b);'];
varstr4 = ['Meta = DV_info;'];


eval(varstr1)
eval(varstr2)
eval(varstr3)
eval(varstr4)

save_string = ['save(''',name_start{1},'_',name_start{2},'_subset.mat'',''Time_',name_start{1},'_',name_start{2},''',''MetaData_',name_start{1},'_',name_start{2},''',''Data_',name_start{1},'_',name_start{2},''',''Meta'')'];
eval(save_string)

end