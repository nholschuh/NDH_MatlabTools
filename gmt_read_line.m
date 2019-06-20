function line_data = gmt_read_line(file)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
% This reads in a line file structured using GMT conventions. New lines
% start with a > symbol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% file - the input file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


fid = fopen(file);
tline = fgetl(fid);
lineNumber = 1;
file_cont = {};
while ischar(tline)
    file_cont{lineNumber} = tline;
    tline = fgetl(fid);
    lineNumber = lineNumber + 1;
end


line_data = {};
file_line=1;
line_counter=1;
newline_index=1;
select_inds = [];
while file_line < length(file_cont)-2;
    while file_cont{file_line}(1) ~= '>' && file_cont{file_line}(1) ~= '#' && file_line < length(file_cont)-1 ;
        temp = strsplit(file_cont{file_line});
        
        if isempty(select_inds) == 1
            for i = 1:length(temp)
                select_inds(i) = isnum(temp{i});
            end
            select_inds = find(select_inds);
        end
        
        line_entry = [];
        for i = select_inds
            line_entry = [line_entry eval(temp{i})];
        end
        
        line_data{line_counter}(newline_index,:) = line_entry;

        newline_index = newline_index+1;
        file_line=file_line+1;
    end
    line_counter = line_counter+1;
    newline_index = 1;
    file_line = file_line+1;
end
    
remove_ind = [];
for i = 1:length(line_data)
    if isempty(line_data{i}) == 1
        remove_ind = [remove_ind i];
    end
end

line_data(remove_ind) = [];

if length(line_data) == 1
    line_data = line_data{1};
end













fclose(fid);
