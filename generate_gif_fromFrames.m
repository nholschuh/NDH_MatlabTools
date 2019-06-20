function bounds = generate_gif_fromFrames(filename,dirname,framerate,set_bounds,watermark)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This generates a .avi from .jpg frames. Typically, this generates a
% larger file than the unix script (found at _______________________)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


    if exist('framerate') == 0
        dt = 0.03;
    end
    
    if framerate == 0;
        dt = 0.03;
    end
    
    if framerate > 0;
        dt = round_to(1/framerate,0.01);
    end
    
    if exist('flipimage') == 0
        flipimage = 0;
    end
    
    if dt < 0.03
        dt = 0.03;
    end
    
    if exist('set_bounds') == 0
        set_bounds = 0;
    end
    
    if exist('watermark') == 0
        watermark = 1;
    end

    frame_info = dir([dirname,'/*.png']);
    
    for i = 1:length(frame_info);
      im = imread([dirname,'/',frame_info(i).name]);
      
      if iscell(set_bounds) == 0
          if set_bounds == 1
              fh = figure(5);
              imagesc(im);
                corners = graphical_selection(1); 
                row_range = [round(min(corners(:,2))):round(max(corners(:,2)))];
                col_range = [round(min(corners(:,1))):round(max(corners(:,1)))];
                bounds{1} = row_range;
                bounds{2} = col_range;
                close(fh)
          else
                row_range = [1:length(frame.cdata(:,1,1))];
                col_range = [1:length(frame.cdata(1,:,1))];              
                bounds{1} = row_range;
                bounds{2} = col_range;
          end
          set_bounds = bounds;
      else
          row_range = set_bounds{1};
          col_range = set_bounds{2};
          bounds = set_bounds;
      end
      
      final_im = im(row_range,col_range,:);
      
      %%%%%%%%%%%%%%% Here is where the watermark is generated
      if i == 1 & watermark == 1
          figure();
          set(gcf,'Position',[0 0 length(col_range)*1.5 length(row_range)*1.5]);
          set(gca,'Position',[1/6 1/6 2/3 2/3])
          set(gca,'Color','black')
          text(0.95,0.05,'(C) Holschuh 2017','Color','white','HorizontalAlignment','right','VerticalAlignment','bottom');
          frame = getframe(gca);
          name_pos1 = frame.cdata(:,:,1);
          name_pos2 = frame.cdata(:,:,2);
          name_pos3 = frame.cdata(:,:,3);
          edge_erase1 = round(col_range/25);
          edge_erase2 = round(row_range/25);
          name_pos1(:,1:edge_erase1) = 0;
          name_pos1(:,end-edge_erase1:end) = 0;
          name_pos1(1:edge_erase1,:) = 0;
          name_pos1(end-edge_erase1:end,:) = 0;
          inds = find(name_pos1 > 0);
          close all
      end     
      
      if watermark == 1
          temp1 = final_im(:,:,1);
          temp2 = final_im(:,:,2);
          temp3 = final_im(:,:,3);
          temp1(inds) = name_pos1(inds);
          temp2(inds) = name_pos2(inds);
          temp3(inds) = name_pos3(inds);
          final_im(:,:,1) = temp1;
          final_im(:,:,2) = temp2;
          final_im(:,:,3) = temp3;
      end
      
      [imind,cm] = rgb2ind(final_im,256);

      if i == 1;
          imwrite(imind,cm,[filename,'.gif'],'gif','DelayTime',dt,'Loopcount',inf);
      else
          imwrite(imind,cm,[filename,'.gif'],'gif','WriteMode','append','DelayTime',dt);
      end
    end
end
