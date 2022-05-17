function [n frac decdate] = doy(indate) 
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This function takes either a string or a datenum and computes the day of
% year associated with that date.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% indate - datestring or datenum input
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% n - The day of year
% frac - The fraction of the year
% decdate - The decimal year value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%% Here we produce a 6 value vector for Y,M,D,H,M,S
d = datevec(indate); 

%%%%%%% And we get the number of times provided
l_indate = prod(size(indate));



%%%%%%% Normall, this would take a nx6 vector and create an nx1 vector, but
%%%%%%% if it inoly contains NaNs this failes and outputs an nx6 output. 
%%%%%%% We've added a NaN check to prevent that 

if min(isnan(d)) == 1
    decdate = ones(size(indate))*NaN;
    n = ones(size(indate))*NaN;
    frac = ones(size(indate))*NaN;
else
    %%%%%%% here we compute the day of the year
    n = datenum(d) - datenum([d(:,1), ones(l_indate,1), zeros(l_indate, 4)]);
    
    %%%%%%% Then we divide that day from the day-of-year for 12/31
    frac = n./(datenum([d(:,1),ones(l_indate,1)*12,ones(l_indate,1)*31,ones(l_indate,1)*23,ones(l_indate,1)*59,ones(l_indate,1)*59]) ...
        - datenum([d(:,1), ones(l_indate,1), zeros(l_indate, 4)]));
    
    %%%%%%% Then we use the day of year information to get the decimal date
    decdate = d(:,1)+frac;
    
    decdate = reshape(decdate,size(indate));
end
