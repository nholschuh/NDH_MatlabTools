function [outdata axes] = vtk_read_volume(info)
% Function for reading the volume from a Visualization Toolkit (VTK)
% 
% volume = tk_read_volume(file-header)
%
% examples:
% 1: info = vtk_read_header()
%    V = vtk_read_volume(info);
%    imshow(squeeze(V(:,:,round(end/2))),[]);
%
% 2: V = vtk_read_volume('test.vtk');

if(~isstruct(info)), info=vtk_read_header(info); end




% Open file
switch(info.byte_order)
    case 'LittleEndian', read_bo='l'; %l
    case 'BigEndian', read_bo='b'; %b. n-native
end

real_dims = [(info.Extent(2)-info.Extent(1))/info.Spacing(1) (info.Extent(4)-info.Extent(3))/info.Spacing(2) (info.Extent(6)-info.Extent(5))/info.Spacing(3)];
axes{1} = [1:real_dims(1)]*info.Spacing(1)-0.5*info.Spacing(1)+info.Extent(1);
axes{2} = [1:real_dims(2)]*info.Spacing(2)-0.5*info.Spacing(2)+info.Extent(3); 
axes{3} = [1:real_dims(3)]*info.Spacing(3)-0.5*info.Spacing(3)+info.Extent(5);
    

% Read the Data
for j = 1:length(info.var)
    
    switch(info.var(j).type)
        case 'char', type='int8';
        case 'uchar', type='uint8';
        case 'short', type='int16';
        case 'ushort', type='uint16';
        case 'int', type='int32';
        case 'uint', type='uint32';
        case 'float', type='single';
        case 'Float32', type='float32';
        case 'Int8', type='int8';
        case 'double', type='double';
        otherwise, type='double';
    end
    
    fid=fopen(info.Filename,'r',read_bo);
    % Skip header
    fseek(fid,info.HeaderSize+info.var(j).offset,'bof');
    fseek(fid,5,'cof');
    
    
    start_data = fread(fid,[1 prod(real_dims)*info.var(j).NumberOfComponents],type);
    
    for i = 1:info.var(j).NumberOfComponents
        temp = start_data(1:info.var(j).NumberOfComponents:end);
        temp = reshape(temp,real_dims);
        write_str = ['outdata.',remove_illegalcharacters(info.var(j).Name),'.Component',num2str(i),' = temp;'];
        eval(write_str);
    end

    fclose(fid);
end



