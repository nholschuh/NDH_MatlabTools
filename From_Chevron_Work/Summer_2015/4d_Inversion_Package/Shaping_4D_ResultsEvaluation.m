function Shaping_4D_ResultsEvaluation(dvv,ampdiff_volume,volume3);


inlines_ind =ampdiff_volume{6};
crosslines_ind = ampdiff_volume{7};
time = ampdiff_volume{8};

lp = 140;



h.fig = figure('Position', [100, 100, 1500, 600]);
set(h.fig,'toolbar','figure');


h.btn1a = uicontrol('Style', 'pushbutton', 'String','DVV','Enable','off',...
    'Position', [lp+425 20 100 20],...
    'Callback', @dvv_plot);
h.btn1b = uicontrol('Style', 'pushbutton', 'String','AD','Enable','on',...
    'Position', [lp+425 40 100 20],...
    'Callback', @ad_plot);

h.btn2 = uicontrol('Style', 'radio',...
    'Position', [lp+850 20 20 20]);
h.btn2_label = uicontrol('Style', 'text', 'String', 'Use Crossline',...
    'Position', [lp+870 20 80 20]);

h.inline_label= uicontrol('Style', 'text', 'String', 'Inline',...
    'Position', [lp+200 40 150 20]);
h.inline_min= uicontrol('Style', 'text', 'String', num2str(min(inlines_ind)),...
    'Position', [lp+150 20 50 20]);
h.inline_max= uicontrol('Style', 'text', 'String', num2str(max(inlines_ind)),...
    'Position', [lp+350 20 50 20]);
h.inline_number= uicontrol('Style', 'edit', 'String',num2str(min(inlines_ind)+37),'Enable','on','BackgroundColor','white',...
    'Position', [lp+200 20 150 20]);
h.crossline_label= uicontrol('Style', 'text', 'String', 'Crossline',...
    'Position', [lp+600 40 150 20]);
h.crossline_min= uicontrol('Style', 'text', 'String', num2str(min(crosslines_ind)),...
    'Position', [lp+550 20 50 20]);
h.crossline_max= uicontrol('Style', 'text', 'String', num2str(max(crosslines_ind)),...
    'Position', [lp+750 20 50 20]);
h.crossline_number= uicontrol('Style', 'edit', 'String','(number)','Enable','on','BackgroundColor','white',...
    'Position', [lp+600 20 150 20]);

h.btn_cchange= uicontrol('Style', 'pushbutton', 'String','Change C Axis','Enable','on',...
    'Position', [lp-50 60 100 20],...
    'Callback', @cchange);

h.cmin= uicontrol('Style', 'edit', 'String','(number)','Enable','on','BackgroundColor','white',...
    'Position', [lp-50 20 100 20]);
h.cmax= uicontrol('Style', 'edit', 'String','(number)','Enable','on','BackgroundColor','white',...
    'Position', [lp-50 40 100 20]);
h.cmin_label= uicontrol('Style', 'text', 'String', 'Cmin',...
    'Position', [lp+50 20 50 20]);
h.cmax_label= uicontrol('Style', 'text', 'String', 'Cmax',...
    'Position', [lp+50 40 50 20]);

if exist('volume3') == 1
    threevol = 1;
    h.btn1c = uicontrol('Style', 'pushbutton', 'String','Extra Volume','Enable','on',...
        'Position', [lp+425 60 100 20],...
        'Callback', @v3_plot);
    
else
    threevol = 0;
end

%%%%%%%%%%%%%%%%% Filtering Tools

shifter = 150;
h.btn9 = uicontrol('Style', 'pushbutton', 'String', 'Bandstop',...
    'Position', [lp+900+shifter 500 100 20],...
    'Callback', @apply_bandstop);

h.btn10 = uicontrol('Style', 'pushbutton', 'String', 'Bandpass',...
    'Position', [lp+1000+shifter 500 100 20],...
    'Callback', @apply_bandpass);

h.filtmin = uicontrol('Style', 'edit', 'String', ' ','BackgroundColor','white',...
    'Position', [lp+940+shifter 480 60 20]);
h.filtmin_label = uicontrol('Style', 'text', 'String', 'Max F',...
    'Position', [lp+900+shifter 480 40 20]);
h.filtmax = uicontrol('Style', 'edit', 'String', ' ','BackgroundColor','white',...
    'Position', [lp+1000+shifter 480 60 20]);
h.filtmax_label = uicontrol('Style', 'text', 'String', 'Min F',...
    'Position', [lp+1060+shifter 480 40 20]);




h.dataPanel1 = uipanel(h.fig,...
    'Units','pixels',...
    'Position',[100 100 1000 450],...
    'Title','Seismic Data','UserData',1);

