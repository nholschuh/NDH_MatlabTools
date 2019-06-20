function outstruct = get_structfields(input_structure,field_inds,outform)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% Takes an input structure and outputs a structure with only a subset of
% the fields. Will output to a matrix if preferred.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input_structure - The power values to compute the fft on
% field_inds - either the index values or the titles of fields to subset
% outform - [0] = structure, 1 = matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('outform') == 0
    outform = 0;
end

infields = fields(input_structure);

if iscell(field_inds) == 1
    final_field_inds = zeros(1,length(field_inds));
    for i = 1:length(field_inds)
        for j = 1:length(infields)
            if length(field_inds{i}) == length(infields{j})
                if field_inds{i} == infields{j}
                    final_field_inds(i) = j;
                end
            end
        end
    end
    
    %%%%%%%%%% The error message
    out_nans = find(final_field_inds == 0);
    if length(out_nans) > 0
        disp(['Missing Fields:'])
        disp('--------------')
        for i = 1:length(out_nans)
            disp(field_inds{i});
        end
    end
    
    field_inds = final_field_inds(find(final_field_inds ~= 0));
end




if outform == 0
    outstruct = struct();
    for i = 1:length(field_inds)
        write_str = ['outstruct.',infields{field_inds(i)},' = input_structure.',infields{field_inds(i)},';'];
        eval(write_str)
    end
else
    outstruct = [];
    for i = 1:length(field_inds)
        write_str = ['outstruct(:,',num2str(i),') = input_structure.',infields{field_inds(i)},';'];
        eval(write_str)
    end    
end
    
    






