function CReSIS_map(map_type,output_name,selection,source_flight)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Plots the data from a specific set of CReSIS flights to find the right
% locations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% map_type - 1=Plot for an entire season (colored by day)
%            2=Plot for a day (colored by line index);
%            3=Plot for a segment (colored by frame);
%
% output_name - name for the file to produce - defaults to flight info
%
% selection - 2 value vector, containing the day and the month [maptype2]
%             2or3 value vector, containing day month seg [maptype3]
%
% source_flight - The name of the season. If you don't know, enter 0.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


zoom_type = 1;
%%%% zoom types
% 0 - Zoom to the full annual survey
% 1 - Zoom just to the local survey info

if exist('map_type') == 0
    map_type = 1;
end

if exist('output_name') == 0
    output_name = [];
end

    flight_names = {'2002_P3',...
        '2004_P3',...
        '2005_WAIS',...
        '2009_DC8',...
        '2009_TO',...
        '2009_TO_G',...
        '2010_DC8',...
        '2011_DC8',...
        '2011_TO',...
        '2012_DC8',...
        '2013_Basler',...
        '2013_P3',...
        '2014_DC8',...
        '2016_DC8',...
        '2017_Polar6'};

%%%%%%%%%% Here we provide an opportunity to select the flight season
if exist('source_flight') == 0 || max(source_flight == 0) == 1
    flight_selection = listdlg('ListString',flight_names,'PromptString','Select the Flight Year');
    source_flight = flight_names{flight_selection};
elseif length(source_flight) == 1
    source_flight =  flight_names{source_flight};
end

%%%%%%%%% Load in the aggregated Data Set
source_file = [OnePath,'Matlab_Code/NDH_tools/CommonData_Searches/CReSIS_Data/Antarctica/'];
source_file = [source_file,source_flight,'.mat'];
load(source_file)
disp('Loaded Source File')

years = remove_duplicates(Data_Vals2(:,15));
day_month = remove_duplicates(Data_Vals2(:,13:14));
disp('Identified the flight dates')



%%%%%%%%% Find the appropriate data divisions based on map type
if map_type == 1
    new_data = Data_Vals2(:,:);
    [garbage start_line_ind] = remove_duplicates(Data_Vals2(:,13)+Data_Vals2(:,14)*100+Data_Vals2(:,15)*10000);
    total_lines = length(start_line_ind);
    start_line_ind(length(start_line_ind)+1) = length(Data_Vals2(:,1));
    colorline = jet(total_lines);
    x_stops = linspace(0,1,total_lines+1);
elseif map_type == 2
    
    %%%% This allows for the selection of flight day if unknown
    if exist('selection') == 0 || max(source_flight == 0) == 1
        for j = 1:length(day_month(:,1))
            selection_string{j} = [num2str(day_month(j,2)),'/',num2str(day_month(j,1))];
        end
        select_ind = listdlg('ListString',selection_string,'PromptString','Select the Flight Day');
        selection = day_month(select_ind,:);
    end
    
    
    data_inds = find(Data_Vals2(:,13) == selection(1) & Data_Vals2(:,14) == selection(2));
    new_data = Data_Vals2(data_inds,:);
    
    [garbage start_line_ind] = remove_duplicates(new_data(:,12));
    total_lines = length(start_line_ind);
    
    start_line_ind(length(start_line_ind)+1) = length(new_data(:,1));
    colorline = jet(total_lines);
    x_stops = linspace(0,1,total_lines+1);
    
elseif map_type == 3
    
    %%%% This allows for the selection of flight line if unknown
    if exist('selection') == 0
        for j = 1:length(day_month(:,1))
            selection_string{j} = [num2str(day_month(j,2)),'/',num2str(day_month(j,1))];
        end
        select_ind = listdlg('ListString',selection_string,'PromptString','Select the Flight Day');
        selection = day_month(select_ind,:);
    end
    
    data_inds = find(Data_Vals2(:,13) == selection(1) & Data_Vals2(:,14) == selection(2));
    new_data = Data_Vals2(data_inds,:);
    
    lines = remove_duplicates(new_data(:,12));
    
    selection_string = {};
    if length(selection) < 3
        for j = 1:length(lines)
            selection_string{j} = ['Line number ',num2str(lines(j))];
        end
        select_ind = listdlg('ListString',selection_string,'PromptString','Select the Flight Line on that Day');
        selection = [selection lines(select_ind)];
    end
    
    data_inds = find(new_data(:,12) == selection(3));
    new_data = new_data(data_inds,:);
    
    [garbage start_line_ind] = remove_duplicates(new_data(:,11));
    total_lines = length(start_line_ind);
    
    start_line_ind(length(start_line_ind)+1) = length(new_data(:,1));
    colorline = jet(total_lines);
    x_stops = linspace(0,1,total_lines+1);
    
end




%%%%%%%%% Start the plotting by laying down the base image

if zoom_type == 0
    minx = min(Data_Vals2(:,1))-1e5;
    maxx = max(Data_Vals2(:,1))+1e5;
    miny = min(Data_Vals2(:,2))-1e5;
    maxy = max(Data_Vals2(:,2))+1e5;