h.PlotAxes1 = axes(...    % Axes for plotting the selected plot
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Parent', h.dataPanel1);

set(h.dataPanel1,'UserData',0)

% dataPanel1 Contains info about if this is a new line plot or not (0/1)
% btn1 and btn2 are flags to indicate

    function dvv_plot(source,callbackdata)
        axes(h.PlotAxes1);
        
        ylims = get(h.PlotAxes1,'YLim');
        xlims = get(h.PlotAxes1,'XLim');
        
        if get(h.btn2,'Value') == 1
            if get(h.btn2,'UserData') == 2
                set(h.dataPanel1,'UserData',0)
            end
            current1 = round(eval(get(h.crossline_number,'string'))-min(crosslines_ind)+1);
            data_to_plot = squeeze(dvv(:,current1,:))';
            imagesc(inlines_ind,time,data_to_plot);
            xlabel('Inline Index (#)')
            set(h.btn2,'UserData',1)
        else
            if get(h.btn2,'UserData') == 1
                set(h.dataPanel1,'UserData',0)
            end
            current1 = round(eval(get(h.inline_number,'string'))-min(inlines_ind)+1);
            data_to_plot = squeeze(dvv(current1,:,:))';
            imagesc(crosslines_ind,time,data_to_plot)
            xlabel('Crossline Index (#)')
            set(h.btn2,'UserData',2)
        end
        
        ylabel('Two-way Travel Time (ms)')
        title('\DeltaV/V Product')
        
        if get(h.dataPanel1,'UserData') == 1
            xlim(xlims);
            ylim(ylims);
        else
            set(h.dataPanel1,'UserData',1)
        end
        
        crange = max([abs(min(data_to_plot)) max(max(data_to_plot))]);
        cmap = flipud(b2r2(-crange,crange));
        colormap(cmap)
        h.cbar1 = colorbar();
        
        set(h.btn2_label,'UserData',data_to_plot)
        
        set(h.btn1b,'Enable','on')
        set(h.btn1a,'Enable','off')
        if threevol == 1
            set(h.btn1c,'Enable','on')
        end
    end

    function ad_plot(source,callbackdata)
        axes(h.PlotAxes1);
        ylims = get(h.PlotAxes1,'YLim');
        xlims = get(h.PlotAxes1,'XLim');
        if get(h.btn2,'Value') == 1
            if get(h.btn2,'UserData') == 2
                set(h.dataPanel1,'UserData',0)
            end
            current1 = round(eval(get(h.crossline_number,'string')))-min(crosslines_ind)+1;
            data_to_plot = squeeze(ampdiff_volume{1}(:,current1,:))';
            imagesc(inlines_ind,time,data_to_plot);
            xlabel('Inline Index (#)')
            set(h.btn2,'UserData',1)
        else
            if get(h.btn2,'UserData') == 1
                set(h.dataPanel1,'UserData',0)
            end
            current1 = round(eval(get(h.inline_number,'string'))-min(inlines_ind)+1);
            data_to_plot = squeeze(ampdiff_volume{1}(current1,:,:))';
            imagesc(crosslines_ind,time,data_to_plot)
            xlabel('Crossline Index (#)')
            set(h.btn2,'UserData',2)
        end
        
        ylabel('Two-way Travel Time (ms)')
        title('Amplitude Difference Data')
        if get(h.dataPanel1,'UserData') == 1
            xlim(xlims);
            ylim(ylims);
        else
            set(h.dataPanel1,'UserData',1)
        end
        
        crange = max([abs(min(data_to_plot)) max(max(data_to_plot))]);
        cmap = flipud(b2r2(-crange,crange));
        colormap(cmap)
        h.cbar1 = colorbar();
        
        set(h.btn2_label,'UserData',data_to_plot)
        
        set(h.btn1a,'Enable','on')
        set(h.btn1b,'Enable','off')
        if threevol == 1
            set(h.btn1c,'Enable','on')
        end
        
    end

    function v3_plot(source,callbackdata)
        axes(h.PlotAxes1);
        ylims = get(h.PlotAxes1,'YLim');
        xlims = get(h.PlotAxes1,'XLim');
        if get(h.btn2,'Value') == 1
            if get(h.btn2,'UserData') == 2
                set(h.dataPanel1,'UserData',0)
            end
            current1 = round(eval(get(h.crossline_number,'string')))-min(crosslines_ind)+1;
            data_to_plot = squeeze(volume3{1}(:,current1,:))';
            imagesc(inlines_ind,time,data_to_plot);
            xlabel('Inline Index (#)')
            set(h.btn2,'UserData',1)
        else
            if get(h.btn2,'UserData') == 1
                set(h.dataPanel1,'UserData',0)
            end
            current1 = round(eval(get(h.inline_number,'string'))-min(inlines_ind)+1);
            data_to_plot = squeeze(volume3{1}(current1,:,:))';
            imagesc(crosslines_ind,time,data_to_plot)
            xlabel('Crossline Index (#)')
            set(h.btn2,'UserData',2)
        end
        
        ylabel('Two-way Travel Time (ms)')
        title('Amplitude Difference Data')
        if get(h.dataPanel1,'UserData') == 1
            xlim(xlims);
            ylim(ylims);
        else
            set(h.dataPanel1,'UserData',1)
        end
        
        crange = max([abs(min(data_to_plot)) max(max(data_to_plot))]);
        cmap = flipud(b2r2(-crange,crange));
        colormap(cmap)
        h.cbar1 = colorbar();
        
        set(h.btn2_label,'UserData',data_to_plot)
        
        set(h.btn1a,'Enable','on')
        set(h.btn1b,'Enable','on')
        
        if threevol == 1
            set(h.btn1c,'Enable','off')
        end
        
    end

    function apply_bandpass(source,callbackdata)
        minf = eval(get(h.filtmin,'String'));
        maxf = eval(get(h.filtmax,'String'));
        
        if minf > maxf
            disp('Error: Select a minF lower than maxF')
        else
            
            data_to_filt = get(h.btn2_label,'UserData');
            
            filt_data = bandpass_ndh(data_to_filt,time,minf,maxf,0,1);
            
            axes(h.PlotAxes1);
            ylims = get(h.PlotAxes1,'YLim');
            xlims = get(h.PlotAxes1,'XLim');
            if get(h.btn2,'Value') == 1
                if get(h.btn2,'UserData') == 2
                    set(h.dataPanel1,'UserData',0)
                end
                imagesc(inlines_ind,time,filt_data);
                xlabel('Inline Index (#)')
                set(h.btn2,'UserData',1)
            else
                if get(h.btn2,'UserData') == 1
                    set(h.dataPanel1,'UserData',0)
                end
                imagesc(crosslines_ind,time,filt_data)
                xlabel('Crossline Index (#)')
                set(h.btn2,'UserData',2)
            end
            
            
            ylabel('Two-way Travel Time (ms)')
            title('Amplitude Difference Data')
            if get(h.dataPanel1,'UserData') == 1
                xlim(xlims);
                ylim(ylims);
            else
                set(h.dataPanel1,'UserData',1)
            end
            
            crange = max([abs(min(filt_data)) max(max(filt_data))]);
            cmap = flipud(b2r2(-crange,crange));
            colormap(cmap)
            h.cbar1 = colorbar();
            
            
            
            set(h.btn2_label,'UserData',filt_data)
            
            axes(h.PlotAxes1);
        end
        
    end

    function apply_bandstop(source,callbackdata)
        minf = eval(get(h.filtmin,'String'));
        maxf = eval(get(h.filtmax,'String'));
        
        if minf > maxf
            disp('Error: Select a minF lower than maxF')
        else
            
            data_to_filt = get(h.btn2_label,'UserData');
            filt_data = bandstop_ndh(data_to_filt,time,minf,maxf,0,1);
            
            axes(h.PlotAxes1);
            ylims = get(h.PlotAxes1,'YLim');
            xlims = get(h.PlotAxes1,'XLim');
            if get(h.btn2,'Value') == 1
                if get(h.btn2,'UserData') == 2
                    set(h.dataPanel1,'UserData',0)
                end
                imagesc(inlines_ind,time,filt_data);
                xlabel('Inline Index (#)')
                set(h.btn2,'UserData',1)
            else
                if get(h.btn2,'UserData') == 1
                    set(h.dataPanel1,'UserData',0)
                end
                imagesc(crosslines_ind,time,filt_data)
                xlabel('Crossline Index (#)')
                set(h.btn2,'UserData',2)
            end
            
            
            ylabel('Two-way Travel Time (ms)')
            title('Amplitude Difference Data')
            if get(h.dataPanel1,'UserData') == 1
                xlim(xlims);
                ylim(ylims);
            else
                set(h.dataPanel1,'UserData',1)
            end
            
            crange = max([abs(min(filt_data)) max(max(filt_data))]);
            cmap = flipud(b2r2(-crange,crange));
            colormap(cmap)
            h.cbar1 = colorbar();
            
            
            
            set(h.btn2_label,'UserData',filt_data)
            
            axes(h.PlotAxes1);
        end
        
    end

    function cchange(source,callbackdata)
        c1 = round(eval(get(h.cmin,'string')));
        c2 = round(eval(get(h.cmax,'string')));
        caxis([c1 c2])
    end
end










