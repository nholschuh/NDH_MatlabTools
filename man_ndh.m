function man_ndh(filename)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This reads matlab script files in the path, and writes the header
% information out to the command window.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filename - string containing the filename to source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

A = fopen([filename,'.m']);
counter = 1;

temp{counter} = fgetl(A);

while(isstr(temp{counter}))
    counter = counter+1;
    temp{counter} = fgetl(A);
end

for i = 2:length(temp)
    if temp{i}(1) ~= '%';
        run_to = i-1;
        break
    end
end

for i = 1:run_to;
    disp([temp{i}])
end
