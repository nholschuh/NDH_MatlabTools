function swaths = produce_swath(x,y,s_width);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Produce a swath of define width for radar lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x - 
% y - 
% s_width - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% swaths - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


rl = reduce_linecomplexity([x y],5);
while isnan(rl(end,1)) == 1
    rl = rl(1:end-1,:);
end
ni_1 = find(isnan(rl(:,1)));

swath_l = make_ortholine(rl,s_width,1);
swath_r = make_ortholine(rl,s_width,0);

swath_l(ni_1+1,:) = swath_l(ni_1+2,:);
swath_r(ni_1+1,:) = swath_r(ni_1+2,:);

ni_2 = find(isnan(swath_l(:,1)));


nan_inds = find(isnan(swath_l(:,1)));
swath_boundaries_pre = find(diff(nan_inds) > 1);


swath_start = [nan_inds(swath_boundaries_pre)];
swath_end = [nan_inds(swath_boundaries_pre+1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%% If the swaths need to be subdivided
if length(nan_inds) > 0
    %%%%%%%%%%%%%%%%%%%%%%% If there is a case that the data start or end
    %%%%%%%%%%%%%%%%%%%%%%% with NaNs, otherwise add in the first and last
    %%%%%%%%%%%%%%%%%%%%%%% swath.
    if nan_inds(1) == 1
    else
        swath_start = [0; swath_start];
        swath_end = [nan_inds(1); swath_end];
    end
    
    if nan_inds(end) == length(swath_l)
    else
        swath_start = [swath_start; nan_inds(end)];
        swath_end = [swath_end; length(swath_l(:,1))+1];
    end
else
    %%%%%%%%%%%%%%%%%%%%%%% For the case where it is one unified swath
    swath_start = 0;
    swath_end = length(swath_l(:,1))+1;
end
    

for i = 1:length(swath_start)
    swaths{i} = [flipud(swath_l((swath_start(i)+1):(swath_end(i)-1),:)+rl((swath_start(i)+1):(swath_end(i)-1),:));...
        swath_r((swath_start(i)+1):(swath_end(i)-1),:)+rl((swath_start(i)+1):(swath_end(i)-1),:)];
end

    
% hold off
% for i = 1:length(swaths)
%     fill(swaths{i}(:,1),swaths{i}(:,2),[0.5 0.5 0.5]);
%     hold all
% end
% 
% plot(rl(:,1),rl(:,2),'o-','Color','black');
% hold all
% plot(swath_l(:,1)+rl(:,1),swath_l(:,2)+rl(:,2),'Color','red');
% plot(swath_r(:,1)+rl(:,1),swath_r(:,2)+rl(:,2),'Color','blue');
% 

end

