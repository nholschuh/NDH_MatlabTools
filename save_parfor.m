function save_parfor(filename,instruct)

savevars = fieldnames(instruct);
save_str = 'save(filename,';
for i = 1:length(savevars)
    rn_str = eval([savevars{i},' = instruct.',savevars{i},';]']);
    save_str = [save_str,'''',instruct{i},''','];
end
save_str = [save_str(1:end-1),')'];
eval(save_str);



