function gmt_write_line(line_in_struct,filename,break_thresh,optstring)
% either input a structure with lines separated in cells, a long matrix 
% containing NaN's at the line boundaries, or a long matrix with 
% significant distance jumps defining the line breaks;

if exist('break_thresh') == 0 & iscell(line_in_struct) == 0
    distvec = distance_vector(line_in_struct(:,1),line_in_struct(:,2),1);
    break_thresh = 1.1*median(distvec);
end

if iscell(line_in_struct) == 1
    break_thresh = Inf;
end
    
if break_thresh == 0
    break_thresh = Inf;
end

if exist('optstring') == 1
    break_thresh = Inf;
end

    %%%%%%%%%% The case where the line_in_struct is a cell array containing
    %%%%%%%%%% lines separated into different cells
if iscell(line_in_struct) == 1
    temp_struct = line_in_struct;
    
    %%%%%%%%%% The case where the line_in_struct includes nans to separate
    %%%%%%%%%% lines
elseif max(isnan(line_in_struct)) == 1
    
    breaks = [0; find(isnan(line_in_struct(:,1)) == 1); length(line_in_struct)+1];
    for i = 1:length(breaks)-1
        temp_struct{i} = line_in_struct((breaks(i)+1):breaks(i+1)-1,:);
    end  
    
    %%%%%%%%%% The case where the line_in_struct is broken down into
    %%%%%%%%%% sublines based on the break_thresh
else
    distvec = distance_vector(line_in_struct(:,1),line_in_struct(:,2),1);
    
    breaks = [0 find(distvec > break_thresh) length(line_in_struct(:,1))];
    temp_struct= {};
    for i = 1:length(breaks)-1
        temp_struct{i} = line_in_struct((breaks(i)+1):breaks(i+1),:);
    end
end

fid=fopen(filename,'w');


for i = 1:length(temp_struct)
    total_length = length(temp_struct{i}(:,1));
    for j = 1:total_length
        if length(temp_struct{i}(1,:)) == 2
            if exist('optstring') == 1
                fprintf(fid,'%.1f \t %.1f \t %s \n',temp_struct{i}(j,:),optstring{j});
            else
                fprintf(fid,'%.1f \t %.1f \n',temp_struct{i}(j,:));
            end
        else
            fprintf(fid,'%.1f \t %.1f \t %.1f \n',temp_struct{i}(j,1:3));
        end
    end
    fprintf(fid,'> \n');
end
fclose(fid);

end