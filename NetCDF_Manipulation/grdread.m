function varargout = grdread(file,variable,timeslice,xvar,yvar);
% (C) Nick Holschuh - Penn State University - 2017 (Nick.Holschuh@gmail.com)
% This script reads in NetCDF4 files, including those that include multiple
% data sets and multiple time slices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% file - string, containing the full file name (or path)
% variable - [optional] this is a string containing the variable name of
%            interest. If it contains "Inf", all variables are saved into a
%            structure named z.
% timeslice - [optional] this is an integer containing the index for the
%            time slice of interest
% xvar - [optional] For multivariate netCDFs, this is the name of the
%       xcoordinate variable
% yvar - [optional] For multivariate netCDFs, this is the name of the
%       y coordinate variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%GRDREAD2  Load a GMT grdfile (netcdf format)
%
% Uses NetCDF libraries to load a GMT grid file.
% Duplicates (some) functionality of the program grdread (which requires
% compilation as a mexfile-based function on each architecture) using
% Matlab 2008b (and later) built-in NetCDF functionality
% instead of GMT libraries.
%
% Z=GRDREAD2('filename.grd') will return the data as a matrix in Z
%
% [X,Y,Z]=GRDREAD2('filename.grd') will also return X and Y vectors
% suitable for use in Matlab commands such as IMAGE or CONTOUR.
% e.g., imagesc(X,Y,Z); axis xy
%
% Although both gridline and pixel registered grids can be read,
% pixel registration will be converted to gridline registration
% for the x- and y-vectors.
%
% See also GRDWRITE2, GRDINFO2

% CAUTION: This program currently does little error checking and makes
% some assumptions about the content and structure of NetCDF files that
% may not always be valid.  It is tested with COARDS-compliant NetCDF
% grdfiles, the standard format in GMT 4 and later, as well as GMT v3
% NetCDF formats.  It will not work with any binary grid file formats.
% It is the responsibility of the user to determine whether this
% program is appropriate for any given task.
%
% For more information on GMT grid file formats, see:
% http://www.soest.hawaii.edu/gmt/gmt/doc/gmt/html/GMT_Docs/node70.html
% Details on Matlab's native netCDF capabilities are at:
% http://www.mathworks.com/access/helpdesk/help/techdoc/ref/netcdf.html

