function [deps_out packages] = dependencies(function_name)

[deps packages] = matlab.codetools.requiredFilesAndProducts([function_name,'.m']);

counter = 1;
for i = 1:length(deps)
    [fdir fname] = fileparts(deps{i});
    deps{i} = fname;
    if strcmp(deps{i},function_name) == 1
    else
        disp(deps{i});
        keep_ind(counter) = i;
        counter = counter+1;
    end
end

deps_out = deps(keep_ind);

end