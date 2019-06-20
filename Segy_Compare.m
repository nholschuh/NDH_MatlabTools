function results = Segy_Compare(data1,header1,var_inputs,varargin)
% (C) Nick Holschuh - Chevron Corporation - 2014 (Nick.Holschuh@gmail.com)
% Extracts a cut of the 3d seismic volume, or compares multiple cuts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% One or more paired sets of:
%
% data# - data volume output from ReadSegy
% header# - header output from ReadSegy
% with var_inputs structured -  [reverse_xlineinline  read_inline/crossline/horizon/trace   the_index(inline for trace) index_2(crossline)]
%                               [         1-2                     1-2-3-4                       #                              #           ]
%
%
% Output:
% Structure with the following 6 columns -
% 1 - Xaxis Index
% 2 - Yaxis Index
% 3 - Data
% 4 - Spatial Coord (x)
% 5 - Spatial Coord (y)
% 6 - Time Values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Extracts a cut of the 3d seismic volume, or compares multiple cuts

plotter = 0;

lines = nargin;
lines = nargin/2;

if exist('var_inputs') == 0
    var_inputs = 0;
end

%% Provide options to user

for k = 1:lines
    if k == 1
        Base = data1;
        B_Headers = header1;
    else
        Base = varargin{(k-2)*2+1};
        B_Headers = varargin{(k-1)*2};
    end
    time = B_Headers(1,1).LagTimeA:B_Headers(1,1).dt/1000:(B_Headers(1,1).LagTimeA+((B_Headers(1,1).ns)-1)*B_Headers(1,1).dt/1000);
    
    for i = 1:length(B_Headers)
        inline_index(i) = B_Headers(1,i).Inline3D;
        inline_axis(i) = B_Headers(1,i).SourceX/100;
        crossline_index(i) = B_Headers(1,i).Crossline3D;
        crossline_axis(i) = B_Headers(1,i).SourceY/100;
    end
    
    if max(inline_index) == 0
        trend = sign(inline_axis(2)-inline_axis(1));
        for i = 1:length(inline_axis)
            if sign(inline_axis(i+1)-inline_axis(i)) ~= trend;
                rep = i;
                break
            end
        end
        crossline_index = 1:i;
        reps = (length(crossline_axis)/length(crossline_index));
        crossline_index = repmat(crossline_index,1,reps);
        inline_index = [];
        for i = 1:reps
            inline_index = [inline_index ones(1,rep)*i];
        end
        
    end
            
        
    
    timestart = B_Headers(1,1).LagTimeA;
    
    samples = B_Headers(1,i).ns;
    dt = B_Headers(1,i).dt/1000;
    times = (1:samples)*dt+timestart;
    
    
    inline_range = min(inline_index):max(inline_index);
    crossline_range = min(crossline_index):max(crossline_index);
    
    if k == 1
        
        if length(var_inputs) < 3
            choice_type = menu('Data Type','Normal','Backward');
            if choice_type == 2
                temp = crossline_range;
                crossline_range = inline_range;
                inline_range = temp;
                temp = crossline_axis;
                crossline_axis = inline_axis;
                inline_axis = temp;
            end
            
            choice = menu('Orientation','Inline','Crossline','Horizon','Trace');
            
            if choice == 1
                prompt = ['Select line (',int2str(inline_range(1)),' - ',int2str(inline_range(end)),')'];
            elseif choice == 2
                prompt = ['Select line (',int2str(crossline_range(1)),' - ',int2str(crossline_range(end)),')'];
            elseif choice == 3
                prompt = ['Select horizon (',int2str(times(1)),'ms - ',int2str(times(end)),'ms)'];
            elseif choice == 4
                prompt = ['Select Inline (',int2str(inline_range(1)),' - ',int2str(inline_range(end)),')'];
                prompt2 = ['Select Crossline (',int2str(crossline_range(1)),' - ',int2str(crossline_range(end)),')'];
            end
            
            linenum = inputdlg(prompt);
            linenum = str2num(linenum{1});
            
            if choice == 4
                tracenum = inputdlg(prompt2);
                tracenum = str2num(tracenum{1});
            end
        else
            choice = var_inputs(2);
            linenum = var_inputs(3);
            if length(var_inputs) == 4
                tracenum = var_inputs(4);
            end
        end
    else
        if length(var_inputs) < 3  % Interactive selection or scripted input
            choice2 = menu(sprintf('Use the same cut for\nthe next data set?'),'Yes','No');
        else
            choice2 = 1;
        end
        
        if choice2 == 2
            choice = menu('Orientation','Inline','Crossline','Horizon','Trace');
            
            if choice == 1
                prompt = ['Select line (',int2str(inline_range(1)),' - ',int2str(inline_range(end)),')'];
            elseif choice == 2
                prompt = ['Select line (',int2str(crossline_range(1)),' - ',int2str(crossline_range(end)),')'];
            elseif choice == 3
                prompt = ['Select horizon (',int2str(times(1)),'ms - ',int2str(times(end)),'ms)'];
            elseif choice == 4
                prompt = ['Select Inline (',int2str(inline_range(1)),' - ',int2str(inline_range(end)),')'];
                prompt2 = ['Select Crossline (',int2str(crossline_range(1)),' - ',int2str(crossline_range(end)),')'];
            end
            
            linenum = inputdlg(prompt);
            linenum = str2num(linenum{1});
            
            if choice == 4
                tracenum = inputdlg(prompt2);
                tracenum = str2num(tracenum{1});
            end
        end
    end
    
    
    
    base_to_plot = [];
    
    if choice == 1
        
        if plotter == 1
        axis_name(k) = subplot(1,lines,k);
        end
        
        line_ind = find(linenum == inline_range);
        columns = ((line_ind-1)*length(crossline_range)+1):((line_ind)*length(crossline_range));
        base_to_plot = Base(:,columns);
        xaxis_values = inline_axis(columns);
        yaxis_values = crossline_axis(columns);
        if plotter == 1
            imagesc(crossline_range,times,base_to_plot)
            ylabel('Two-way Travel Time (ms)')
            xlabel('Crossline Index (#)')
            title(['Baseline Survey - Inline #',int2str(inline_range(line_ind))])
            
            crange = max([abs(min(min(base_to_plot))) max(max(base_to_plot))]);
            cmap = b2r(-crange,crange);
            caxis([-crange crange])
            colormap(cmap)
            if k == 1
                xlims = get(gca,'XLim');
                ylims = get(gca,'YLim');
            end
            xlim(xlims)
            ylim(ylims)
        end
        
        xaxis = crossline_range;
        yaxis = times;
        
    elseif choice == 2
        if plotter == 1
        axis_name(k) = subplot(1,lines,k);
        end
        line_ind = find(linenum == crossline_range);
        columns = line_ind:length(crossline_range):length(crossline_range)*(length(inline_range)-1)+line_ind;
        base_to_plot = Base(:,columns);
        xaxis_values = inline_axis(columns);
        yaxis_values = crossline_axis(columns);
        
        if plotter == 1
            imagesc(inline_range,times,base_to_plot)
            ylabel('Two-way Travel Time (ms)')
            xlabel('Inline Index (#)')
            title(['Baseline Survey - Crossline #',int2str(crossline_range(line_ind))])
            
            crange = max([abs(min(min(base_to_plot))) max(max(base_to_plot))]);
            cmap = b2r(-crange,crange);
            caxis([-crange crange]);
            colormap(cmap);
            if k == 1
                xlims = get(gca,'XLim');
                ylims = get(gca,'YLim');
            end
            xlim(xlims)
            ylim(ylims)
        end
        
        xaxis = inline_range;
        yaxis = times;
        
    elseif choice == 3
        if plotter == 1
        axis_name(k) = subplot(1,lines,k);
        end
        line_ind = find_nearest(times,linenum)
        for i = 1:length(crossline_range)
            for j = 1:length(inline_range)
                base_to_plot(j,i) = Base(line_ind,i+(j-1)*length(crossline_range));
            end
        end
        if plotter == 1
            imagesc(inline_range,crossline_range,base_to_plot)
            ylabel('Inline Index (#)')
            xlabel('Crossline Index (#)')
            title(['Baseline Survey - Time (',int2str(times(line_ind)),'ms)'])
            
            crange = max([abs(min(min(base_to_plot))) max(max(base_to_plot))]);
            cmap = b2r(-crange,crange);
            caxis([-crange crange]);
            colormap(cmap);
            if k == 1
                xlims = get(gca,'XLim');
                ylims = get(gca,'YLim');
            end
            
            xlim(xlims)
            ylim(ylims)
        end
        
        xaxis = inline_range;
        yaxis = crossline_range;
        
    elseif choice == 4
        
        line_ind = find(linenum == inline_range);
        inline_data = Base(:,((line_ind-1)*length(crossline_range)+1):((line_ind)*length(crossline_range)));
        crossline_ind = find(tracenum == crossline_range);
        trace = inline_data(:,crossline_ind);
        
        if k == 1
            col = 'black';
        elseif k == 2
            col = 'blue';
        elseif k == 3
            col = 'red';
        elseif k >3
            col = [0.5 0.5 0.5];
        end
        if plotter == 1
            plot(trace,times,'Color',col,'LineWidth',2)
            xrange = max([abs(min(trace)) max(trace)]);
            if k == 1
                xrange_test = xrange;
                xrange = xrange+0.3*xrange;
                xlim([-xrange xrange])
            else
                if xrange > xrange_test
                    xrange_test = xrange;
                    xrange = xrange+0.3*xrange;
                    xlim([-xrange xrange])
                end
            end
            
            set(gca,'YDir','reverse')
            title(['Baseline Survey IL = ',int2str(inline_range(line_ind)),' CL = ',int2str(crossline_range(crossline_ind))])
            ylabel('Two-way Travel Time (ms)')
            xlabel('Amplitude')
            hold all
        end
        
        yaxis = times;
    end
    
    if choice < 4
        results{k,1} = xaxis;
        results{k,2} = yaxis;
        results{k,3} = base_to_plot;
        results{k,4} = xaxis_values;
        results{k,5} = yaxis_values;
        results{k,6} = time;
    else
        results{k,1} = yaxis;
        results{k,2} = trace;
        results{k,3} = time;
    end
end

if choice < 4 & plotter == 1
    linkaxes(axis_name,'xy')
end

end

