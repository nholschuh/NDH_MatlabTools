function output = DataPath();

if exist('E:\Graduate_Work\Data','dir') == 7
		output='E:\Graduate_Work\Data\CReSIS_Bulk_Download\';
elseif exist('D:\Graduate_Work\Data','dir') == 7
        output='D:\Graduate_Work\Data\CReSIS_Bulk_Download\';
elseif exist('F:\Graduate_Work\Data','dir') == 7
        output='F:\Graduate_Work\Data\CReSIS_Bulk_Download\';
elseif exist('G:\Graduate_Work\Data','dir') == 7
        output='G:\Graduate_Work\Data\CReSIS_Bulk_Download\';
elseif exist('I:\Graduate_Work\Data','dir') == 7
        output='I:\Graduate_Work\Data\CReSIS_Bulk_Download\';
elseif exist('/mnt/data01/Data/RadarData/','dir') == 7
        output='/mnt/data01/Data/RadarData/';
end

if exist('output') ~=1
    output = [];
end