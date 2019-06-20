function subset_out = animate_frames(videoname,dirname,framerate,subsetter,startframe,endframe,flipimage)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This generates a .mpv from .jpg frames. Typically, this generates a
% larger file than the unix script (found at _______________________)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% videoname - The output file name
% dirname - This is the name of the directory containing the frames
% framerate - The framerate
% subsetter - This allows you to crop the frames to a specific bounding box
%             If there are parts of the figures you want to crop out
% startframe - The start frame number
% endframe - The end frame number (if 0, all frames)
% framerate - The framerate
% flipimage - 0 (noflip) 1 (vertical) 2 (horizontal) 3(horizontal and
% vertical)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

v2 = VideoWriter([videoname,'.mp4'],'MPEG-4');
v2.FrameRate=framerate;
v2.Quality = 30; % Default value is 75
open(v2)

%%% This extracts the image frame file names
fileprefix = dir(['./',dirname,'/*.png']);
suffix = '.png';

if length(fileprefix) == 0
    fileprefix = dir(['./',dirname,'/*.jpg']);
    suffix = '.jpg';
end

if exist('startframe') == 0
    startframe = 1;
end
if startframe == 0
    startframe = 1;
end
if exist('endframe') == 0
    endframe = length(fileprefix)-startframe+1;
end
if endframe == 0
    endframe = length(fileprefix)-startframe+1;
end
if exist('subsetter') == 0
    subsetter = 0;
end
if exist('flipimage') == 0
    flipimage = 0;
end

[trash fileprefix trash] = fileparts(fileprefix(3).name);
fileprefix = strsplit(fileprefix,'_');
frame_prefix = [];
for i = 1:(length(fileprefix)-1)
    frame_prefix = [frame_prefix,fileprefix{i},'_'];
end

frame = imread(['./',dirname,'/',frame_prefix,sprintf('%04d',1),suffix]);
    if max(flipimage == 1) == 1
        frame(:,:,1) = fliplr(frame(:,:,1));
        frame(:,:,2) = fliplr(frame(:,:,2));
        frame(:,:,3) = fliplr(frame(:,:,3));
    end
    if max(flipimage == 2) == 1
        frame(:,:,1) = flipud(frame(:,:,1));
        frame(:,:,2) = flipud(frame(:,:,2));
        frame(:,:,3) = flipud(frame(:,:,3));  
    end
    if max(flipimage == 3) == 1
        frame(:,:,1) = frame(:,:,1)';
        frame(:,:,2) = frame(:,:,2)';
        frame(:,:,3) = frame(:,:,3)';  
    end

if length(subsetter) > 1
    row_range = subsetter(1,1):subsetter(1,2);
    col_range = subsetter(2,1):subsetter(2,2);
elseif subsetter == 1
    figure()
    imagesc(frame)
    corners = graphical_selection(1);
    row_range = [round(min(corners(:,2))):round(max(corners(:,2)))];
    col_range = [round(min(corners(:,1))):round(max(corners(:,1)))];
else
    row_range = [1:length(frame(:,1,1))];
    col_range = [1:length(frame(1,:,1))];
    if mod(row_range,2) == 0
        row_range = row_range(1:end-1);
    end
    if mod(col_range,2) == 0
        col_range = col_range(1:end-1);
    end
end


%%% This loops over the frames and generates the video
for i = startframe:endframe
    frame = imread(['./',dirname,'/',frame_prefix,sprintf('%04d',i),suffix]);
    if max(flipimage == 1) == 1
        frame(:,:,1) = fliplr(frame(:,:,1));
        frame(:,:,2) = fliplr(frame(:,:,2));
        frame(:,:,3) = fliplr(frame(:,:,3));
    end
    if max(flipimage == 2) == 1
        frame(:,:,1) = flipud(frame(:,:,1));
        frame(:,:,2) = flipud(frame(:,:,2));
        frame(:,:,3) = flipud(frame(:,:,3));  
    end
    if max(flipimage == 3) == 1
        frame(:,:,1) = frame(:,:,1)';
        frame(:,:,2) = frame(:,:,2)';
        frame(:,:,3) = frame(:,:,3)';  
    end
    writeVideo(v2,frame(row_range,col_range,1:3));
    if mod(i,100) == 0
        disp(['Finished frame ',num2str(i),' of ',num2str(endframe)])
    end
end

subset_out = [row_range(1) row_range(end);col_range(1) col_range(end)];


close(v2)
end

