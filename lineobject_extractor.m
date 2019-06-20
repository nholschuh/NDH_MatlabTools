for i = 1:length(line_object)
    name = ['line',num2str(i)];
    operator = [name,' = line_object{',num2str(i),'};'];
    eval(operator);
end