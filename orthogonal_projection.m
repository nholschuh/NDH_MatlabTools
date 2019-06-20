function [output orthogonal_component] = orthogonal_projection(points_in,line_in,absolute_or_relative);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function projects a point to its nearest position on a line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% points_in - 1x2 vector containing the point of interest
% line_in - 2x2 matrix with each row containing a point that defines the
%               line
% absolute_or_relative - This flag has you compute the true projection to
%               the line [0] or simply the projection onto a line of the
%               same vector direction [1]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - The component of the input point that falls on the line
% orthogonal_component - The component of the input point that is
%           orthogonal to the line
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('absolute_or_relative') == 0
    if length(points_in(1,:)) == 4
        absolute_or_relative = 1;
    else
        absolute_or_relative = 0;
    end
end

if absolute_or_relative == 0
    v1 = line_in(2,:) - line_in(1,:);
    v2 = points_in - line_in(1,:);
else
    v1 = line_in(2,:) - line_in(1,:);
    v2 = [points_in(:,3)-points_in(:,1) points_in(:,4)-points_in(:,2)];
end

    np = sum([v2.*(ones(length(points_in(:,1)),1)*v1)],2)/dot(v1,v1)*(v1);

if absolute_or_relative == 0
    output = np+line_in(1,:);
    orthogonal_component = points_in-output;
else
    output = np;
    orthogonal_component = points_in(:,3:4)-points_in(:,1:2)-output;
end



debugger = 0;
if debugger == 1
    
    figure()
    plot(line_in(:,1),line_in(:,2),'-','Color',[0.5 0.5 0.5]);
    hold all
    
    if absolute_or_relative == 0
        for i = 1:length(points_in(:,1))
            plot([points_in(i,1) line_in(1,1)],[points_in(i,2) line_in(1,2)],'o-','Color','black')
        end
        plot(points_in(:,1),points_in(:,2),'o','Color','black')
        plot([repmat(line_in(1,1),1,length(output(:,1))); output(:,1)'],[repmat(line_in(1,2),1,length(output(:,1))); output(:,2)'],'-','Color','blue')
        plot([output(:,1)'; orthogonal_component(:,1)'+output(:,1)'],[output(:,2)'; orthogonal_component(:,2)'+output(:,2)'],'-','Color','red')
    else
        for i = 1:length(points_in(:,1))
            plot([points_in(i,1) points_in(i,3)],[points_in(i,2) points_in(i,4)],'o-','Color','black')
        end
        plot([points_in(:,1)'; points_in(:,1)'+output(:,1)'],[points_in(:,2)'; points_in(:,2)'+output(:,2)'],'-','Color','blue')
        plot([points_in(:,1)'+output(:,1)'; orthogonal_component(:,1)'+output(:,1)'+points_in(:,1)'], ...
            [points_in(:,2)'+output(:,2)'; orthogonal_component(:,2)'+output(:,2)'+points_in(:,2)'],'-','Color','red')
        
    end
end
    

end

