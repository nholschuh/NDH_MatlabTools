function outstring = remove_illegalcharacters(in_string,illegal_chars);


space_to_underscore = 0;

if exist('illegal_chars') == 0
    illegal_chars = [' {}()\/-,:;''?"$%'];
    %illegal_chars = [' {}()\/-,:;''?'];
    %illegal_chars = [':;?()'];
end

outstring = in_string;


%%%%%%%%%%%% These are characters like carriage returns
always_illegal = [95 13];
for i = 1:length(always_illegal)
    remove_ind = find(double(outstring) == always_illegal(i));
    outstring(remove_ind) = [];
end

for i = 1:length(illegal_chars)
    remove_ind = find(outstring == illegal_chars(i));
    if i == 1
        if space_to_underscore == 1
            outstring(remove_ind) = '_';
        else
            outstring(remove_ind) = [];
        end
    else
        outstring(remove_ind) = [];
    end
end
