function QC_ui_simplified(varargin)
% 1 and 2 - Baseline
% 3       - Parameters for initial line, or 0 for UI selection
% 4 and 5 - Monitor
% 6 and 7 - Amplitude Warping
% 8 and 9 - Phase Warping


types = [6 7 8 9];

if varargin{3} == 0
    slice = Segy_Compare_Simplified(varargin{1},varargin{2},[0],varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9});
    varargin = {varargin{1:2},slice{1,end},varargin{4:end}};
    trace_index = slice{1,1};
    if length(trace_index) == length(min([varargin{2}.Crossline3D]):max([varargin{2}.Crossline3D]))
            title_add = 'Cross';
            title_add2 = 'Inline';
            lineindex = [varargin{2}.Inline3D];
            lineindex = min(lineindex):max(lineindex);
    else
        title_add = 'In';
        title_add2 = 'Crossline';
        lineindex = [varargin{2}.Crossline3D];
        lineindex = min(lineindex):max(lineindex);
    end
    t = slice{1,6};
else
    slice = Segy_Compare_Simplified(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9});
    trace_index = slice{1,1};
    if varargin{3}(2) == 1
        title_add = 'Cross';
        title_add2 = 'Inline';
        lineindex = [varargin{2}.Crossline3D];
        lineindex = min(lineindex):max(lineindex);
    else
        title_add = 'In';
        title_add2 = 'Crossline';
        lineindex = [varargin{2}.Inline3D];
        lineindex = min(lineindex):max(lineindex);
    end
    t = slice{1,6};
end

% Create a figure and axes
h.fig = figure('Position', [100, 100, 1565, 895]);
set(h.fig,'toolbar','figure');

current1 = min(trace_index);
current2 = min(lineindex);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Create Buttons to apply timeshift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lp = 140;

h.btn1 = uicontrol('Style', 'pushbutton', 'String', 'Unshifted',...
    'Position', [lp 100 80 40],...
    'Callback', @ts_recover);
h.btn2 = uicontrol('Style', 'pushbutton', 'String', 'Shift - Amp',...
    'Position', [lp 60 80 40],...
    'Callback', @ts_amp);
h.btn3 = uicontrol('Style', 'pushbutton', 'String', 'Shift - Phase',...
    'Position', [lp 20 80 40],...
    'Callback', @ts_phase);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Create Buttons to Switch to TimeStrain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.btn4 = uicontrol('Style', 'pushbutton', 'String', 'Time Shift Panels',...
    'Position', [lp+360 80 140 60],...
    'Callback', @tshift_switch,...
    'Enable','off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Create Buttons to Write out Trace Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h.btn8 = uicontrol('Style', 'pushbutton', 'String', 'Write Out Trace Data',...
    'Position', [1345 20 150 20],'UserData',{'(Processing Steps)'},...
    'Callback', @trace_write);

h.btn8b = uicontrol('Style', 'pushbutton', 'String', 'Write Out Line Data',...
    'Position', [1345 40 150 20],...
    'Callback', @line_write);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Create Buttons to Filter / edit tshifts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
separation = 120;

h.btn9 = uicontrol('Style', 'pushbutton', 'String', 'Bandstop',...
    'Position', [lp+640+separation 80 100 20],...
    'Callback', @apply_bandstop);

h.btn10 = uicontrol('Style', 'pushbutton', 'String', 'Bandpass',...
    'Position', [lp+740+separation 80 100 20],...
    'Callback', @apply_bandpass);

h.filtmin = uicontrol('Style', 'edit', 'String', ' ','BackgroundColor','white',...
    'Position', [lp+680+separation 100 60 20]);
h.filtmin_label = uicontrol('Style', 'text', 'String', 'Max F',...
    'Position', [lp+800+separation 100 40 20]);
h.filtmax = uicontrol('Style', 'edit', 'String', ' ','BackgroundColor','white',...
    'Position', [lp+740+separation 100 60 20]);
h.filtmax_label = uicontrol('Style', 'text', 'String', 'Min F',...
    'Position', [lp+640+separation 100 40 20]);
h.filtmax_title = uicontrol('Style', 'text', 'String', 'Filter Time Shifts',...
    'Position', [lp+640+separation 120 200 20]);


h.btn11a = uicontrol('Style', 'pushbutton', 'String', 'Apply the Time Shifts - A',...
    'Position', [lp+640+separation 60 160 20],'Enable','off',...
    'Callback', @use_new_tshifts1);
h.btn11b = uicontrol('Style', 'pushbutton', 'String', 'P',...
    'Position', [lp+800+separation 60 40 20],'Enable','off',...
    'Callback', @use_new_tshifts2);

h.btn12 = uicontrol('Style', 'pushbutton', 'String', 'Derivative',...
    'Position', [lp+640+separation 40 80 20],'Enable','on',...
    'Callback', @derivative_filt);
h.btn12b = uicontrol('Style', 'pushbutton', 'String', 'Gaussian',...
    'Position', [lp+720+separation 40 80 20],'Enable','on',...
    'Callback', @gaussian_filt);
h.GaussFilt= uicontrol('Style', 'edit', 'String','(s)','Enable','on','BackgroundColor','white',...
    'Position', [lp+800+separation 40 40 20]);

h.btn13 = uicontrol('Style', 'pushbutton', 'String', 'Bottom Crop',...
    'Position', [lp+640+separation 20 120 20],'Enable','on',...
    'Callback', @bottom_crop);

