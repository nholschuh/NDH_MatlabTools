function outstring = remove_illegalcharacters(in_string,illegal_chars);


space_to_underscore = 0;

if exist('illegal_chars') == 0
illegal_chars = [' {}()\/-,:;''?"$%'];
%illegal_chars = [' {}()\/-,:;''?'];
%illegal_chars = [':;?()'];
end


outstring = in_string;

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
