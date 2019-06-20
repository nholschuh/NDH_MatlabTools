function output = yearfrac(datenum1,datenum2);

v1 = datevec(datenum1);
v2 = datevec(datenum2);

output = (v2(:,1)-v1(:,1)) + (v2(:,2)-v1(:,2))/12 + (v2(:,3)-v1(:,3))/31/12;

end