%% Time_Shift Interpreter:
tic
dir_prefix = '../Modeled_OBN_Seismic/';

cd(dir_prefix)
disp('Load the 4 data volumes:')
files = dir(['*.segy']);
names = {files.name};

file_order = {'Baseline','Monitor','Amplitude Warping','Phase Warping'};
b1 = 1; b2 = 1; b3 = 1; b4 = 1; b5 = 1; b6 = 1; b7 = 1; b8 = 1;
orders = [];

%%% Determine the files to load -
for i = 1:length(names)
    if b1 == 1
        if str_contain(names{i},'Mon')
            orders(1) = i;
            b1 = 0;
        end
    end
    if b2 == 1
        if str_contain(names{i},'Base')
            orders(2) = i;
            b2 = 0;
        end
    end
    if b3 == 1
        if str_contain(names{i},'tshift_amp')
            orders(3) = i;
            b3 = 0;
        end
    end
    if b4 == 1
        if str_contain(names{i},'tshift_phase')
            orders(4) = i;
            b4 = 0;
        end
    end
end

for i = 1:length(orders)
    
    disp(file_order{i})
    loadstring = ['[data',num2str(i),' headers',num2str(i),'] = ReadSegy(''',files(orders(i)).name,''');'];
    eval(loadstring)
    t = toc;
    disp([num2str(round(i/length(orders)*100)),'% Completed - ',num2str(round(t)),'s Elapsed']);
end

cd ..
%%
close all
QC_ui_simplified(data1,headers1,0,data2,headers2,data3,headers3,data4,headers4)
