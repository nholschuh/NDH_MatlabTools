function outstruct = rewrite_struct(input_struct)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Takes a structure with a single entry, and fields with multiple entries,
% and converts it to a structure with multiple entries with fields
% containing a single entry. Warning, this requires all fields to have
% entries that are the same length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% input_struct - the structure you want to convert
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outstruct - The final structure output 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

fn = fieldnames(input_struct);

for i = 1:length(fn)
    loop_length = eval(['length(input_struct.',fn{i},')']);
    for j = 1:loop_length
        eval_str = ['outstruct(j).',fn{i},' = input_struct.',fn{i},'(j);'];
        eval(eval_str);
    end
end