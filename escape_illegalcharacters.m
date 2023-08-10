function outstring = escape_illegalcharacters(in_string,illegal_chars);

%%%%%%%%%% First, replace forward slashes if necessary
slash_replace = find(in_string == '\');
in_string(slash_replace) = '/';

space_to_underscore = 0;

if exist('illegal_chars') == 0
    illegal_chars = [' '];
    %illegal_chars = [' {}()\/-,:;''?'];
    %illegal_chars = [':;?()'];
end

outstring = in_string;


replace_inds = [];
for i = 1:length(illegal_chars)
    replace_inds = [replace_inds find(in_string == illegal_chars(i))];
end
add_vec_replace = (1:length(replace_inds))-1;

replace_inds = sort(replace_inds);

for i = 1:length(replace_inds)
    outstring = [outstring(1:replace_inds(i)+add_vec_replace(i)-1),'\',outstring(replace_inds(i)+add_vec_replace(i):end)];
end

