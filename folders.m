function output = folders(root_dir)
%%%% Get just a list of the folder names in the current directory (or
%%%% target directory);

if exist('root_dir') == 0
    output = dir();
else
    output = dir([root_dir,'*']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
remove_ind = [];
for i = 1:length(output)
    if output(i).isdir == 0 | output(i).name(1) == '.';
        remove_ind = [remove_ind i];
    end
end

output(remove_ind) = [];

end