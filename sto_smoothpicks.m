function outpicks = sto_smoothpicks(input_pickfile,smoother,outcsv_flag,plotter);
% (C) Nick Holschuh - Amherst College - 2020 (Nick.Holschuh@gmail.com)
% This function takes the saved output from stointerpret and generates a
% smoothed version of the picks (and optionally writes the data out to a
% csv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% input_pickfile - 
% outcsv_flag - 0 or 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
% out2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('smoother') == 0
    smoother = 10;
end
if exist('outcsv_flag') == 0
    outcsv_flag = 0;
end
if exist('plotter') == 0
    plotter = 0;
end

load(input_pickfile)

if plotter == 1
    hold off
end

for i = 1:length(picks.samp2(:,1));
    outpicks(i,:) = smooth_ndh(picks.samp2(i,:),5,1);
    if plotter == 1
        plot(picks.samp2(i,:),'Color','black')
        hold all
        plot(outpicks(i,:),'Color','red')
    end
        
end


outpicks = sortrows(outpicks);
if outcsv_flag == 1
    for i = 1:length(outpicks(1,:))
        column_index{i} = sprintf('%0.5d',i);
    end
    table_string = ['outtable = table('];
    for i = 1:length(outpicks(:,1))
        eval(['Reflector_',sprintf('%0.2d',i),' = round(outpicks(i,:))'';']);
        table_string = [table_string,'Reflector_',sprintf('%0.2d',i),','];
    end
    table_string = [table_string(1:end-1),',''RowNames'',column_index);'];
    eval(table_string);
    writetable(outtable,[input_pickfile(1:end-3),'csv']);
end
    

