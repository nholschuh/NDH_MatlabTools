function output = DataPath();

if exist('E:\Graduate_Work\Data','dir') == 7
		output='E:\Graduate_Work\Data\';
end
if exist('D:\Graduate_Work\Data','dir') == 7
        output='D:\Graduate_Work\Data\';
end
if exist('F:\Graduate_Work\Data','dir') == 7
        output='F:\Graduate_Work\Data\';
end
if exist('G:\Graduate_Work\Data','dir') == 7
        output='G:\Graduate_Work\Data\';
end

if exist('output') ~=1
    output = [];
end