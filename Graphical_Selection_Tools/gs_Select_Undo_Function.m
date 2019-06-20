

%%%%%%%%%%%%%%%%% This is where the plotting takes place
if (temp(3) == 1 | temp(3) == 110)   % If the selection was using the mouse button
                                     % or f key or n (for nan) key
    if i > 1  %%%% Why are there two of these? It works but I'm not sure why i did this
        if exist('cline','var') == 1
            if output_storage(i-1,3) ~= 10
                delete(cline);
                clear cline;
            else
                clear cline
            end
        end
    end
    
    if temp(3) == 110
        output_storage(i,1:2) = NaN;
    end
    
    cline_entry = ['cline = plot(output_storage(start:i,1),output_storage(start:(i),2),',line_params,');'];
    eval(cline_entry);
    
    if additional_input_prompt > 0
        xv1 = inputdlg('X Value');
        yv1 = inputdlg('Y Value');
        associated_vals(i,:) = [eval(xv1{1}) eval(yv1{1})];
    end
end

%%%%%%%%%%%%%%% This is the undo function when the locking flag is off
if temp(3) == 117 | (temp(3) == 85 & locking_flag == 0)   %Build an undo function for the u key
    if i > 1
        delete(cline);
        clear cline;
        i = i-2;
        output_storage = output_storage(1:i,:);
        
        cline_entry = ['cline = plot(output_storage(start:(i),1),output_storage(start:(i),2),',line_params,');'];
        eval(cline_entry);
        
        %%%%%%%%%%%% Added to deal with users who hit u then U
        if locking_flag == 1
            num_keeps = num_keeps-1;
            output_inds = output_inds(1:i);
        end
        
    end
end

%%%%%%%%%%%%%%% This is the undo function when the locking flag is on
if temp(3) == 85 & locking_flag == 1   %Build an undo function for the U key
    if i > 1
        delete(cline);
        clear cline;
        
        i = i-num_keeps-1;
        num_keeps = 1;
        output_storage = output_storage(1:i,:);
        output_inds = output_inds(1:i);
        cline_entry = ['cline = plot(output_storage(start:(i),1),output_storage(start:(i),2),',line_params,');'];
        eval(cline_entry);
        
    end
end
