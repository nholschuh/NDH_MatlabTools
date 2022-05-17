function out_number = find_filepattern(filename,pattern,stopline);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Scan a file to find the first line that matches the target pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filename - 
% pattern - 
% inp3 - 
% inp4 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out_number - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('stopline') == 0
    stopline = 0;
end

first_or_all = 0;
opts = length(pattern);
out_number = [];

fid = fopen(filename);
tl = fgets(fid);
counter = 1;

if length(tl) > opts
    if min(pattern == tl(1:opts)) == 1
        out_number = [out_number; counter];
        if first_or_all == 0
        tl = 0;
        end
    end
end


while tl ~= 0
    tl = fgets(fid);
    counter = counter+1;
    if length(tl) > opts
        if min(pattern == tl(1:opts)) == 1
            out_number = [out_number; counter];
            if first_or_all == 0
            tl = 0;
            end
        end
    end
    
    if counter == stopline
        tl = 0;
    end    
end

fclose(fid);

end
