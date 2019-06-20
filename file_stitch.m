function file_stitch(files,flips,output_file)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Stitches together multiple files that contain the same variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% files - A cell array containing the file names in the order you want them
%           to be stitched
% flips - A vector of 0's or 1's (or a single 0 or 1) that indicates which
%           files you want to flip the variable array before stitching
% output_file - The name for the saveed output file. Default is
%               "Stitched_File_[time]". Does not need .mat.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('flips') == 0;
    flips = 0;
end
if length(flips) == 1;
    flips = ones(1,length(files))*flips;
end
    

%%%%% This concatenates
for i = 1:length(files)
    load(files{i})
    if i == 1
        varnames = who;
        for j = 1:length(varnames) % This initializes the final combined variables
            newvar{j} = [varnames{j},'_combined']; % Sets the new variable name
            dim1 = size(eval(varnames{j}));
            if dim1(1) == 1 | min(dim1) > 1 % Row Vector or 2D Vector
                if flips(i) == 1
                    rename_string = [newvar{j},' = [fliplr(',varnames{j},')];']; 
                elseif flips(i) == 0
                    rename_string = [newvar{j},' = [',varnames{j},'];']; 
                end 
            elseif dim1(2) == 1
                if flips(i) == 1
                    rename_string = [newvar{j},' = [flipud(',varnames{j},')];']; 
                elseif flips(i) == 0
                    rename_string = [newvar{j},' = [',varnames{j},'];']; 
                end                 
            end
            eval(rename_string); % Defines the new variables
        end
    else
        for j = 1:length(varnames) 
            dim1 = size(eval(varnames{j}));
            dim2 = size(eval(newvar{j}));
            if dim1(1) == 1 | min(dim1) > 1% Row Vector or 2D Vector
                if flips(i) == 1
                    rename_string = [newvar{j},' = [',newvar{j},' fliplr(',varnames{j},')];'];
                else
                    rename_string = [newvar{j},' = [',newvar{j},' ',varnames{j},'];'];
                end
                eval(rename_string);
            elseif dim1(2) == 1 % Column Vector
                if flips(i) == 1
                    rename_string = [newvar{j},' = [',newvar{j},'; flipud(',varnames{j},')];'];
                else
                    rename_string = [newvar{j},' = [',newvar{j},'; ',varnames{j},'];'];
                end
                eval(rename_string);
            end
        end
    end
    disp(['Completed file ',num2str(i),' of ',num2str(length(files))])
end



%%%%% This renames the combined vectors to their original names
for j = 1:length(varnames)
    rename_string = [varnames{j},' = [',newvar{j},'];'];
    eval(rename_string);
end

clear_string = ['clearvars -except '];
for i = 1:length(varnames)
    clear_string = [clear_string,varnames{i},' '];
end
eval(clear_string)

%%% This unconcatenates the time vector
if exist('Time') == 1
    stop_inds = find(Time == Time(1));
    Time = Time(1:(stop_inds(2)-1));
    if flips(1) == 1
        Time = flipud(fliplr(Time));
    end
    clear stop_inds
end
if exist('travel_time') == 1
    stop_inds = find(travel_time == travel_time(1));
    travel_time = travel_time(1:(stop_inds(2)-1));
    if flips(1) == 1
        travel_time = flipud(fliplr(travel_time));
    end
    clear stop_inds
end   
if exist('TWTT') == 1
    TWTT = find(TWTT == TWTT(1));
    TWTT = TWTT(1:(stop_inds(2)-1));
    if flips(1) == 1
        TWTT = flipud(fliplr(TWTT));
    end
    clear stop_inds
end 

%%% This unconcentenates the file variable, so you the repititions are
%%% eliminated and you just have the original file list
files = files(1:sqrt(length(files)));

if exist('output_file') == 0
    clocktime = clock;
    filename = ['Stitched_File_',num2str(clocktime(2)),'_',num2str(clocktime(3)),'_',num2str(clocktime(4)),'_',num2str(clocktime(5)),'.mat'];
    clearvars clocktime
else
    output_file = output_file(1:length(output_file)/length(files));
    filename = [output_file,'.mat'];
end

save(filename)

end
    