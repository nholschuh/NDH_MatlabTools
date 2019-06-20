function out = extractfield_ndh(S,names)


if iscell(names) == 0 | length(names) == 1
    if iscell(names) == 1
        names = names{1};
    end
    names = strsplit(names,'.');
end

extract_str = ['extractfield(S.'];
for i = 1:length(names)-1
    extract_str = [extract_str,names{i},'.'];
end

extract_str = ['out = ',extract_str(1:end-1),',''',names{end},''');'];
eval(extract_str);