function sto_subset(filename,traceinds,timeinds);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Reads in a 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inp1 - 
% inp2 - 
% inp3 - 
% inp4 - 
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

load(filename)

if exist('timeinds') == 0
    timeinds = 1:length(travel_time);
end

vars = whos('-file',filename);

if exist('migdata') == 1
    tempdata = migdata;
end
if exist('tempdata') == 0 & exist('interp_data') == 1
    tempdata = interp_data;
end


if traceinds == 0
    imagesc(lp(tempdata));
    colormap(gray);
    opts = graphical_selection(1);
    traceinds = max([round(opts(1,1)) 1]):min([round(opts(2,1)) length(tempdata(1,:))]);
    timeinds = max([round(opts(1,2)) 1]):min([round(opts(2,2)) length(travel_time)]);
end

for i = 1:length(vars)
    if min(vars(i).size == 1) == 1
        rn_str = [' '];
        tempval_str = ['tempval = ',vars(i).name,';'];
        eval(tempval_str)
        if isnumeric(tempval)
            if tempval == length(tempdata(1,:))
                rn_str = [vars(i).name,' = length(traceinds);'];
            end
            if tempval == length(tempdata(:,1))
                rn_str = [vars(i).name,' = length(timeinds);'];
            end
            eval(rn_str);
        end
    end
end

for i = 1:length(vars)
    reshape_str = [];
    %%%%%%%%%%%%%%% indexed on number of traces
    if max(vars(i).size == length(tempdata(1,:))) == 1
        if vars(i).size(1) == length(tempdata(1,:))
            reshape_str = [vars(i).name,' = ',vars(i).name,'(traceinds,:);'];
        else
            reshape_str = [vars(i).name,' = ',vars(i).name,'(:,traceinds);'];
        end
        eval(reshape_str)        
    end
    
    if max(vars(i).size == length(tempdata(:,1))) == 1
        if vars(i).size(1) == length(tempdata(:,1))
            reshape_str = [vars(i).name,' = ',vars(i).name,'(timeinds,:);'];
        else
            reshape_str = [vars(i).name,' = ',vars(i).name,'(:,timeinds,:);'];
        end        
        eval(reshape_str) 
    end
end

save_str = ['save(''',filename(1:end-4),'_subset.mat'','];
for i = 1:length(vars)
    save_str = [save_str,'''',vars(i).name,''','];
end
save_str = [save_str(1:end-1),');'];
eval(save_str);
















