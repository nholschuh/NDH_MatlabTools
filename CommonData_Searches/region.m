function [region_box region_name output_grid output_inds] = region(rnum,box0_plot1_or_subselect2,ant0_or_green1,datax,datay);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% This function will either zoom to your region of interest, or create a
% mask for your target region fo use in analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
% rnum - the Region number (0 for an options list)
% plot0_or_subselect1 - either zoom to region and title, or create mask
% datax - the xaxis for a data grid that you would like to find indexes for
%         (or, in the plot case, whether or not you want to zoom-to)
% datay - the yaxis for the data grid you want to subselec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('ant0_or_green1') == 0
    ant0_or_green1 = 0;
end

if exist('box0_plot1_or_subselect2') == 0
    box0_plot1_or_subselect2 = 1;
end

if exist('rnum') == 0
    rnum = 0;
end

if ant0_or_green1 == 0
    region_names = {...
        '1 - Mercer Ice Stream', ...
        '2 - Whillans Ice Stream', ...
        '3 - Bindschadler and MacAyeal Ice Streams', ...
        '4 - Thwaites Glacier', ...
        '5 - Pine Island Glacier', ...
        '6 - Evans Ice Stream', ...
        '7 - Rutford Ice Stream', ...
        '8 - Institute Ice Stream', ...
        '9 - Moller and Foundation Ice Streams', ...
        '10 - Blackwall Ice Stream and Recovery Glacier', ...
        '11 - Slessor Glacier', ...
        '12 - Bailey Ice Stream', ...
        '13 - Jutulstraumen Glacier', ...
        '14 - Amery Ice Shelf - Fisher Glacier, Mellor Glacier, and Lambert Glacier', ...
        '15 - Totten Glacier', ...
        '16 - Whillans Ice Plain'
        };
    
elseif ant0_or_green1 == 1
    region_names = {...
        '1 - NEGIS', ...
        '2 - Daugaard-Jensen Glacier', ...
        '3 - Kangerlussuaq Glacier', ...
        '4 - Helheim Glacier', ...
        '5 - Jakobshavn Glacier', ...
        '6 - Petermann Glacier', ...
        '7 - Ryder Glacier',...
        };
end


if box0_plot1_or_subselect2 == 0
    if exist('datax') == 0
        datax = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data are stored with:
% Column 1 - X Values
% Column 2 - Y Values

if rnum == 0
    rnum = listdlg('Name','Region Selection','ListString',region_names);
end