% GMT (Generic Mapping Tools, <http://gmt.soest.hawaii.edu>)
% was developed by Paul Wessel and Walter H. F. Smith

% Kelsey Jordahl
% Marymount Manhattan College
% Time-stamp: <Wed Jan  6 16:37:45 EST 2010>

% Version 1.1.1, 6-Jan-2010
% released with minor changes in documentation along with grdwrite2 and grdinfo2
% Version 1.1, 3-Dec-2009
% support for GMT v3 grids added
% Version 1.0, 29-Oct-2009
% first posted on MATLAB Central

if nargin < 1,
    help(mfilename);
    return,
end

% check for appropriate Matlab version (>=7.7)
V=regexp(version,'[ \.]','split');
if (str2num(V{1})<7) | (str2num(V{1})==7 & str2num(V{2})<7),
    ver
    error('grdread: Requires Matlab R2008b or later!');
end

ncid = netcdf.open(file, 'NC_NOWRITE');
if isempty(ncid),
    return,
end

[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
varnames = grdvariables(file);


if (nvars==3),                        % new (v4) GMT netCDF grid file
    x=netcdf.getVar(ncid,0)';
    y=netcdf.getVar(ncid,1)';
    z=netcdf.getVar(ncid,2)';
elseif length(varnames{1}) == 7 && min(varnames{1} == 'x_range') == 1   %NDH edited to remove (perhaps needs to be fixed? originaly nvars==6)
    % old (v3) GMT netCDF grid file
    [dimname, dimlen] = netcdf.inqDim(ncid,1);
    if (length(dimname)==6 && min(dimname=='xysize'))            % make sure it really is v3 netCDF
        xrange=netcdf.getVar(ncid,0)';
        yrange=netcdf.getVar(ncid,1)';
        z=netcdf.getVar(ncid,5);
        dim=netcdf.getVar(ncid,4)';
        pixel=netcdf.getAtt(ncid,5,'node_offset');
        if pixel,                         % pixel node registered
            dx=diff(xrange)/double(dim(1)); % convert int to double for division
            dy=diff(yrange)/double(dim(2));
            x=xrange(1)+dx/2:dx:xrange(2)-dx/2; % convert to gridline registered
            y=yrange(1)+dy/2:dy:yrange(2)-dy/2;
        else                              % gridline registered
            dx=diff(xrange)/double(dim(1)-1); % convert int to double for division
            dy=diff(yrange)/double(dim(2)-1);
            x=xrange(1):dx:xrange(2);
            y=yrange(1):dy:yrange(2);
        end
        z=flipud(reshape(z,dim(1),dim(2))');
        
    else % Solution implemented to deal with RACMO netCDFs (NDH - 11/2015)
        for i = 1:nvars
            size_temp = size(netcdf.getVar(ncid,i-1));
            if length(size_temp) == 2
                size_temp = [size_temp 0];
            end
            sizes(i,:) = size_temp;
        end
        if max(sizes(:,3)) > 0
            z_ind = find(sizes(:,3) > 0);
            t_ind = find(sizes(:,1) == sizes(z_ind,3));
            t = netcdf.getVar(ncid,t_ind-1);
        else
            z_ind = find(sizes(:,2) > 1);
        end
        x_ind = find(sizes(:,1) == (sizes(z_ind,1)));
        y_ind = find(sizes(:,1) == (sizes(z_ind,2)));
        x = netcdf.getVar(ncid,x_ind(1)-1);
        y = netcdf.getVar(ncid,y_ind(1)-1);
        z = netcdf.getVar(ncid,z_ind(1)-1);
        varname = {netcdf.inqDim(ncid,x_ind(1)-1),netcdf.inqDim(ncid,y_ind(1)-1),netcdf.inqDim(ncid,z_ind(1)-1)};
    end
elseif (nvars ~=3 & nvars)
    comp_flag = 0;
    if exist('variable') == 1
        if variable == Inf
            comp_flag = 1;
        end
    end
    if comp_flag == 1
        varnames = grdvariables(file);
        for i = 1:length(varnames)
            write_str = ['z.',varnames{i},' = ncread(file,varnames{i});'];
            eval(write_str);
        end
        x = [];
        y = [];
    else
        
        varnames = grdvariables(file);
        if exist('xvar') == 0
            xselection = listdlg('ListString',varnames,'PromptString','Select the X Coordinate')
            xvar = varnames{xselection}
        end
        if exist('yvar') == 0
            yselection = listdlg('ListString',varnames,'PromptString','Select the Y Coordinate');
            yvar = varnames{yselection};
        end
        x=ncread(file,xvar);
        y=ncread(file,yvar);
        if exist('variable') == 0
            varnames = grdvariables(file);
            varselection = listdlg('ListString',varnames,'PromptString','Select the Z Grid');
            variable = varnames{varselection};
        end
        if exist('variable') == 1
            if variable == 0
                varnames = grdvariables(file);
                varselection = listdlg('ListString',varnames);
                variable = varnames{varselection};
            end
        end
        
        z = ncread(file,variable);
        if length(size(z)) == 3
            if exist('timeslice') == 0
                maxvalue = size(z);
                maxvalue = maxvalue(3);
                maxvalue = num2str(maxvalue);
                promptentry = strcat('Provide a timeslice < ',maxvalue);
                timeslice2 = inputdlg(promptentry);
                timeslice = eval(timeslice2{1});
            elseif timeslice == 0
                maxvalue = size(z);
                maxvalue = maxvalue(3);
                maxvalue = num2str(maxvalue);
                promptentry = strcat('Provide a timeslice < ',maxvalue);
                timeslice2 = inputdlg(promptentry);
                timeslice = eval(timeslice2{1});
            end
            z = z(:,:,timeslice);
        end
    end
    
    if length(size(z)) == 2
        z = z';
    end
end

netcdf.close(ncid)

if exist('variable') == 1
    if variable ~= Inf
        z = double(z);
    end
else
    z = double(z);
end



switch nargout
    case 1,
        varargout{1}=z;
    case 3,
        varargout{1}=x;
        varargout{2}=y;
        varargout{3}=z;
    case 4,
        varargout{1}=x;
        varargout{2}=y;
        varargout{3}=z;
        varargout{4}=t;
    case 5,
        varargout{1}=x;
        varargout{2}=y;
        varargout{3}=z;
        varargout{4}=t;
        varargout{4}=varname;
    otherwise
        error('grdread2: Incorrect # of output arguments!');
end
