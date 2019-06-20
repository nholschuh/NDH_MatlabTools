function plot_ATL06_segids(atl06_fname)
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

figure()
hold off


beam_names = {'gt1l','gt1r','gt2l','gt2r','gt3l','gt3r'};
colors = jet(6);
for i = 1:6
    
    rn_string = ['tempdata = data.',beam_names{i},'.land_ice_segments;'];
    eval(rn_string);
    
    segids = tempdata.segment_id;
    deltat = tempdata.delta_time;
    deltat = deltat-deltat(1);%+data.ancillary_data.start_delta_time;
    
    %%%%%%%%%%% This selects their relative distance (first way of
    %%%%%%%%%%% comparing to alex)
    relx = tempdata.ground_track.x_atc;
    relx = (relx-relx(1))/1000;
    
    
    
    ds = 10;
    start_ind = find(min(round_to(segids+ds,ds)) == segids);
    if length(start_ind) == 0
        start_ind = 1;
    end
    
    
    if min(tempdata.latitude) < 0
        if i == 1
            hold off
            Antarctic_Imagery(0,'a');
            hold all
        end
        [x y] = polarstereo_fwd(tempdata.latitude,tempdata.longitude,0);
        
    else
        if i == 1
            hold off
            Greenland_Imagery(0,'a');
            hold all
        end
        [x y] = polarstereo_fwd(tempdata.latitude,tempdata.longitude,2);
    end
    
    hold all
    %%%%%%%%%%% First alex comparison
    %plot_wmeta(x(start_ind:ds:end),y(start_ind:ds:end),[segids(start_ind:ds:end)
    %relx(start_ind:ds:end)],'Color',colors(i,:));
        
    %%%%%%%%%%% Second alex comparison
    plot_wmeta(x(start_ind:ds:end),y(start_ind:ds:end),[segids(start_ind:ds:end) tempdata.ground_track.x_atc(start_ind:ds:end)/1000 deltat(start_ind:ds:end)],'Color',colors(i,:));
    title([true_name(atl06_fname),': Segids - xATC - delta time'])
    

end

legend(beam_names)




