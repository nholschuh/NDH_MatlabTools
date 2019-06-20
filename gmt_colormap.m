function gmt_colormap(colors,axis,filename,interp_or_not,discrete_or_cont,bot_top_nan,plotter)
% Create a GMT Colormap File
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input Variables
% colors - nx4 matrix, with the index colors in the nx3, and the percentage
%          along the colormap for the index colors. 
% axis - vector containing the transition values for the colors.
% filename - string containing the filename for the colormap
% intero_or_not - 0, do not interpolate values, 1, interpolate values
% discrete_or_cont - 0, discrete, 1, continuous
% bot_top_nan - vector containing values for the bottom, the top, and nan
% plotter - 0 or 1, produce colormap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if exist('plotter') == 0
    plotter = 1;
end
if exist('discrete_or_cont') == 0
    discrete_or_cont = 1;
end
if exist('interp_or_not') == 0
    interp_or_not = 0;
end
if exist('bot_top_nan') == 0
    bot_top_nan = 0;
end


fid=fopen(filename,'w');

% This uses the fractional entries in the colors file to determine the
% spacing between index colors
total_length = length(axis)-1;
if length(colors(1,:)) == 3
    colors(:,4) = linspace(0,1,length(colors(:,1)));
end
for i = 1:length(colors(:,1))-1
    lengths(i) = round((colors(i+1,4)-colors(i,4))*total_length);
    if i > 1
        lengths(i) = lengths(i)+1;
    end
end

if sum(lengths) > (total_length+length(colors(:,1))-2)
    lengths(end) = lengths(end)-1;
elseif sum(lengths) < (total_length+length(colors(:,1))-2)
    lengths(end) = lengths(end)+1;
end

% Adds one more color if it will be a continuous color palette
if discrete_or_cont == 1
    lengths(end) = lengths(end)+1;
end

% Perform the interpolation between the index colors.
col1 = [];
col2 = [];
col3 = [];

if interp_or_not == 0
%     for i = 1:(length(colors(:,1))-1)
%         temp1 = [linspace(colors(i,1),colors(i+1,1),lengths(i))]';
%         temp2 = [linspace(colors(i,2),colors(i+1,2),lengths(i))]';
%         temp3 = [linspace(colors(i,3),colors(i+1,3),lengths(i))]';
%         if i == 1
%             col1 = [col1; temp1];
%             col2 = [col2; temp2];
%             col3 = [col3; temp3];
%         elseif i > 1
%             col1 = [col1; temp1(2:end)];
%             col2 = [col2; temp2(2:end)];
%             col3 = [col3; temp3(2:end)];
%         end
%     end
%     colorvals = [col1 col2 col3];
    col1 = interp1(colors(:,4),colors(:,1),linspace(min(colors(:,4)),1,length(axis)-(1-discrete_or_cont)));
    col2 = interp1(colors(:,4),colors(:,2),linspace(min(colors(:,4)),1,length(axis)-(1-discrete_or_cont)));
    col3 = interp1(colors(:,4),colors(:,3),linspace(min(colors(:,4)),1,length(axis)-(1-discrete_or_cont)));
    colorvals = [col1' col2' col3'];
    
else
    colorvals = [colors(:,1:3)];
end


if max(colorvals) <= 1
    colorvals = colorvals*255;
end

% Print out the colormap file
if discrete_or_cont == 0
    for i = 1:total_length
        fprintf(fid,'%.4f \t %.1f \t %.1f \t %.1f \t %.4f \t %.1f \t %.1f \t %.1f \n',[axis(i) colorvals(i,:) axis(i+1) colorvals(i,:)]);
    end
else
    for i = 1:total_length
        fprintf(fid,'%.4f \t %.1f \t %.1f \t %.1f \t %.4f \t %.1f \t %.1f \t %.1f \n',[axis(i) colorvals(i,:) axis(i+1) colorvals(i+1,:)]);
    end
end



% Add in the final colors for the system
if length(bot_top_nan) == 1
    fprintf(fid,'%s \t %.1f \t %.1f \t %.1f \n','B',colorvals(1,:));
    fprintf(fid,'%s \t %.1f \t %.1f \t %.1f \n','F',colorvals(end,:));
    fprintf(fid,'%s \t %.1f \t %.1f \t %.1f \n','N',colorvals(1,:));
else
    if max(bot_top_nan(1,:)) == 0
        bot_top_nan(1,:) = colorvals(1,:);
    end
    if max(bot_top_nan(2,:)) == 0
        bot_top_nan(2,:) = colorvals(end,:);
    end
    if max(bot_top_nan(3,:)) == 0
        bot_top_nan(3,:) = colorvals(1,:);
    end
    fprintf(fid,'%s \t %.1f \t %.1f \t %.1f \n','B',bot_top_nan(1,:));
    fprintf(fid,'%s \t %.1f \t %.1f \t %.1f \n','F',bot_top_nan(2,:));
    fprintf(fid,'%s \t %.1f \t %.1f \t %.1f \n','N',bot_top_nan(3,:));
end
fclose(fid);


% Plot the colormap if it is included.
if plotter == 1
    figure()
    if discrete_or_cont == 0;
        plot_length = length(axis)-1;
    else
        plot_length = length(axis)-2;
    end
    
    for i = 1:plot_length
        hold all
        if discrete_or_cont == 0;
            fill([0 1 1 0 0],[i-1 i-1 i i i-1],colorvals(i,1:3)/255);
        else
            fill([0 0.5 0.5 0 0],[i-1 i-1 i i i-1],colorvals(i,1:3)/255);
            fill([0.5 1 1 0.5 0.5],[i-1 i-1 i i i-1],colorvals(i+1,1:3)/255);
        end
        text(1.5,i-1,num2str(axis(i)));
    end
    text(1.5,i,num2str(axis(end)));
    xlim([0 3])
end

    

end
    