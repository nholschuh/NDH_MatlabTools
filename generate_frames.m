function generate_frames(frame_prefix,dirname,indexnum,gifmap)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This generates a .avi from .jpg frames. Typically, this generates a
% larger file than the unix script (found at _______________________)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% frame_prefix - The output file name
% dirname - This is the name of the directory that will contain the frames
% indexnum - This is the loop number, to generate the frame with the
%               correct index
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

file_type = '.png';
%file_type = '.jpg';
%file_type = '.gif';

if file_type == '.gif' & exist('gifmap') == 0
    gifmap = 256;
end

    
    if exist(dirname) ~= 7
        mkdir(dirname);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%% This chunk of code delets files in the same
    %%%%%%%%%%%%%%%%%%%%%%% folder if used before (only those files with
    %%%%%%%%%%%%%%%%%%%%%%% numbers greater than the current one)
    fileprefix = dir(['./',dirname,'/*',file_type]);
    if length(fileprefix) > 0
        [trash fileprefix trash] = fileparts(fileprefix(end).name);
        fileprefix = strsplit(fileprefix,'_');
        final_frame_num = eval(fileprefix{end});
        
        if final_frame_num > indexnum
            fileprefix = dir(['./',dirname,'/*',file_type]);
            for i = 1:length(fileprefix)
                name_pre = strsplit(fileprefix(i).name,'_');
                num_pre = strsplit(name_pre{end},'.');
                frame_nums(i) = eval(num_pre{1});
            end
            delete_vals = find(frame_nums > indexnum);
            for i = 1:length(delete_vals)
                delete([fileprefix(delete_vals(i)).folder,'\',fileprefix(delete_vals(i)).name]);
            end
        end
    end

    
    %%%%%%%%%%%%%%%%%%%% Here we actually write out the frame
    savename = ['./',dirname,'/Frame_',sprintf('%04d',indexnum),file_type];

    imfile = getframe(gcf);
    if file_type == '.gif'
        [imind] = rgb2ind(imfile.cdata,gifmap);
        imwrite(imind,savename);
    else
        imwrite(imfile.cdata,savename);
    end

end
