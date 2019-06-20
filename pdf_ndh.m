function pdf_ndh(filename,margin_size,all_flag,pdf0_or_png1,pdf_compressor)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Writes out the current figure (or all current figures) as pdfs with the
% prescribed filename
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - String with the desired filename. If all_flag is set to 1,
%            "_fignum" is appended for each figure
% margin_size - The size of the margin around the figures. Default value is
%               0
% all_flag - This determines if only the active figure (0) or all figures
%               (1) should be written
% pdf_compressor - If the below flag is set to 0, it is forced to be a
% vector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% The pdf-writer in matlab intelligently decides
%%%%%%%%%%%%%%%%%%%%%%%%%%% whether to print the figure as a raster or as a
%%%%%%%%%%%%%%%%%%%%%%%%%%% vector. If the below flag is set to 0, it is
%%%%%%%%%%%%%%%%%%%%%%%%%%% forced to always be a vector. If set to 1, the
%%%%%%%%%%%%%%%%%%%%%%%%%%% code decides for you.
if exist('pdf_compressor') == 0
    pdf_compressor = 1;
end

%%% Writes out the current figure as a pdf

if exist('margin_size') == 0
    margin_size = 0;
end

if exist('all_flag') == 0
    all_flag = 0;
end

if exist('new_or_append') == 0
    new_or_append = 0;
end

plot_wins = get(0,'children');
if all_flag == 0
    loops = 1;
else
    loops = length(plot_wins);
end

if exist('pdf0_or_png1') == 0
    pdf0_or_png1 = 0;
end

if pdf0_or_png1 == 0
    pflag = '-dpdf';
elseif pdf0_or_png1 == 1
    pflag = '-dpng';
end

for i = 1:loops
    
    
    if all_flag == 0
            size_info = get(gcf,'Position');
    else
        size_info = get(plot_wins(i),'Position');
    end
    
    
    scale_method = 2; %%%% This assumes a 100DPI resolution, and scales appropriately
    
    
    set(gcf,'InvertHardcopy','off');
    
    if pdf_compressor == 0
        if all_flag == 0
            set(gcf,'Renderer','Painters');
        else
            set(plot_wins(i),'Renderer','Painters');
        end
        
    end
    
    if scale_method == 1
        [max_dim max_dim_ind] = max(size_info(3:4));
        scaler = 9/max_dim;
        if max_dim_ind == 1
            PaperSize_vals = [9+margin_size*2 size_info(4)*scaler+margin_size*2];
        else
            PaperSize_vals = [size_info(3)*scaler+margin_size*2 +margin_size*2];
        end
    else
        scaler = 1/100;
        PaperSize_vals = [size_info(3)*scaler+margin_size*2 size_info(4)*scaler+margin_size*2];
    end
    
    PP = [margin_size margin_size size_info(3)*scaler size_info(4)*scaler];
    PU = 'inches';
    
    if all_flag == 0
        
        set(gcf,'PaperPositionMode','manual','PaperSize',PaperSize_vals,'PaperUnits',PU,'PaperPosition',PP);
        if exist(filename) == 2 & new_or_append == 1 & pdf0_or_png1 == 0
            print(gcf,pflag,'temp')
            append_pdfs([filename,'.pdf'],[filename,'.pdf'],'temp.pdf')
        else
            print(gcf,pflag,filename)
        end

    else
        set(plot_wins(i),'PaperPositionMode','manual','PaperSize',PaperSize_vals,'PaperUnits',PU,'PaperPosition',PP);
        print(plot_wins(i),pflag, [filename,'_',num2str(plot_wins(i).Number)])
        disp(['Written Figure ',num2str(i),' of ',num2str(loops)])
    end
    
    
end

end






