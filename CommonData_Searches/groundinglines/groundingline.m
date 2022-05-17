function newgl = groundingline(num,m0_or_km1,sizes,col,subsetter,line0_or_poly1)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% plots the Antarctic Grounding Line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% num - This specifies the groundingline of interest:
%       1: MODIS Groundingline
%       2: IceSat Groundingline
%       3: ASAID Groundingline
%       4: MEASURES Groundingline
%       5: Antarctica Outline
%       6: Greenland Floatation Groundingline
%       7: Greenland Outline
% m0_or_km1 - defines whether or not the output should be in m or km
% sizes - defines the size of markers in plot of the groundingline
% col - three value vector defining the color of plotted points
% subsetter - this defines what fraction of the gl points to include
% line0_or_poly1 - this defines whether or not the line should be plotted
%                   as points or as a filled polygon
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% newgl - the x/y coordinates of the plotted groundingline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% This section looks at how much of Antarctica is present in the plot, and
% decides whether or not it should plot the entire groundingline data set
% or just the subset that falls near the plotted zone.

if exist('m0_or_km1') == 0
    m0_or_km1 = 0;
end

if m0_or_km1 == 0
    mscaler = 1;
else
    mscaler = 1/1000;
end

if exist('line0_or_poly1') == 0
    line0_or_poly1 = 0;
end

if get(gca,'XLim') == [0 1]
    if num == 6 | num == 7
        ys = [-3400000 -500000]*mscaler;
        xs = [-650000 850000]*mscaler;
    else
        ys = [-2700000 2700000]*mscaler;
        xs = [-2700000 2700000]*mscaler;
    end
    equal_flag = 1;
else
    ys = get(gca,'YLim');
    xs = get(gca,'XLim');
    equal_flag = 0;
end


%% Here we decide which Antarctic groundingline to use
if exist('subsetter') == 0
    subsetter = 1;
end
if subsetter == 0
    subsetter = 1;
end

if exist('num') == 0
     num = listdlg('ListString',{'A1 - MODIS Groundingline' ,...
        'A2 - IceSat Groundingline', ...
        'A3 - ASAID Groundingline', ...
        'A4 - MEASURES Groundingline', ...
        'A5 - Antarctica Outline', ...
        'G1 - Greenland Floatation Groundingline', ...
        'G2 - Greenland Outline', ...
        'RGLA - Antarctica Rough Groundingline', ...
        'RGLG - Greenland Rough Groundingline'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
        
end
if num == 1
    load moa_gl.mat
    
elseif num == 2
    load ICEsat_gl.mat
    num2 = input(sprintf('1 - The landward limit of flexure\n2 - The point where ice is hydrostatically balanced\n3 - The break in slope associated with flexure\n'));
    if num2 == 1
        gl = gl_1;
    elseif num2 == 2
        gl = gl_2;
    elseif num2 == 3
        gl = gl_3;
    end
    
elseif num == 3
    load ASAID_groundingline.mat
    
elseif num == 4
    load InSAR_gl.mat
elseif num == 5
    gl = dlmread('Ant_w_shelves.xy');
elseif num == 6
    gl = dlmread('greenland_gl.xy');
elseif num == 7
    gl = dlmread('Greenland_simplified_outline.xy');
elseif num == 8
    load('Antarctica_RoughGL.mat');
    gl = rough_gl;
elseif num == 9
    load('Greenland_RoughGL.mat');
    gl = rough_gl;    
end

gl = gl*mscaler;


%% Here we subset the data if it was deemed necessary, and then plot the grounding line

subset = find(gl(:,1) > xs(1) & gl(:,1) < xs(2) & gl(:,2) > ys(1) & gl(:,2) < ys(2));
newgl = gl(subset,:);


%%% This portioin looks at the plot to determine if there was another
%%% groundingline already plotted, and assigns a new color if so.
hold all
obs = get(gca,'Children');

if exist('col') == 0
    for i = 1:length(obs)
        if length(get(obs(i),'Type')) == 4
            if length(get(obs(i),'DisplayName')) == 2;
                col = rand(1)*0.7;
                col = [col col col];
                break
            else
                col = [0 0 0];
            end
        else
            col = [0 0 0];
        end
    end
end


if line0_or_poly1 == 0
    if exist('col') == 0
        col = [0 0 0];
    end
    %%% The actual plotting.
    if length(gl(:,1)) > 100000
        if exist('sizes') == 1
            if sizes == 0
                sizes = 5;
            end
            plot(newgl(1:subsetter:end,1),newgl(1:subsetter:end,2),'.','Color',col,'MarkerSize',sizes,'MarkerFaceColor',col,'DisplayName','gl','HandleVisibility','off')
        else
            plot(newgl(1:subsetter:end,1),newgl(1:subsetter:end,2),'.','Color',col,'MarkerSize',5,'MarkerFaceColor',col,'DisplayName','gl','HandleVisibility','off')
        end
    else
            plot(newgl(1:subsetter:end,1),newgl(1:subsetter:end,2),'Color',col,'DisplayName','gl','HandleVisibility','off')       
    end
    
    xlim(xs)
    ylim(ys)
    if equal_flag == 1
        axis equal
    end
else
    fill(newgl(1:subsetter:end,1),newgl(1:subsetter:end,2),col);
end
    newgl = newgl(1:subsetter:end,:);


end
