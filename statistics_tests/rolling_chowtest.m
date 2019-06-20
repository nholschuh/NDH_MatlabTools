function chow_values = rolling_chowtest(series,window1,window2)
% Calculates the chow test statistic to determine the likelihood of a
% structural break occurring between window1 and window2. Series1 should be
% a N x 2 vector containing the X and Y values of each sample.

for i = 1:(length(series(:,1))-window2-window1+1)
    set_total = series(i:(i+window1+window2-1),:);
    set_1 = series(i:(i+window1-1),:);
    set_2 = series((i+window1):(i+window1+window2-1),:);
    
    coef1 = polyfit(set_1(:,1),set_1(:,2),1);
    coef2 = polyfit(set_2(:,1),set_2(:,2),1);
    coeft = polyfit(set_total(:,1),set_total(:,2),1);
    
    residuals1 = residuals(set_1,coef1);
    residuals2 = residuals(set_2,coef2);
    residualst = residuals(set_total,coeft);
    
    s1 = sum(residuals1.^2);
    s2 = sum(residuals2.^2);
    st = sum(residualst.^2);
    
    chow(i,1) = series(i+window1,1);
    chow(i,2) = ((st - (s1 + s2))/2)/((s1+s2)/(window1+window2-2*2));
end
    
chow_values = chow;

end
    
    
    




