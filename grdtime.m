function [timesteps timevec] = grdtime(file) 
% Reads a netcdf file and determines the number of time slices. If there is
% a time variable contained, it also extracts the time vector.

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


if (nvars>3),
      if exist('variable') == 0
        varnames = grdvariables(file);
        variable = varnames{length(varnames)};   
        if length(find(ismember(varnames,'time'))) > 0
            [a b timevec] = grdread(file,'time');
        else
            timevec = 0;
        end
      end
      z = ncread(file,variable);
      if length(size(z)) == 3
          if exist('timeslice') == 0
              maxvalue = size(z);
              maxvalue = maxvalue(3);
              maxvalue = num2str(maxvalue);
          end
      else
          maxvalue = 1;
      end
end

netcdf.close(ncid)

timesteps = str2num(maxvalue);

end