if ant0_or_green1 == 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Antarctic Regions
    %%
    if rnum == 1
        %%%% Ice Stream A - Mercer Ice Stream
        region_box{1} = [-414991.049706291,-507558.644288420;-225559.883122722,-181166.085375338];
        
    elseif rnum == 2
        %%%% Ice Stream B - Whillans Ice Stream
        region_box{1} = [-670917.312741835,-587465.885144414;-392870.127484759,-216463.361349373];
        region_box{2} = [-409092.453851702,-613651.055843172;-283500.249720526,-503397.705532610];
        
    elseif rnum == 3
        %%%% Ice Stream D & E - Bindschadler and MacAyeal
        region_box{1} = [-1119418.66291657,-993046.516168625;-529901.959574095,-530176.912327468];
        
    elseif rnum == 4
        %%%% Thwaites Glacier
        region_box{1} = [-1607600.37150080,-555463.271747180;-1403889.86663317,-341071.407266749];
        region_box{2} = [-1411752.98855103,-674794.746535063;-1056574.17298653,-211864.288929909];
        
    elseif rnum == 5
        %%%% Pine Island Glacier
        region_box{1} = [-1735409.23273147,-393147.414798820;-1426211.24025976,81206.0770287155];
        
    elseif rnum == 6
        %%%% Evans Ice Stream
        region_box{1} = [-1654830.56630084,139525.368920022;-1447491.71674218,632042.221028672];
        region_box{2} = [-1465311.93154114,262837.537687195;-1347724.52878014,466284.320579030];
        
    elseif rnum == 7
        %%%% Rutford Ice Streams
        region_box{1} = [-1481260.60608747,-18622.8352386697;-1136494.16746555,154221.257156607];
        region_box{2} = [-1231148.61001604,101972.997117143;-1082341.01291950,303324.807574642];
        
    elseif rnum == 8
        %%%% Institute Ice Stream
        region_box{1} = [-1104466.10734352,-19945.0753366917;-813199.041508380,365405.789253588];
        
    elseif rnum == 9
        %%%% Moller and Foundation Ice Streams
        region_box{1} = [-829961.204995598,-38425.9550834952;-527680.552254911,432963.837170923];
        region_box{2} = [-551385.120380749,6751.81846837699;-150872.737326589,365372.284492541];
        
    elseif rnum == 10
        %%%% Blackwall Ice Stream and Recovery Glacier
        region_box{1} = [-271320.578111249,468049.769180537;312179.988334593,1021988.88713012];
        region_box{2} = [-443527.540971155,519492.155277634;-104555.442772379,971368.196517336];
        region_box{3} = [-539434.953949605,557428.256808159;-260431.570739570,905231.807123413];
        region_box{4} = [-597563.450936539,657684.673389877;-431645.692683805,903684.245533467];
        
    elseif rnum == 11
        %%%% Slessor Glacier
        region_box{1} = [-485180.707174038,985994.320974497;65616.6532200591,1382809.83820718];
        region_box{2} = [-562237.050566688,919072.238944913;-415726.334878421,1028741.90641190];
        
    elseif rnum == 12
        %%%% Bailey Ice Stream
        region_box{1} = [-668397.575422364,1009106.29742786;-465451.740893071,1207261.29837861];
        
    elseif rnum == 13
        %%%% Jutulstraumen Glacier
        region_box{1} = [-118035.734538013,1684608.95161736;71994.2113144632,2283663.98764775];
        
    elseif rnum == 14
        %%%% Amery Ice Shelf - Fisher Glacier, Mellor Glacier, and Lambert Glacier
        region_box{1} = [970557.412348293,224793.831610135;1792742.98323896,1065314.93116419];
        
    elseif rnum == 15
        %%%% Totten Glacier
        region_box{1} = [1672530.66918172,-1406440.07613223;2494072.59191878,-532742.301867576];
   
    elseif rnum == 16
        %%%% Whillans Ice Plain
        region_box{1} = [-345131,-795676;-50167,-486761];
    end
    
elseif ant0_or_green1 == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Greenland Regions
    %%
    if rnum == 1
        %%%% NEGIS
        region_box{1} = [-15227.5409772942,-1665727.42824750;285283.377479587,-1093104.42000856];
        region_box{2} = [246507.775098054,-1389432.65313513;415458.614046162,-1042186.04755583];
        
    elseif rnum == 2
        %%%%% Daugaard-Jensen Glacier
        region_box{1} = [167018.633959628,-2039077.28163080;314297.174906364,-1922917.27110990];
        region_box{1} = [298041.933967949,-2006753.24241462;382378.548243319,-1940236.13857485];
        
    elseif rnum == 3
        %%%%% Kangerlussuaq Glacier
        region_box{1} =   [37827.8735780677,-2366295.35972248;304420.123762472,-2156031.47207704];
        
    elseif rnum == 4
        %%%%% Helheim Glacier
        region_box{1} =  [-135272.278316916,-2627906.02706023;134492.472928505,-2373953.48635963];
        
    elseif rnum == 5
        %%%%% Jakobshavn Glacier
        region_box{1} =  [-455328.499930835,-2362994.90638748;-190477.083595459,-2154104.03124555];
        
    elseif rnum == 6
        %%%%% Petermann Glacier
        region_box{1} = [-403379.561244778,-1154734.76454564;-213098.888936595,-1004658.55687031];
        region_box{1} = [-449535.713606583,-1020270.91563210;-250499.964600784,-863289.494238813];
        
    elseif rnum == 7
        %%%%% Ryder Glacier
        region_box{1} = [-205945.426461153,-1032952.51165399;-123912.664623873,-870183.034732056];
        
    end
    
    %%%%%%%%%%%%%% The region boxes were originaly defined when I was using
    %%%%%%%%%%%%%% a -39 projection, not the -45 projection. For regions
    %%%%%%%%%%%%%% 1-7, which were the defined boxes when this was true, we
    %%%%%%%%%%%%%% apply the projection correction here.
    
    if rnum <= 7
        for i = 1:length(region_box);
            [lat_temp lon_temp] = polarstereo_inv(region_box{i}(:,1),region_box{i}(:,2),1);
            [region_box{i}(:,1) region_box{i}(:,2)] = polarstereo_fwd(lat_temp,lon_temp);
        end
    end
    
    