h.BottomSample= uicontrol('Style', 'edit', 'String','(time [ms])','Enable','on','BackgroundColor','white',...
    'Position', [lp+760+separation 20 80 20]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Create slider for trace selection changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.sld = uicontrol('Style', 'slider',...
    'Min',min(trace_index),'Max',max(trace_index),'Value',current1,...
    'Position', [lp+140 40 160 20],...
    'Callback', @traces_for_plot);

% Add a text uicontrol to label the slider.
h.txt1 = uicontrol('Style','text',...
    'Position',[lp+80 60 280 20],...
    'String',['Trace Index (',title_add2,')']);
h.txt2 = uicontrol('Style','text',...
    'Position',[lp+80 40 60 20],...
    'String',num2str(min(trace_index)));
h.txt3 = uicontrol('Style','text',...
    'Position',[lp+300 40 60 20],...
    'String',num2str(max(trace_index)));
h.txt4 = uicontrol('Style','text',...
    'Position',[lp+80 20 280 20],...
    'String',num2str(current1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Create slider for cross_line changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.sldb = uicontrol('Style', 'slider',...
    'Min',min([lineindex]),'Max',max([lineindex]),...
    'Value', current2,...
    'Position', [lp+140 100 160 20],...
    'Callback', @lines_for_plot);

% Add a text uicontrol to label the slider.
h.txt1b = uicontrol('Style','text',...
    'Position',[lp+80 120 280 20],...
    'String',[title_add,'line Index']);
h.txt2b = uicontrol('Style','text',...
    'Position',[lp+80 100 60 20],...
    'String',num2str(min([lineindex])));
h.txt3b = uicontrol('Style','text',...
    'Position',[lp+300 100 60 20],...
    'String',num2str(max([lineindex])));
h.txt4b = uicontrol('Style','text',...
    'Position',[lp+80 80 280 20],...
    'String',num2str(current2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Panels for Trace Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.dataPanel1 = uipanel(h.fig,...
    'Units','pixels',...
    'Position',[60 140 400 740],...
    'Title','Seismic Data','UserData',1);
h.dataPanel2 = uipanel(h.fig,...
    'Units','pixels','UserData',1,...
    'Position',[460 140 400 740],...
    'Title','Computed TimeShifts');

h.PlotAxes1 = axes(...    % Axes for plotting the selected plot
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Parent', h.dataPanel1);

h.PlotAxes2 = axes(...    % Axes for plotting the selected plot
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Parent', h.dataPanel2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Panels for 2D Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.dataPanel3 = uipanel(h.fig,...
    'Units','pixels',...
    'Position',[860 140 640 246],...
    'Title','TimeShifts - Phase');
h.dataPanel4 = uipanel(h.fig,...
    'Units','pixels',...
    'Position',[860 386 640 246],...
    'Title','TimeShifts - Amplitude');
h.dataPanel5 = uipanel(h.fig,...
    'Units','pixels',...
    'Position',[860 632 640 246],...
    'Title','Seismic Line');

h.PlotAxes5 = axes(...    % Axes for plotting the selected plot
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Parent', h.dataPanel3);
axes(h.PlotAxes5)


h.PlotAxes4 = axes(...    % Axes for plotting the selected plot
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Parent', h.dataPanel4);
axes(h.PlotAxes4)

h.PlotAxes3 = axes(...    % Axes for plotting the selected plot
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Parent', h.dataPanel5);
axes(h.PlotAxes3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Function Calls for the Sliders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function clear_new_tshifts()
        set(h.btn9,'UserData',[]);
    end
    function clear_new_tstrains()
        set(h.btn10,'UserData',[]);
    end
    function clear_usernotes()
        set(h.btn8,'UserData',{'(Processing Steps)'});
    end

    function button_reset()
        if get(h.dataPanel2,'UserData') == 1
            set(h.btn4,'Enable','on') % Time Shift Button
            set(h.dataPanel4,'Title','TimeShifts - Amplitude')
            set(h.dataPanel5,'Title','TimeShifts - Phase')
            set(h.btn12,'Enable','on')
            if iscell(get(h.btn9,'UserData')) == 1
                set(h.btn11a,'Enable','on')  % Apply New TS Button (A)
                set(h.btn11b,'Enable','on')  % Apply New TS Button (P)
            end
        elseif get(h.dataPanel2,'UserData') == 2
            set(h.btn4,'Enable','on')
            set(h.btn12,'Enable','off')
            set(h.dataPanel4,'Title','Time Strain - Amplitude')
            set(h.dataPanel5,'Title','Time Strain - Phase')
        elseif get(h.dataPanel2,'UserData') == 3
            set(h.btn4,'Enable','on')
            set(h.btn12,'Enable','off')
            set(h.dataPanel4,'Title','Amplitude Difference - Amplitude')
            set(h.dataPanel5,'Title','Amplitude Difference - Phase')
        elseif get(h.dataPanel2,'UserData') == 4
            set(h.btn4,'Enable','on')
            set(h.btn12,'Enable','off')
            set(h.dataPanel4,'Title','Pseudo Impedance - Amplitude')
            set(h.dataPanel5,'Title','Pseudo Impedance - Phase')
        end
        set(h.btn12b,'Enable','on')
        set(h.GaussFilt,'Enable','on')
    end


    function traces_for_plot(source,callbackdata)
        current1 = round(get(source,'value'))-min(trace_index)+1;
        
        ys = find(slice{1,3}(:,current1));
        axes(h.PlotAxes1);
        hold off
        plot(slice{1,3}(:,current1),slice{1,6},'Color','blue','LineWidth',3)
        set(gca,'YDir','reverse');
        hold all
        plot(slice{2,3}(:,current1),slice{2,6},'Color','black','LineWidth',2)
        plot(slice{2,3}(:,current1),slice{2,6},'Color','white','LineWidth',1)
        
        
        xlim([-1*max(max(abs(slice{1,3}(:,current1)))) 1*max(max(abs(slice{1,3}(:,current1))))]);
        legend('Monitor','Baseline');
        ylim(slice{1,6}(ys([1,end])));
        
        % Check for filtered Lines
        if iscell(get(h.btn9,'UserData')) == 1
            filt_data = get(h.btn9,'UserData');
            deriv_flg = 0;
        elseif iscell(get(h.btn10,'UserData')) == 1
            filt_data = get(h.btn10,'UserData');
            deriv_flg = 1;
        else
            deriv_flg = 0;
        end
        
        axes(h.PlotAxes2);
        hold off
        if exist('filt_data') == 1
            plot(filt_data{1}(:,current1),slice{1,6},'Color','blue','LineWidth',3)
            hold all
            plot(filt_data{2}(:,current1),slice{1,6},'Color','black','LineWidth',2)
            plot(filt_data{2}(:,current1),slice{1,6},'Color','white','LineWidth',1)
            if deriv_flg == 0
                plot(slice{3,3}(:,current1),slice{3,6},':','Color','blue')
                plot(slice{4,3}(:,current1),slice{4,6},':','Color','black')
            end
            xlim([-1*max(max(abs(filt_data{1}(:,current1)))) 1*max(max(abs(filt_data{1}(:,current1))))]);
        else
            plot(slice{3,3}(:,current1),slice{3,6},'Color','blue','LineWidth',3)
            hold all
            plot(slice{4,3}(:,current1),slice{4,6},'Color','black','LineWidth',2)
            plot(slice{4,3}(:,current1),slice{4,6},'Color','white','LineWidth',1)
            xlim([-1*max(max(abs(slice{3,3}(:,current1)))) 1*max(max(abs(slice{3,3}(:,current1))))]);
        end
        set(gca,'YDir','reverse')
        legend('Traditional Warping','IPhase');
        ylim(slice{1,6}(ys([1,end])));
        
        linkaxes([h.PlotAxes1 h.PlotAxes2],'y');
        
        axes(h.PlotAxes3);
        
        plot_objs = get(h.PlotAxes3,'Children');
        for i = 1:length(plot_objs)
            if length(get(plot_objs(i),'Type')) == 4
                if get(plot_objs(i),'Type') == 'line'
                    delete(plot_objs(i));
                end
            end
        end
        
        plot([slice{1,1}(current1) slice{1,1}(current1)],slice{1,6}(ys([1,end])),'Color','black','LineWidth',2)
        axes(h.PlotAxes4);
        
        
        plot_objs = get(h.PlotAxes4,'Children');
        for i = 1:length(plot_objs)
            if length(get(plot_objs(i),'Type')) == 4
                if get(plot_objs(i),'Type') == 'line'
                    delete(plot_objs(i));
                end
            end
        end
        
        plot([slice{1,1}(current1) slice{1,1}(current1)],slice{1,6}(ys([1,end])),'Color','black','LineWidth',2)
        axes(h.PlotAxes5);
        
        plot_objs = get(h.PlotAxes5,'Children');
        for i = 1:length(plot_objs)
            if length(get(plot_objs(i),'Type')) == 4
                if get(plot_objs(i),'Type') == 'line'
                    delete(plot_objs(i));
                end
            end
        end
        
        plot([slice{1,1}(current1) slice{1,1}(current1)],slice{1,6}(ys([1,end])),'Color','black','LineWidth',2)
        
        current1 = round(get(source,'value'));
        set(h.txt4,'String',num2str(current1));
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function lines_for_plot(source,callbackdata)
        if min(types) == 6
            set(h.dataPanel2,'UserData',1);
        elseif min(types) == 10
            set(h.dataPanel2,'UserData',2);
        elseif min(types) == 14
            set(h.dataPanel2,'UserData',3);
        end
        
        button_reset
        clear_new_tshifts
        clear_new_tstrains
        
        linenum = round(get(source,'value'));
        slice = Segy_Compare_Simplified(varargin{1},varargin{2},[varargin{3}(1:2) linenum],varargin{4},varargin{5},varargin{types(1)},varargin{types(2)},varargin{types(3)},varargin{types(4)});
        current1 = round(get(h.sld,'value'))-min(trace_index)+1;
        
        axes(h.PlotAxes3);
        hold off
        imagesc(slice{1,1},slice{1,6},slice{1,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{1,3}))) max(max(slice{1,3}))]);
        cmap = b2r(-crange,crange);
        hold all
        colormap(cmap)
        h.cbar3 = colorbar();
        
        axes(h.PlotAxes4);
        hold off
        imagesc(slice{3,1},slice{3,6},slice{3,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar4 = colorbar();
        
        axes(h.PlotAxes5);
        hold off
        imagesc(slice{4,1},slice{4,6},slice{4,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar5 = colorbar();
        
        set(h.txt4b,'String',num2str(linenum));
        linkaxes([h.PlotAxes3 h.PlotAxes4 h.PlotAxes5],'xy');
        
        
        ys = find(slice{1,3}(:,current1)~= 0);
        axes(h.PlotAxes2);
        hold off
        plot(slice{3,3}(:,current1),slice{3,6},'Color','blue','LineWidth',3)
        hold all
        plot(slice{4,3}(:,current1),slice{4,6},'Color','black','LineWidth',2)
        plot(slice{4,3}(:,current1),slice{4,6},'Color','white','LineWidth',1)
        set(gca,'YDir','reverse')
        legend('Traditional Warping','IPhase');
        ylim(slice{1,6}(ys([1,end])));
        xlim([-1*max(max(abs(slice{3,3}(:,current1)))) 1*max(max(abs(slice{3,3}(:,current1))))]);
        
        linkaxes([h.PlotAxes1 h.PlotAxes2],'y');
        
        axes(h.PlotAxes3);
        
        plot_objs = get(h.PlotAxes3,'Children');
        for i = 1:length(plot_objs)
            if length(get(plot_objs(i),'Type')) == 4
                if get(plot_objs(i),'Type') == 'line'
                    delete(plot_objs(i));
                end
            end
        end
        
        plot([slice{1,1}(current1) slice{1,1}(current1)],slice{1,6}(ys([1,end])),'Color','black','LineWidth',2)
        axes(h.PlotAxes4);
        
        
        plot_objs = get(h.PlotAxes4,'Children');
        for i = 1:length(plot_objs)
            if length(get(plot_objs(i),'Type')) == 4
                if get(plot_objs(i),'Type') == 'line'
                    delete(plot_objs(i));
                end
            end
        end
        
        plot([slice{1,1}(current1) slice{1,1}(current1)],slice{1,6}(ys([1,end])),'Color','black','LineWidth',2)
        axes(h.PlotAxes5);
        
        plot_objs = get(h.PlotAxes5,'Children');
        for i = 1:length(plot_objs)
            if length(get(plot_objs(i),'Type')) == 4
                if get(plot_objs(i),'Type') == 'line'
                    delete(plot_objs(i));
                end
            end
        end
        
        plot([slice{1,1}(current1) slice{1,1}(current1)],slice{1,6}(ys([1,end])),'Color','black','LineWidth',2)
        
        current1 = round(get(source,'value'));
        set(h.txt4,'String',num2str(current1));
        
        
    end

%%%%%%%%%%%%%%%%%%%% Functions to apply the time shift %%%%%%%%%%%%%%%
    function ts_recover(source,callbackdata)
        current1 = round(get(h.sld,'Value'));
        ctemp = current1-min(trace_index)+1;
        
        axes(h.PlotAxes1);
        ys = get(gca,'YLim');
        xs = get(gca,'XLim');
        hold off
        plot(slice{1,3}(:,ctemp),slice{1,6},'Color','blue','LineWidth',3)
        set(gca,'YDir','reverse');
        hold all
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','black','LineWidth',2)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','white','LineWidth',1)
        xlim(xs);
        legend('Monitor','Baseline');
        ylim(ys);
    end

    function ts_amp(source,callbackdata)
        current1 = round(get(h.sld,'Value'));
        ctemp = current1-min(trace_index)+1;
        newamp = Apply_tshift(slice{1,6}(:),slice{1,3}(:,ctemp),slice{3,3}(:,ctemp));
        
        axes(h.PlotAxes1);
        ys = get(gca,'YLim');
        xs = get(gca,'XLim');
        hold off
        plot(newamp,slice{1,6},'Color','blue','LineWidth',3)
        set(gca,'YDir','reverse');
        hold all
        plot(slice{1,3}(:,ctemp),slice{1,6},':','Color',[0.5 0.5 0.5],'LineWidth',1)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','black','LineWidth',2)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','white','LineWidth',1)
        xlim(xs);
        legend('Monitor','Baseline');
        ylim(ys)
        
        
    end

    function ts_phase(source,callbackdata)
        current1 = round(get(h.sld,'Value'));
        ctemp = current1-min(trace_index)+1;
        newamp = Apply_tshift(slice{1,6}(:),slice{1,3}(:,ctemp),slice{4,3}(:,ctemp));
        
        axes(h.PlotAxes1);
        ys = get(gca,'YLim');
        xs = get(gca,'XLim');
        hold off
        plot(newamp,slice{1,6},'Color','blue','LineWidth',3)
        set(gca,'YDir','reverse');
        hold all
        plot(slice{1,3}(:,ctemp),slice{1,6},':','Color',[0.5 0.5 0.5],'LineWidth',1)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','black','LineWidth',2)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','white','LineWidth',1)
        xlim(xs);
        legend('Monitor','Baseline');
        ylim(ys)
        
    end

%%%%%%%%%%%%%%%%%%%% Functions to switch panel content %%%%%%%%%%%%%%%
    function tshift_switch(source,callbackdata)
        set(h.dataPanel2,'UserData',1)
        button_reset
        clear_new_tshifts
        clear_new_tstrains
        clear_usernotes
        
        linenum = round(get(h.sldb,'Value'));
        slice = Segy_Compare_Simplified(varargin{1},varargin{2},[varargin{3}(1:2) linenum],varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9});
        
        axes(h.PlotAxes4);
        hold off
        imagesc(slice{3,1},slice{3,6},slice{3,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar4 = colorbar();
        
        axes(h.PlotAxes5);
        hold off
        imagesc(slice{4,1},slice{4,6},slice{4,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar5 = colorbar();
        
        types = [6 7 8 9];
        
    end


    function strain_switch(source,callbackdata)
        set(h.dataPanel2,'UserData',2)
        button_reset
        clear_new_tshifts
        clear_new_tstrains
        clear_usernotes
        
        linenum = round(get(h.sldb,'Value'));
        slice = Segy_Compare_Simplified(varargin{1},varargin{2},[varargin{3}(1:2) linenum],varargin{4},varargin{5},varargin{14},varargin{15},varargin{16},varargin{17});
        
        
        axes(h.PlotAxes4);
        hold off
        imagesc(slice{3,1},slice{3,6},slice{3,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar4 = colorbar();
        
        axes(h.PlotAxes5);
        hold off
        imagesc(slice{4,1},slice{4,6},slice{4,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar5 = colorbar();
        
        types = [14 15 16 17];
    end


    function Ampdiff_Switch(source,callbackdata)
        set(h.dataPanel2,'UserData',3)
        button_reset
        clear_new_tshifts
        clear_new_tstrains
        clear_usernotes
        
        linenum = round(get(h.sldb,'Value'));
        slice = Segy_Compare_Simplified(varargin{1},varargin{2},[varargin{3}(1:2) linenum],varargin{4},varargin{5},varargin{10},varargin{11},varargin{12},varargin{13});
        
        axes(h.PlotAxes4);
        hold off
        imagesc(slice{3,1},slice{3,6},slice{3,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar4 = colorbar();
        
        axes(h.PlotAxes5);
        hold off
        imagesc(slice{4,1},slice{4,6},slice{4,3})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(slice{3,3}))) max(max(slice{3,3}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar5 = colorbar();
        
        types = [10 11 12 13];
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function trace_write(source,callbackdata)
        current1 = round(get(h.sld,'Value'));
        current1 = current1-min(trace_index)+1;
        files = dir('traceout*.mat');
        filename_ind = length(files)+1;
        savestring = ['save traceout_',num2str(filename_ind),'.mat base mon time tshift_amp tshift_phase'];
        temp = length(varargin);
        time = slice{1,6}/1000;
            slice = Segy_Compare_Simplified(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9});

        base = slice{1,3}(:,current1);
        mon = slice{2,3}(:,current1);
        tshift_amp = slice{3,3}(:,current1);
        tshift_phase = slice{4,3}(:,current1);
        if temp > 10
            ampdiff_amp = slice{5,3}(:,current1);
            ampdiff_phase = slice{6,3}(:,current1);
            savestring = [savestring,' ampdiff_amp ampdiff_phase'];
        end
        if temp > 14
            tstrain_amp = slice{7,3}(:,current1);
            tstrain_phase = slice{8,3}(:,current1);
            savestring = [savestring,' tstrain_amp tstrain_phase'];
        end
        if iscell(get(h.btn9,'UserData')) == 1
                user_tshift_amp = get(h.btn9,'UserData');
                user_tshift_phase = user_tshift_amp{2}(:,current1);
                user_tshift_amp = user_tshift_amp{1}(:,current1);
                user_process = get(h.btn8,'UserData');
                savestring = [savestring,' user_tshift_amp user_tshift_phase user_process'];
        end
        if iscell(get(h.btn10,'UserData')) == 1
            if get(h.dataPanel2,'UserData') ~= 4
                user_tstrain_amp = get(h.btn10,'UserData');
                user_tstrain_phase = user_tstrain_amp{2}(:,current1);
                user_tstrain_amp = user_tstrain_amp{1}(:,current1);
                user_process = get(h.btn8,'UserData');
                savestring = [savestring,' user_tstrain_amp user_tstrain_phase user_process'];
            end
        end
        
        
        eval(savestring)
        disp(['Data Written to traceout_',num2str(filename_ind),'.mat'])
    end

    function line_write(source,callbackdata)
        files = dir('lineout*.mat');
        filename_ind = length(files)+1;
        
        disp('Writing Line Data')
        temp = length(varargin);
        time = slice{1,6}/1000;
        savestring = ['save lineout_',num2str(filename_ind),'.mat base mon time tshift_amp tshift_phase'];
        linenum = round(get(h.sldb,'value'));
        varargin{3} = [varargin{3}(1:2) linenum];
            slice = Segy_Compare_Simplified(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9});

        base = slice{1,3};
        mon = slice{2,3};
        tshift_amp = slice{3,3};
        tshift_phase = slice{4,3};
        if temp > 10
            ampdiff_amp = slice{5,3};
            ampdiff_phase = slice{6,3};
            savestring = [savestring,' ampdiff_amp ampdiff_phase'];
        end
        if temp > 14
            tstrain_amp = slice{7,3};
            tstrain_phase = slice{8,3};
            savestring = [savestring,' tstrain_amp tstrain_phase'];
        end
        if iscell(get(h.btn9,'UserData')) == 1
                user_tshift_amp = get(h.btn9,'UserData');
                user_tshift_phase = user_tshift_amp{2};
                user_tshift_amp = user_tshift_amp{1};
                user_process = get(h.btn8,'UserData');
                savestring = [savestring,' user_tshift_amp user_tshift_phase user_process'];
        end
        if iscell(get(h.btn10,'UserData')) == 1
            if get(h.dataPanel2,'UserData') ~= 4
                user_tstrain_amp = get(h.btn10,'UserData');
                user_tstrain_phase = user_tstrain_amp{2};
                user_tstrain_amp = user_tstrain_amp{1};
                user_process = get(h.btn8,'UserData');
                savestring = [savestring,' user_tstrain_amp user_tstrain_phase user_process'];
            end
        end
        
        
        eval(savestring)
        disp(['Data Written to lineout_',num2str(filename_ind),'.mat'])
    end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function apply_bandstop(source,callbackdata)
        minf = eval(get(h.filtmin,'String'));
        maxf = eval(get(h.filtmax,'String'));
        
        if minf > maxf
            disp('Error: Select a minF lower than maxF')
        else
            current1 = round(get(h.sld,'value'))-min(trace_index)+1;
            
            ys = find(slice{1,3}(:,current1)~= 0);
            
            if iscell(get(h.btn9,'UserData')) == 1
                data_to_filt = get(h.btn9,'UserData');
            elseif iscell(get(h.btn10,'UserData')) == 1
                data_to_filt = get(h.btn10,'UserData');
            else
                data_to_filt = {slice{3,3},slice{4,3}};
            end
            
            filt_data{1} = bandstop_ndh(data_to_filt{1},slice{3,6}/1000,minf,maxf,0,1);
            filt_data{2} = bandstop_ndh(data_to_filt{2},slice{3,6}/1000,minf,maxf,0,1);
            
            axes(h.PlotAxes2);
            hold off
            plot(filt_data{1}(:,current1),slice{1,6},'Color','blue','LineWidth',3)
            hold all
            plot(filt_data{2}(:,current1),slice{1,6},'Color','black','LineWidth',2)
            plot(filt_data{2}(:,current1),slice{1,6},'Color','white','LineWidth',1)
            plot(slice{3,3}(:,current1),slice{3,6},':','Color','blue')
            plot(slice{4,3}(:,current1),slice{4,6},':','Color','black')
            set(gca,'YDir','reverse')
            legend('Traditional Warping','IPhase');
            ylim(slice{1,6}(ys([1,end])));
            xlim([-1*max(max(abs(slice{3,3}(:,current1)))) 1*max(max(abs(slice{3,3}(:,current1))))]);
            
            
            axes(h.PlotAxes4);
            hold off
            imagesc(slice{3,1},slice{3,6},filt_data{1})
            ylabel('Two-way Travel Time (ms)')
            xlabel('Crossline Index (#)')
            crange = max([abs(min(min(filt_data{1}))) max(max(filt_data{1}))]);
            cmap = b2r(-crange,crange);
            colormap(cmap)
            hold all
            h.cbar4 = colorbar();
            
            axes(h.PlotAxes5);
            hold off
            imagesc(slice{4,1},slice{4,6},filt_data{2})
            ylabel('Two-way Travel Time (ms)')
            xlabel('Crossline Index (#)')
            cmap = b2r(-crange,crange);
            colormap(cmap)
            hold all
            h.cbar5 = colorbar();
            
            set(h.btn9,'UserData',filt_data);
        end
        note_string = get(h.btn8,'UserData');
        note_string{end+1,:} = ['Bandstop filtered from ',num2str(minf),' to ',num2str(maxf),'hz'];
        set(h.btn8,'UserData',note_string);
        button_reset
    end
    function apply_bandpass(source,callbackdata)
        minf = eval(get(h.filtmin,'String'));
        maxf = eval(get(h.filtmax,'String'));
        
        if minf > maxf
            disp('Error: Select a minF lower than maxF')
        else
            current1 = round(get(h.sld,'value'))-min(trace_index)+1;
            
            if iscell(get(h.btn9,'UserData')) == 1
                data_to_filt = get(h.btn9,'UserData');
            elseif iscell(get(h.btn10,'UserData')) == 1
                data_to_filt = get(h.btn10,'UserData');
            else
                data_to_filt = {slice{3,3},slice{4,3}};
            end
            
            ys = find(slice{1,3}(:,current1)~= 0);
            filt_data{1} = bandpass_ndh(data_to_filt{1},slice{3,6}/1000,minf,maxf,0,1);
            filt_data{2} = bandpass_ndh(data_to_filt{2},slice{3,6}/1000,minf,maxf,0,1);
            
            axes(h.PlotAxes2);
            hold off
            plot(filt_data{1}(:,current1),slice{1,6},'Color','blue','LineWidth',3)
            hold all
            plot(filt_data{2}(:,current1),slice{1,6},'Color','black','LineWidth',2)
            plot(filt_data{2}(:,current1),slice{1,6},'Color','white','LineWidth',1)
            plot(slice{3,3}(:,current1),slice{3,6},':','Color','blue')
            plot(slice{4,3}(:,current1),slice{4,6},':','Color','black')
            set(gca,'YDir','reverse')
            legend('Traditional Warping','IPhase');
            ylim(slice{1,6}(ys([1,end])));
            xlim([-1*max(max(abs(slice{3,3}(:,current1)))) 1*max(max(abs(slice{3,3}(:,current1))))]);
            
            
            axes(h.PlotAxes4);
            hold off
            imagesc(slice{3,1},slice{3,6},filt_data{1})
            ylabel('Two-way Travel Time (ms)')
            xlabel('Crossline Index (#)')
            crange = max([abs(min(min(filt_data{1}))) max(max(filt_data{1}))]);
            cmap = b2r(-crange,crange);
            colormap(cmap)
            hold all
            h.cbar4 = colorbar();
            
            axes(h.PlotAxes5);
            hold off
            imagesc(slice{4,1},slice{4,6},filt_data{2})
            ylabel('Two-way Travel Time (ms)')
            xlabel('Crossline Index (#)')
            cmap = b2r(-crange,crange);
            colormap(cmap)
            hold all
            h.cbar5 = colorbar();
            
            set(h.btn9,'UserData',filt_data);
            if iscell(get(h.btn9,'UserData')) == 1
                set(h.btn9,'UserData',filt_data);
            elseif iscell(get(h.btn10,'UserData')) == 1
                set(h.btn10,'UserData',filt_data);
            else
                slice{3,3} = filt_data{1};
                slice{4,3} = filt_data{2};
            end
        end
        note_string = get(h.btn8,'UserData');
        note_string{end+1,:} = ['Bandpass filtered from ',num2str(minf),' to ',num2str(maxf),'hz'];
        set(h.btn8,'UserData',note_string);
        button_reset
    end

    function use_new_tshifts1(source,callbackdata)
        current1 = round(get(h.sld,'Value'));
        ctemp = current1-min(trace_index)+1;
        if iscell(get(h.btn9,'UserData')) == 1
            filt_data = get(h.btn9,'UserData');
        end
        
        newamp = Apply_tshift(slice{1,6}(:),slice{1,3}(:,ctemp),filt_data{1}(:,ctemp));
        
        axes(h.PlotAxes1);
        ys = get(gca,'YLim');
        xs = get(gca,'XLim');
        hold off
        plot(newamp,slice{1,6},'Color','blue','LineWidth',3)
        set(gca,'YDir','reverse');
        hold all
        plot(slice{1,3}(:,ctemp),slice{1,6},':','Color',[0.5 0.5 0.5],'LineWidth',1)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','black','LineWidth',2)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','white','LineWidth',1)
        xlim(xs);
        legend('Monitor','Baseline');
        ylim(ys)
    end

    function use_new_tshifts2(source,callbackdata)
        current1 = round(get(h.sld,'Value'));
        ctemp = current1-min(trace_index)+1;
        if iscell(get(h.btn9,'UserData')) == 1
            filt_data = get(h.btn9,'UserData');
        end
        
        newamp = Apply_tshift(slice{1,6}(:),slice{1,3}(:,ctemp),filt_data{2}(:,ctemp));
        
        axes(h.PlotAxes1);
        ys = get(gca,'YLim');
        xs = get(gca,'XLim');
        hold off
        plot(newamp,slice{1,6},'Color','blue','LineWidth',3)
        set(gca,'YDir','reverse');
        hold all
        plot(slice{1,3}(:,ctemp),slice{1,6},':','Color',[0.5 0.5 0.5],'LineWidth',1)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','black','LineWidth',2)
        plot(slice{2,3}(:,ctemp),slice{2,6},'Color','white','LineWidth',1)
        xlim(xs);
        legend('Monitor','Baseline');
        ylim(ys)
    end

    function derivative_filt(source,callback)
        eflag = 0;
        if iscell(get(h.btn9,'UserData')) == 0
            if get(h.dataPanel2,'UserData') == 1
                filt_data{1} = slice{3,3};
                filt_data{2} = slice{4,3};
            else
                disp('Error: Can only take derivative of time-shifts');
                eflag = 1;
            end
        else
            filt_data = get(h.btn9,'UserData');
        end
        if eflag == 0
            dt = (slice{1,6}(2)-slice{1,6}(1))/1000;
            filter = [1 0 -1]/(2*dt);
            filt_data{1} = conv2(filter,1,filt_data{1},'same');
            filt_data{2} = conv2(filter,1,filt_data{2},'same');
            clear_new_tshifts
            set(h.btn10,'UserData',filt_data);
            
            current1 = round(get(h.sld,'value'))-min(trace_index)+1;
            
            ys = find(slice{1,3}(:,current1)~= 0);
            
            
            axes(h.PlotAxes2);
            hold off
            plot(filt_data{1}(:,current1),slice{1,6},'Color','blue','LineWidth',3)
            hold all
            plot(filt_data{2}(:,current1),slice{1,6},'Color','black','LineWidth',2)
            plot(filt_data{2}(:,current1),slice{1,6},'Color','white','LineWidth',1)
            set(gca,'YDir','reverse')
            legend('Traditional Warping','IPhase');
            ylim(slice{1,6}(ys([1,end])));
            xlim([-1*max(max(abs(filt_data{1}(:,current1)))) 1*max(max(abs(filt_data{1}(:,current1))))]);
            
            
            axes(h.PlotAxes4);
            hold off
            imagesc(slice{3,1},slice{3,6},filt_data{1})
            ylabel('Two-way Travel Time (ms)')
            xlabel('Crossline Index (#)')
            crange = max([abs(min(min(filt_data{1}))) max(max(filt_data{1}))]);
            cmap = b2r(-crange,crange);
            colormap(cmap)
            hold all
            h.cbar4 = colorbar();
            
            axes(h.PlotAxes5);
            hold off
            imagesc(slice{4,1},slice{4,6},filt_data{2})
            ylabel('Two-way Travel Time (ms)')
            xlabel('Crossline Index (#)')
            cmap = b2r(-crange,crange);
            colormap(cmap)
            hold all
            h.cbar5 = colorbar();
            set(h.dataPanel2,'UserData',2)
            button_reset
        end
        eflag = 0;
        note_string = get(h.btn8,'UserData');
        note_string{end+1,:} = ['Derivative Computed'];
        set(h.btn8,'UserData',note_string);
    end


    function gaussian_filt(source,callback)
        fsamp = eval(get(h.GaussFilt,'String'));
        if mod(fsamp,2) == 0
            fsamp = fsamp+1;
        end
        
        if iscell(get(h.btn9,'UserData')) == 0 & iscell(get(h.btn10,'UserData')) == 0
            filt_data{1} = slice{3,3};
            filt_data{2} = slice{4,3};
            outflag = 1;
        elseif iscell(get(h.btn9,'UserData')) == 1
            filt_data = get(h.btn9,'UserData');
            outflag = 2;
        elseif iscell(get(h.btn10,'UserData')) == 1
            filt_data = get(h.btn10,'UserData');
            outflag = 3;
        end
        
        dt = (slice{1,6}(2)-slice{1,6}(1))/1000;
        filter = gausswin(fsamp)/sum(gausswin(fsamp));
        filt_data{1} = conv2(filter,1,filt_data{1},'same');
        filt_data{2} = conv2(filter,1,filt_data{2},'same');
        
        
        clear_new_tshifts
        clear_new_tstrains
        
        
        current1 = round(get(h.sld,'value'))-min(trace_index)+1;
        
        ys = find(slice{1,3}(:,current1)~= 0);
        
        
        axes(h.PlotAxes2);
        hold off
        plot(filt_data{1}(:,current1),slice{1,6},'Color','blue','LineWidth',3)
        hold all
        plot(filt_data{2}(:,current1),slice{1,6},'Color','black','LineWidth',2)
        plot(filt_data{2}(:,current1),slice{1,6},'Color','white','LineWidth',1)
        set(gca,'YDir','reverse')
        legend('Traditional Warping','IPhase');
        ylim(slice{1,6}(ys([1,end])));
        xlim([-1*max(max(abs(filt_data{1}(:,current1)))) 1*max(max(abs(filt_data{1}(:,current1))))]);
        
        
        axes(h.PlotAxes4);
        hold off
        imagesc(slice{3,1},slice{3,6},filt_data{1})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(filt_data{1}))) max(max(filt_data{1}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar4 = colorbar();
        
        axes(h.PlotAxes5);
        hold off
        imagesc(slice{4,1},slice{4,6},filt_data{2})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar5 = colorbar();
        
        if outflag == 1
            if get(h.dataPanel1,'UserData') == 1
                set(h.btn9,'UserData',filt_data);
            else
                slice{3,3} = filt_data{1};
                slice{4,3} = filt_data(2);
            end
            button_reset
        elseif outflag == 2
            set(h.btn9,'UserData',filt_data);
            button_reset
        elseif outflag == 3
            set(h.btn10,'UserData',filt_data);
            button_reset
        end
        note_string = get(h.btn8,'UserData');
        note_string{end+1,:} = ['Gaussian Filtered in time with a filter',num2str(fsamp),' samples wide'];
        set(h.btn8,'UserData',note_string);
    end


    function bottom_crop(source,callbackdata)
        tsamp = eval(get(h.BottomSample,'String'));
        rb = find_nearest(slice{1,6},tsamp);
        if iscell(get(h.btn9,'UserData')) == 0 & iscell(get(h.btn10,'UserData')) == 0
            filt_data{1} = slice{3,3};
            filt_data{2} = slice{4,3};
            outflag = 1;
        elseif iscell(get(h.btn9,'UserData')) == 1
            filt_data = get(h.btn9,'UserData');
            outflag = 2;
        elseif iscell(get(h.btn10,'UserData')) == 1
            filt_data = get(h.btn10,'UserData');
            outflag = 3;
        end
        
        filt_data{1}(rb:end,:) = 0;
        filt_data{2}(rb:end,:) = 0;
        
        current1 = round(get(h.sld,'value'))-min(trace_index)+1;
        
        ys = find(slice{1,3}(:,current1)~= 0);
        
        
        axes(h.PlotAxes2);
        hold off
        plot(filt_data{1}(:,current1),slice{1,6},'Color','blue','LineWidth',3)
        hold all
        plot(filt_data{2}(:,current1),slice{1,6},'Color','black','LineWidth',2)
        plot(filt_data{2}(:,current1),slice{1,6},'Color','white','LineWidth',1)
        set(gca,'YDir','reverse')
        legend('Traditional Warping','IPhase');
        ylim(slice{1,6}(ys([1,end])));
        xlim([-1*max(max(abs(filt_data{1}(:,current1)))) 1*max(max(abs(filt_data{1}(:,current1))))]);
        
        
        axes(h.PlotAxes4);
        hold off
        imagesc(slice{3,1},slice{3,6},filt_data{1})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        crange = max([abs(min(min(filt_data{1}))) max(max(filt_data{1}))]);
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar4 = colorbar();
        
        axes(h.PlotAxes5);
        hold off
        imagesc(slice{4,1},slice{4,6},filt_data{2})
        ylabel('Two-way Travel Time (ms)')
        xlabel('Crossline Index (#)')
        cmap = b2r(-crange,crange);
        colormap(cmap)
        hold all
        h.cbar5 = colorbar();
        
        if outflag == 1
            if get(h.dataPanel1,'UserData') == 1
                set(h.btn9,'UserData',filt_data);
            else
                slice{3,3} = filt_data{1};
                slice{4,3} = filt_data(2);
            end
            button_reset
        elseif outflag == 2
            set(h.btn9,'UserData',filt_data);
            button_reset
        elseif outflag == 3
            set(h.btn10,'UserData',filt_data);
            button_reset
        end
        note_string = get(h.btn8,'UserData');
        note_string{end+1,:} = ['Bottom of the Data cropped at ',num2str(tsamp),' ms'];
        set(h.btn8,'UserData',note_string);
    end
end









