%% Time_Shift Interpreter:
tic
dir_prefix = './Agbami_OBN_PSDM/';

cd(dir_prefix)
disp('Load the 8 data volumes:')
files = dir(['*.segy']);
names = {files.name};

file_order = {'Baseline','Monitor','Amplitude Warping','Phase Warping','Amplitude Warping T-Strain','Phase Warping T-Strain','AmpDiff Amplitude Warping','AmpDiff Phase Warping'};
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
    if b5 == 1
        if str_contain(names{i},'AmpDiff_AmpWarping')
            orders(5) = i;
            b5 = 0;
        end
    end
    if b6 == 1
        if str_contain(names{i},'AmpDiff_Phase')
            orders(6) = i;
            b6 = 0;
        end
    end
    if b7 == 1
        if str_contain(names{i},'Amp_Strain')
            orders(7) = i;
            b7 = 0;
        end
    end
    if b8 == 1
        if str_contain(names{i},'Phase_Strain')
            orders(8) = i;
            b8 = 0;
        end
    end
end

%%
if b5 == 1
    disp('(No AmpDiff Volumes Provided)')
end
if b7 == 1
    disp('(No Strain Volumes Provided)')
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
QC_ui(data1,headers1,[1 2 1300],data2,headers2,data3,headers3,data4,headers4,data5,headers5,data6,headers6,data7,headers7,data8,headers8)
