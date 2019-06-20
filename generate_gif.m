function bounds = generate_gif(filename,indexnum,framerate,set_bounds,flipimage)
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

    if indexnum == 1
        if exist([filename,'.gif']) == 2
            delete([filename,'.gif']);
        end
    end

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

      frame = getframe(gcf);
      if flipimage == 1
          frame.cdata = flipud(permute(frame.cdata,[2 1 3]));
      end
      
      
      im = frame2im(frame);   
      
      if iscell(set_bounds) == 0
          if set_bounds == 1
              fh = figure(5);
              imagesc(im);
                corners = graphical_selection(1); 
                row_range = [max([1 round(min(corners(:,2)))]):min([round(max(corners(:,2))) length(im(:,1,1))])];
                col_range = [max([1 round(min(corners(:,1)))]):min([round(max(corners(:,1))) length(im(1,:,1))])];
                bounds{1} = row_range;
                bounds{2} = col_range;
                close(fh)
          else
                row_range = [1:length(frame.cdata(:,1,1))];
                col_range = [1:length(frame.cdata(1,:,1))];              
                bounds{1} = row_range;
                bounds{2} = col_range;
          end
      else
          row_range = set_bounds{1};
          col_range = set_bounds{2};
          bounds = set_bounds;
      end
      
      [imind,cm] = rgb2ind(im(row_range,col_range,:),256);
      if indexnum == 1;
          imwrite(imind,cm,[filename,'.gif'],'gif','DelayTime',dt,'Loopcount',inf);
      else
          imwrite(imind,cm,[filename,'.gif'],'gif','WriteMode','append','DelayTime',dt);
      end
end
