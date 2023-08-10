function write_ATL06_kmz(atl06_fname)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This file reads the atl03 and atl06 h5 files, and plots them on top of
% one another for comparison. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% atl06s - Filename (or cell list of filenames) for the ATL06 surface
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

data = read_ATL06_h5(atl06_fname,Inf);


beam_names = {'gt1l','gt1r','gt2l','gt2r','gt3l','gt3r'};
colors = jet(6);
for i = 1:6
    
    rn_string = ['tempdata = data.',beam_names{i},'.land_ice_segments;'];
    eval(rn_string);
    
    segids = tempdata.segment_id;
    
    
    ds = 10;
    lats{i} = tempdata.latitude(1:ds:end);
    lons{i} = tempdata.longitude(1:ds:end);
    colorvals{i} = colors(i,:);
    
    

end

kmlline_ndh(lats,lons,beam_names,atl06_fname(1:end-3),'red')