end


%%%%%%%%%%% This tool can be used to extract information for new regions if
%%%%%%%%%%% needed:
if 0
    %%
    region_temp = [get(gca,'Xlim')' get(gca,'YLim')'];
end


%%
%%%%%%%%%% This selection determines whether or not you are trying to zoom
%%%%%%%%%% on a plot, or subselect data from a grid. The first chunk of
%%%%%%%%%% code is devoted to the plotting option
if box0_plot1_or_subselect2 == 0
    output_grid = 0;
    output_inds = 0;
elseif box0_plot1_or_subselect2 == 1
    xvert = [];
    yvert = [];
    segment = [];
    
    %%%%% This collects all of the corner values used to define the
    %%%%% ice-stream of interest, and converts them to box edge segments
    %%%%% for analysis.
    for i = 1:length(region_box)
        b_temp = combvec(region_box{i}(:,1)',region_box{i}(:,2)')';
        b_temp(3:4,:) = b_temp([4 3],:);
        region_box2{i} = b_temp;
        
        xvert = [xvert; b_temp(:,1)];
        yvert = [yvert; b_temp(:,2)];
        for j = 1:length(region_box2{i}(:,1))
            start = j;
            stop = j+1;
            if stop > length(region_box2{i}(:,1))
                stop = 1;
            end
            segment = [segment; region_box2{i}(start,1:2) region_box2{i}(stop,1:2)];
        end
    end
    
    %%%%%% Here, using the segments previously calculated, we add to the
    %%%%%% list of vertices all edge intersections (for the eventual
    %%%%%% drawing of the outline of the total area).
    for i = 1:length(segment)
        test_inds = 1:length(segment);
        test_inds(i) = [];
        for j = 1:length(test_inds)
            
            [int_flag temp] = segment_intersect([segment(i,1:2);segment(i,3:4)],[segment(j,1:2);segment(j,3:4)],0);
            if int_flag == 1
                xvert = [xvert; temp(1)];
                yvert = [yvert; temp(2)];
            end
        end
    end
    
    %%%%%% Here we find which vertices lie entirely within a box, and
    %%%%%% remove them from the list of vertices used to draw the overall
    %%%%%% outline.
    exclude_vec = [];
    for i = 1:length(region_box2)
        [in on] = inpolygon(xvert,yvert,region_box2{i}(:,1),region_box2{i}(:,2));
        exclude_vec = [exclude_vec; find(in == 1 & on == 0)];
    end
    
    xvert(exclude_vec) = [];
    yvert(exclude_vec) = [];
    xy = [xvert yvert];
    xy = remove_duplicates(xy);
    
    %%%%%% Finally (in an act of extreme overkill), we use a genetic
    %%%%%% algorithm to solve the travelling salesman problem, and find the
    %%%%%% order of vertices which defines the total box outline.
    
    userConfig = struct('xy',xy,'numIter',20*length(region_box2),'showProg',false,'showResult',false,'showWaitbar',false);
    tsp_results = tsp(userConfig);
    box_edge = xy([tsp_results.optRoute tsp_results.optRoute(1)],:);
    
    %%%%%% Then we plot the results
    hold all
    plot(box_edge(:,1),box_edge(:,2),'Color','black','LineWidth',2)
    title(region_names{rnum})
    xrange = max(box_edge(:,1))-min(box_edge(:,1));
    yrange = max(box_edge(:,2))-min(box_edge(:,2));
    if exist('datax') == 1
        if datax == 1
            xlim([min(box_edge(:,1))-xrange*0.1 max(box_edge(:,1))+xrange*0.1]);
            ylim([min(box_edge(:,2))-yrange*0.1 max(box_edge(:,2))+yrange*0.1]);
        end
    end
    NDH_Style()
    
    output_grid = 0;
    output_inds = 0;
elseif box0_plot1_or_subselect2 == 2
    output_grid = zeros(length(datay),length(datax));
    
    for i = 1:length(region_box)
        tx = [find_nearest(datax,region_box{i}(1,1)):find_nearest(datax,region_box{i}(2,1))];
        ty = [find_nearest(datay,region_box{i}(1,2)):find_nearest(datay,region_box{i}(2,2))];
        output_grid(ty,tx) = 1;
    end
    
    output_inds = find(output_grid == 1);
end

region_name = region_names{rnum};

if length(region_box) == 1
    region_box = region_box{1};
end

end

























