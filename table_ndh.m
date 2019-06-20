function table_ndh(input_mat,row_names,col_names);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This function plots a table in a figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inp1 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


tsize = size(input_mat);

if exist('row_names') == 1
   tsize(1) = tsize(1)+1; 
   cadd = 1;
else
   cadd = 0;
end

if exist('col_names') == 1
    tsize(2) = tsize(2)+1;
    radd = 1;
else
    radd = 0;
end


xlim([0 1]);

ylim([0 1]);

dy = 1/(tsize(1)+2);
dx = 1/(tsize(2)+2);

ylines = dx:dx:1-dx;
xlines = dy:dy:1-dy;

hold off
for i = 1:length(xlines)
   plot([xlines(i) xlines(i)],[ylines(1) ylines(end)],'Color','black') 
   hold all
end
for i = 1:length(ylines)
    plot([xlines(1) xlines(end)],[ylines(i) ylines(i)],'Color','black') 
end


for i = 1:length(input_mat(1,:))
    for j = 1:length(input_mat(:,1))
        text(mean(xlines([i:i+1]+cadd)),mean(ylines([j:j+1])),num2str(input_mat(j,i)),'HorizontalAlign','center')
    end
end


xlim([0 1])
ylim([0 1])
set(gca,'YDir','reverse')