elseif zoom_type == 1
    minx = min(new_data(:,1))-1e5;
    maxx = max(new_data(:,1))+1e5;
    miny = min(new_data(:,2))-1e5;
    maxy = max(new_data(:,2))+1e5;    
end

    skipper = 50;
    
figure()
subplot(8,1,1:7)
Antarctic_Imagery(0,minx,maxx,miny,maxy,1,1);
groundingline(1);
hold all
set(gcf,'Position',[243         0        1128        1063])
axis equal
plot(Data_Vals2(1:skipper:end,1),Data_Vals2(1:skipper:end,2),'.','Color','white')

if exist('new_data') == 0
    keyboard
end
if length(new_data) == 0
    keyboard
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The actual plotting of the data
for k = 1:total_lines
    subplot(8,1,1:7)
    plot(new_data(start_line_ind(k):skipper:start_line_ind(k+1)-1,1),new_data(start_line_ind(k):skipper:start_line_ind(k+1)-1,2),'.','Color',colorline(k,:));
    hold all
    
    %%%% Plot the start of lines, with 5s and 10s starting black
    if mod(k,5) == 0
        plot(new_data(start_line_ind(k),1),new_data(start_line_ind(k),2),'s','Color','black','MarkerFaceColor','black','MarkerSize',4);
    else
        plot(new_data(start_line_ind(k),1),new_data(start_line_ind(k),2),'s','Color',colorline(k,:),'MarkerFaceColor',colorline(k,:),'MarkerSize',4);
    end
    
    subplot(8,1,8)
    plot(x_stops(k:k+1),zeros(1,2),'Color',colorline(k,:),'LineWidth',2)
    hold all
    plot([x_stops(k) x_stops(k)],[0.1 -0.1],'Color','black')
    
    if map_type == 1
        text(mean(x_stops(k:k+1)),0.5,num2str(new_data(start_line_ind(k),14)),'HorizontalAlignment','center')
        text(mean(x_stops(k:k+1)),-0.5,num2str(new_data(start_line_ind(k),13)),'HorizontalAlignment','center')
    elseif map_type == 2
        text(mean(x_stops(k:k+1)),-0.5,num2str(new_data(start_line_ind(k),12)),'HorizontalAlignment','center')
    elseif map_type == 3
        text(mean(x_stops(k:k+1)),-0.5,num2str(new_data(start_line_ind(k),11)),'HorizontalAlignment','center')
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The titling of the plot
if map_type == 1
    text(-0.08,0.5,'Month')
    text(-0.08,-0.5,'Day')
    set(gca,'xtick',[],'ytick',[])
    xlim([-0.1 1])
    ylim([-1 1])
    if length(years) == 1
        title(['CReSIS Flights from ',num2str(years(1))]);
    else
        title(['CReSIS Flights from ',num2str(years(1)),'/',num2str(years(2))]);
    end
    
    if length(output_name) == 0
        output_name = ['CReSIS_Flights_',source_flight];
    end     
elseif map_type == 2
    text(-0.08,-0.5,'Line Index')
    set(gca,'xtick',[],'ytick',[])
    xlim([-0.1 1])
    ylim([-1 1])
    if length(years) == 1
        title(['CReSIS Flights from ',num2str(years(1)),' ',num2str(selection(1)),'/',num2str(selection(2))]);
    else
        title(['CReSIS Flights from ',num2str(years(1)),'/',num2str(years(2)),' ',num2str(selection(2)),'/',num2str(selection(1))]);
    end
    
    if length(output_name) == 0
        output_name = ['CReSIS_Flights_',source_flight,'_',sprintf('%0.2d%0.2d',selection(2),selection(1))];
    end   
elseif map_type == 3
    text(-0.08,0.5,'Subline')
    text(-0.08,-0.5,'Index')
    set(gca,'xtick',[],'ytick',[])
    xlim([-0.1 1])
    ylim([-1 1])
    if length(years) == 1
        title(['CReSIS Flights from ',num2str(years(1)),' ',num2str(selection(1)),'/',num2str(selection(2)),' Line ',num2str(selection(3))]);
    else
        title(['CReSIS Flights from ',num2str(years(1)),'/',num2str(years(2)),' ',num2str(selection(2)),'/',num2str(selection(1)),' Line ',num2str(selection(3))]);
    end
    
    if length(output_name) == 0
        output_name = ['CReSIS_Flights_',source_flight,'_',sprintf('%0.2d%0.2d',selection(2),selection(1)),'_',sprintf('%0.3d',selection(3))];
    end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Writing out of the file
subplot(8,1,1:7)
    if zoom_type == 0
        xs = [min(Data_Vals2(:,1))-1e5 max(Data_Vals2(:,1))+1e5];
        ys = [min(Data_Vals2(:,2))-1e5 max(Data_Vals2(:,2))+1e5];
    elseif zoom_type == 1
        xs = [min(new_data(:,1))-1e5 max(new_data(:,1))+1e5];
        ys = [min(new_data(:,2))-1e5 max(new_data(:,2))+1e5];        
    end
        title(true_name(output_name))
        xlim(xs)
        ylim(ys)
        NDH_Style()
        location_map(xs(1),xs(2),ys(1),ys(2),1,0,0,0.5)
pause(1)
if length(output_name) > 1 & output_name ~= 0
pdf_ndh(output_name)
end

end


