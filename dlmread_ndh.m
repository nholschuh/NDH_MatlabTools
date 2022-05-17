function [data] = dlmread_ndh(filename,delimit_opt,forcefieldnames)
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here's where we generate the field names if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% available


if exist('forcefieldnames') == 0

fid = fopen(filename);
tl = fgets(fid);




fclose(fid);
if tl(1) == '>';
    tl = tl(2:end);
end

if delimit_opt == '\t';
    rep_inds = find(tl == char(9) | tl == char(10) | tl == char(13));
else
    rep_inds = find(tl == delimit_opt | tl == char(10) | tl == char(13));
end

rep_inds = [0 rep_inds];
field_counter = 1;
for i = 1:length(rep_inds)-1
    if rep_inds(i+1)-rep_inds(i) > 1
        field_names{field_counter} = tl(rep_inds(i)+1:rep_inds(i+1)-1);
        field_counter = field_counter+1;
    end
end

if length(field_names{end}) == 9
    if field_names{end} == '[[notes]]'
        notes_flag = 1;
        field_names{end} = 'notes';
    else
        notes_flag = 0;
    end
else
    notes_flag = 0;
end

%%%%%%%%%%%%% The case where there are no headers
if isstrprop(tl(1),'digit') == 1 | (tl(1) == '-' & isstrprop(tl(2),'digit') == 1);
    field_names = cell(1,length(field_names));
    for i = 1:length(field_names)
        field_names{i} = ['field_',num2str(i)];
    end
end
else
   field_names = forcefieldnames;
   field_counter = length(field_names);
   notes_flag = 0;
end

for i = 1:length(field_names)
    field_names{i} = remove_illegalcharacters(field_names{i},'()');
end



fid = fopen(filename);
tl = fgets(fid);
counter = 1;

data_cell = {};
cell_counter = 1;
while tl ~= -1
    tl = fgets(fid);
    
    %%%%%%%%%%%%%%%%%%%%%%% Here we deal with a line break
    if tl(1) == '>';
        data_cell{cell_counter,1} = in_data;
        if notes_flag == 1
            data_cell{cell_counter,2} = notes;
        else
            data_cell{cell_counter,2} = [];
        end
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
        
        counter2 = 1;
        
        if notes_flag == 0
            notes_addition = 1;
        else
            notes_addition = 0;
        end
        
        %%%%%%%%%%%%%%%%%%%% If there is a notes field, this accounts for
        %%%%%%%%%%%%%%%%%%%% that
        for i = 1:length(rep_inds)-1
            if rep_inds(i+1)-rep_inds(i) > 1 & counter2 < length(field_names)+notes_addition
                in_data(counter,counter2) = eval(tl(rep_inds(i)+1:rep_inds(i+1)-1));
                counter2 = counter2+1;
            elseif rep_inds(i+1)-rep_inds(i) > 1
                notes{counter} = tl(rep_inds(i)+1:rep_inds(i+1)-1);
            end
        end
        counter = counter+1;
    end
end
fclose(fid);
    


data = struct();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here we write the out_data
if notes_flag == 0
    %%%%%%%%%%%%%%%%%%%%%% The case where there's a single line
    if length(data_cell) == 0
        for i = 1:length(field_names)
            eval_str = ['data.',field_names{i},' = in_data(:,',num2str(i),');'];
            eval(eval_str);
        end
    else
        %%%%%%%%%%%%%%%%%%%%%% The case where there's multiple_lines
        for j = 1:length(data_cell(:,1))
            for i = 1:length(field_names)
                eval_str = ['data(j).',field_names{i},' = data_cell{j,1}(:,',num2str(i),');'];
                eval(eval_str);
            end
        end
    end
else
    %%%%%%%%%%%%%%%%%%%%%% The case where there's a single line
    if length(data_cell) == 0
        for i = 1:length(field_names)-1
            for j = 1:length(in_data(:,1));
                eval_str = ['data(j).',field_names{i},' = in_data(j,',num2str(i),');'];
                eval(eval_str);
            end
        end
        for j = 1:length(in_data(:,1))
            data(j).notes = notes{j}(3:end-2);
        end
    else
        for kk = 1:length(data_cell(:,1))
            for i = 1:length(field_names)-1
                for j = 1:length(in_data(:,1));
                    eval_str = ['data(kk).line(j).',field_names{i},' =  data_cell{kk,1}(j,',num2str(i),');'];
                    eval(eval_str);
                end
            end
            for j = 1:length(in_data(:,1))
                data(kk).line(j).notes = data_cell{kk,2}{j}(3:end-2);
            end
        end
    end
end

end
