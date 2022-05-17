function [data] = dlmread_ndh(filename,delimit_opt)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% Reads a text file created by dlmwrite_ndh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - the filename (including extension) to write to
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('delimit_opt') == 0;
    delimit_opt = '\t';
end

fid = fopen(filename);
tl = fgets(fid);


if tl(1) == '>';
    tl = tl(2:end);
end




fid = fopen(filename);
tl = fgets(fid);
counter = 1;

data_cell = {};
in_data = [];
cell_counter = 1;
counter2 = 1;

while tl ~= -1
    tl = fgets(fid);
    
    %%%%%%%%%%%%%%%%%%%%%%% Here we deal with a line break
    if tl(1) == '>';
        data_cell{cell_counter,1} = in_data;
            data_cell{cell_counter,2} = [];
        in_data = [];
        notes = {};
        cell_counter = cell_counter+1;
        counter = 1;
        
        %%%%%%%%%%%%%%%%%%%%%%% Here we read in the data
    else
        
        if delimit_opt == '\t';
            rep_inds = find(tl == char(9) | tl == char(10) | tl == char(13));
        else
            rep_inds = find(tl == delimit_opt | tl == char(10) | tl == char(13));
        end
        rep_inds = [0 rep_inds];
        rm_ind = find(diff(rep_inds) <= 1);
        rep_inds(rm_ind+1) = [];
        
        for i = 1:length(rep_inds)-1
            in_data(counter,counter2) = eval(tl(rep_inds(i)+1:rep_inds(i+1)-1));
            counter2 = counter2+1;
        end
        counter2 = 1;
        
        counter = counter+1;
    end
end
fclose(fid);


    %%%%%%%%%%%%%%%%%%%%%% The case where there's multiple_lines

keep = [];
for i = 1:length(data_cell(:,2));
    if isempty(data_cell{i,1}) == 1
    else
        nan_vec = ones(size(data_cell{i,1}(1,:)))*NaN;
        keep = [keep i];
    end
end

data = [];
data_cell2 = data_cell(keep,1);

for j = 1:length(data_cell2(:,1))
    data = [data; nan_vec; data_cell2{j}];
end

end
