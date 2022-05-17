function output = atl11dir();

if exist('D:/00_ICESat2/ATL11_U07') ~= 0
    output = 'D:/00_ICESat2/ATL11_U07/';
elseif exist('E:/00_ICESat2/ATL11_U07/') ~= 0
    output = 'E:/00_ICESat2/ATL11_U07/';
elseif exist('F:/00_ICESat2/ATL11_U07/') ~= 0
    output = 'F:/00_ICESat2/ATL11_U07/';
elseif exist('G:/00_ICESat2/ATL11_U07/') ~= 0
    output = 'G:/00_ICESat2/ATL11_U07/';
end