function inds = find_rowmatch(mat_to_search,row_comparison);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Compare 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% mat_to_search - 
% row_comparison - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inds - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

eval_str = ['inds = find('];
%%%%%%%%%% construct_find_string
for i = 1:length(row_comparison);
    eval_str = [eval_str,'mat_to_search(:,',num2str(i),') == row_comparison(',num2str(i),') & '];
end
eval_str = [eval_str(1:end-3),');'];

eval(eval_str);