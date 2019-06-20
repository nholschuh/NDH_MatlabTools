function [out_x out_y out_z across_index out_bearing] = read_swathcsv(filename,edgetrim,endtrim,outtype);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This file reads the csv file produced as part of the CReSIS Tomographic
% processing, and outputs either a matrix or point cloud of values for use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filename - the .csv file to load
% edgetrim - the number of edge samples to trim, either one value and done
%            symmetrically or two values for the left and right edge, or a
%            matrix of the same size as the swath used as a mask
% outtype - either as a matrix (0) or a vector (1)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out_x - 
% out_y -
% out_z -
% across_index -
% out_bearing - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('outtype') == 0
    outtype = 0;
end

surfdata = dlmread(filename,',',1,0);

bxt = [surfdata(:,1)];
byt = [surfdata(:,2)];
bzt = [surfdata(:,3)];

%%%%%%%%%%%%%%%%%%% This finds samples that define edges of the swath
% angles = segment_bearing([bxt byt]);
% diff_angles = diff(angles);
% 
% dists = distance_vector(bxt,byt,1);
% dbx_inds = find(dists > median(dists)*4);
% dbx_diff = diff(dbx_inds);
% search_inds = find(dbx_diff > 5);
% dbx = median(dbx_diff(search_inds));
% 
% 
% si = dbx_inds(find(dbx_diff == dbx))+1;
% si = si(1);
% ei = dbx_inds(find(dbx_diff == dbx));
% ei = ei(end);
% 
% if mod(ei-si+1,dbx) ~= 0
%     dbx = sum(dbx_diff(search_inds(1)+1:search_inds(2)));
%     si = 1;
%     ei = length(bxt);
% end

dbx = 64;



%%%%%%%%%%%%%%%%%%% Here we reshape the result into a matrix, including the 
%%%%%%%%%%%%%%%%%%% full data volume
bxt2 = reshape(bxt,dbx,length(bxt)/dbx);
byt2 = reshape(byt,dbx,length(byt)/dbx);
bzt2 = reshape(bzt,dbx,length(bzt)/dbx);


si = 1;
ei = length(bxt);

%%%%%%%%%%%%%%%%%%% This calculates what index this sample is relative to
%%%%%%%%%%%%%%%%%%% nadir
across_index_t = abs([1:dbx] - ceil(dbx/2)-1);
if mod(dbx,2) == 0
    ind_up = find(across_index_t == 0);
    across_index_t(ind_up:end) = across_index_t(ind_up:end)+1;
end
across_index_t = repmat(across_index_t',1,length(bxt(si:ei))/dbx);


%%%%%%%%%%%%%%%%%%% This identifies the middle index, and uses it to
%%%%%%%%%%%%%%%%%%% calculate the bearing of the flight
mi = round(length(bxt2(:,1))/2);
bt1 = [bxt2(mi,1:end-1)' byt2(mi,1:end-1)'];
bt2 = [bxt2(mi,2:end)' byt2(mi,2:end)'];
bs = segment_bearing(bt1,bt2);
out_bearing = [bs(1,:); bs];


%%%%%%%%%%%%%%%%%%%% This allows you to set start and end indecies, if you
%%%%%%%%%%%%%%%%%%%% are trying to remove turns
if length(endtrim) == 0
ss = 1;
ee = length(bxt2(1,:));
else
   ss = endtrim(1);
   ee = length(bxt2(1,:))-endtrim(2);
end


%%%%%%%%%%%%%%%%%%%% And here we crop the swath edges.
if length(edgetrim) == 1
    out_x = bxt2(edgetrim(1)+1:end-edgetrim(1),ss:ee);
    out_y = byt2(edgetrim(1)+1:end-edgetrim(1),ss:ee);
    out_z = bzt2(edgetrim(1)+1:end-edgetrim(1),ss:ee);
    across_index = across_index_t(edgetrim(1)+1:end-edgetrim(1),ss:ee);
elseif length(edgetrim) == 2
    out_x = bxt2(edgetrim(1)+1:end-edgetrim(2),ss:ee);
    out_y = byt2(edgetrim(1)+1:end-edgetrim(2),ss:ee);
    out_z = bzt2(edgetrim(1)+1:end-edgetrim(2),ss:ee);
    across_index = across_index_t(edgetrim(1)+1:end-edgetrim(2),ss:ee);
elseif size(edgetrim) == size(bxt2);
    out_x = bxt2;
    out_y = byt2;
    out_z = bzt2;
    out_z(find(edgetrim == 0)) = NaN;
    across_index = across_index_t;
end


if outtype == 1
    %ki = find(~isnan(out_z));
    %out_x = matrix_to_vector(out_x(ki));
    %out_y = matrix_to_vector(out_y(ki));
    %out_z = matrix_to_vector(out_z(ki));
    %across_index = matrix_to_vector(across_index(ki));
    out_x = matrix_to_vector(out_x);
    out_y = matrix_to_vector(out_y);
    out_z = matrix_to_vector(out_z);
    across_index = matrix_to_vector(across_index);
end





end







