function [xaxis yaxis zaxis out] = read_paraviewCSV(filename,orig0_or_grid1_or_fit2,fitinput);
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This function reads in paraview CSV output, originally written to read in
% output from David Liliens ELMER/ICE runs. These were produced as .vtu
% files, read by paraview, and rewritten as csvs which can be read by this
% function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - string containing the relative or full path to the file
% orig0_or_grid1 - flag that indicates whether you want a 3D interpolated
%                  version of the product(1) or the original data (0),
%                  stored in discrete layers. The original data method (0)
%                  tends to be slower than the interpolated method.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%
% xaxis - vector containing the coordinates for cell centers of the columns
% yaxis - vector containing the coordinates for cell centers of the rows
% zaxis - vector (or 2d, for original data) matrix containing the z positions 
%         for associated grid (or xy coordinates).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('orig0_or_grid1_or_fit2') == 0
    orig0_or_grid1_or_fit2 = 1;
end

if filename(end-2:end) == 'csv'
    
    init_data = dlmread(filename,',',1,0);
        
else
    %%%%%%%%%%%%%%% This was written specifically to only work with the
    %%%%%%%%%%%%%%% idealized squares used for NEGIS modeling. MUST BE
    %%%%%%%%%%%%%%% UPDATED to be adaptable
    data = read_h5(filename);
    init_data = [data.Data3(1:2,:)' data.Data2 data.Data0'];
end

[dd keep] = remove_duplicates(init_data(:,end-2:end));
init_data = init_data(keep,:);

xy_pairs = remove_duplicates(init_data(:,end-2:end-1));
fields = length(init_data(1,:))-3;

xr = [min(init_data(:,end-2)) max(init_data(:,end-2))];
xr2 = range(init_data(:,end-2));

yr = [min(init_data(:,end-1)) max(init_data(:,end-1))];
yr2 = range(init_data(:,end-1));

zr = [min(init_data(:,end)) max(init_data(:,end))];
zr2 = range(init_data(:,end));

downsample_fac = 3;

if orig0_or_grid1_or_fit2 == 0
    
    total_levels = length(dd(:,1))/length(xy_pairs(:,1));
    
    if mod(total_levels,1) == 0
        for i = 1:floor(length(xy_pairs(:,1))/downsample_fac)
            
            xyind = find(init_data(:,end-2) == xy_pairs((i-1)*downsample_fac+1,1) ...
                 & init_data(:,end-1) == xy_pairs((i-1)*downsample_fac+1,2));
            zaxis(i,:) = dd(xyind,3);
            xaxis(i,:) = dd(xyind(1),1);
            yaxis(i,:) = dd(xyind(1),2);
            
            for j = 1:fields
                out(j).fields(i,:) = init_data(xyind,j);
            end
            
            
        end
    else
        
        %%%%%%%%% This handles cases where the x/y coordinate doesn't have
        %%%%%%%%% enough data to fill a whole column.
        add_skip = [];
        
        for i = 1:fields
            for j = 1:length(xy_pairs(:,1))
                inds = find(init_data(:,end-2) == xy_pairs(j,1) & init_data(:,end-1) == xy_pairs(j,2));
                
                if j > 1
                    if length(inds) < length(zaxis(j-1-length(add_skip),:));
                        add_skip = [add_skip j];
                        skipper = 1;
                    else
                        skipper = 0;
                    end
                else
                    skipper = 0;
                end
                
                
                if skipper == 0
                    [dd keep] = remove_duplicates(init_data(inds,end-2:end));
                    inds = inds(keep);
                    
                    if j > 1
                        if length(inds) > length(zaxis(j-1-length(add_skip),:));
                            keep = [];
                            for k = 1:length(zaxis(j-1-length(add_skip),:));
                                keep(k) = find_nearest(init_data(inds,4),zaxis(j-1-length(add_skip),k));
                            end
                            inds = inds(keep);
                        end
                    end
                    
                    out(i).fields(j,:) = init_data(inds,i)';
                    
                    if i == 1
                        zaxis(j,:) = init_data(inds,end)';
                    end
                end
                
                if mod(j,5000) == 0
                disp(['Completed ',num2str(j),' of ',num2str(length(xy_pairs(:,1))),' for field ',num2str(i),' of ',num2str(fields)])
                end
            end
        end
        out(i).fields(add_skip,:) = [];
        zaxis(add_skip,:) = [];
        xy_pairs(add_skip,:) = [];
        
        xaxis = xy_pairs(:,1);
        yaxis = xy_pairs(:,2);
    end
    



    
elseif orig0_or_grid1_or_fit2 == 1
    
    scale_fac = 1;
    row_num = max([100 round(sqrt(yr2/xr2*length(xy_pairs(:,1)))*scale_fac)]);
    col_num = max([round(row_num*xr2/yr2) 100]);
    
    dx = 10^order(xr2/col_num);
    xaxis = round_to(xr(1),dx):dx:round_to(xr(2),dx);
    
    dy = 10^order(yr2/row_num);
    yaxis = round_to(yr(1),dy):dy:round_to(yr(2),dy);
    
    
    
    dz = min([xaxis(2)-xaxis(1) round(zr2/100)]);
    zaxis = round_to(zr(1),dz):dz:round_to(zr(2),dz);
    
    mem_pos = memory;
    mem_pos = mem_pos.MaxPossibleArrayBytes;
    memory_est = length(xaxis)*length(yaxis)*length(zaxis)*8;
    
    if memory_est > 0.6*mem_pos
        disp('memory reconditioning')
        down_fac = ceil(memory_est/mem_pos);
        xaxis = xaxis(1:down_fac:end);
        yaxis = yaxis(1:down_fac:end);
        zaxis = zaxis(1:down_fac*2:end);
    end
    
    if exist('fitinput') == 1
        if fitinput == 1
        yaxis = yaxis(round(length(yaxis)/2));
        end
    end
    
    [X Y Z] = meshgrid(xaxis,yaxis,zaxis);
    
    for i = 1:fields
        out(i).fields = squeeze(griddata(init_data(:,end-2),init_data(:,end-1),init_data(:,end),init_data(:,i),X,Y,Z,'linear'));
        disp(['Interpolated field ',num2str(i),' of ',num2str(fields)]);
    end
elseif orig0_or_grid1_or_fit2 == 2

    for i = 1:length(init_data(1,:))
       out(i).field = interpn(init_data(:,end-2),init_data(:,end-1),init_data(:,end),init_Data(:,i),fitinput(:,1),fitinput(:,2),fitinput(:,3));
    end
       
end










