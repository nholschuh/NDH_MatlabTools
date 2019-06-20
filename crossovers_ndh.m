function results = crossovers_ndh(data,plot_index)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load linefiles into the workspace using the format Line_# and supply
% vectors containing the cross line and along line values. Then this code
% compiles the crossover point values.

% Divide the data into lines and sort them into along and across grid

X = data(:,1);
Y = data(:,2);

for i = 1:length(X) - 1;
    headings(i) = heading([X(i) Y(i)],[X(i+1) Y(i+1)]);
end

counter = 1;
for i = 1:length(headings)-1
    if abs(headings(i+1) - headings(i)) > 15
        if counter == 1
            linebreak(counter) = i+1;
            line_heading(counter) = headings(i);
            counter = counter+1;            
        elseif linebreak(counter-1) ~= i;
            linebreak(counter) = i+1;
            line_heading(counter) = headings(i);
            counter = counter+1;
        end
    end
    if i == length(headings)-1;
        line_heading = [line_heading headings(i)];
    end
end

% counter = 1;
 threshold = 0;
% for i = 1:length(linebreak)+1
%     if i == 1
%         if linebreak(i) > threshold
%             varname = ['line_',int2str(counter),' = zeros(linebreak(i),length(data(1,:))+1);'];
%             eval(varname);
%             counter = counter + 1;
%         end
%     elseif i == length(linebreak)+1
%         if length(data(:,1)) - linebreak(i-1) > threshold
%             varname = ['line_',int2str(counter),' = zeros(length(data(:,1)) - linebreak(i-1),length(data(1,:))+1);'];
%             eval(varname);
%             counter = counter + 1;
%         end
%     else
%         if linebreak(i)-linebreak(i-1) > threshold
%             varname = ['line_',int2str(counter),' = zeros(linebreak(i)-linebreak(i-1),length(data(1,:))+1);'];
%             eval(varname);
%             counter = counter + 1;
%         end
%     end 
% end

counter = 1;
counter2 = 1;
counter3 = 1;
linenum = [];
for i = 1:length(headings)
    varname = ['line_',int2str(counter)];
    eval_string = [varname,'(counter2,:) = [data(i,:) i];'];
    eval(eval_string)
    linenum(i) = counter;
    counter2 = counter2 + 1;
    if counter3 <= length(linebreak)
        if i == linebreak(counter3)
            if counter2 < threshold

                counter2 = 1;
                counter3 = counter3 + 1;
            else
                line_heading_2(counter) = line_heading(counter);
                counter3 = counter3 + 1;
                counter = counter+1;
                counter2 = 1;
            end
        end
    end
    if i == length(headings)
        line_heading_2 = [line_heading_2 line_heading(end)];
    end
end


if exist('plot_index') == 1
    figure(1)
    for i = 1:length(line_heading_2)
        if mod(i,2) == 0
            varname = ['plot(line_',int2str(i),'(:,1),line_',int2str(i),'(:,2),''.'',''Color'',''black'')'];
            eval(varname);
            hold all
        else
            varname = ['plot(line_',int2str(i),'(:,1),line_',int2str(i),'(:,2),''.'',''Color'',''blue'')'];
            eval(varname);
            hold all
        end
    end
end
    pause(10)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find Across Lines and Along Lines

lines = 1:length(line_heading_2);

% This finds the index for crossover of one set of lines
crossover_start = [];
for i = 1:length(lines)
    for j = [removerows([1:length(lines)]','ind',i)]'
        eval_string1 = ['line_a = line_',num2str(lines(i)),';'];
        eval_string2 = ['line_b = line_',num2str(lines(j)),';'];
        eval(eval_string1);
        eval(eval_string2);
        ls = line_b(1,:);
        le = line_b(end,:);
        
        ci = 0;
        for k = 1:length(line_a(:,1))-1;
            if segment_intersect([line_a(1,1:2); line_a(k+1,1:2)],[ls(1:2); le(1:2)]) == 1
                ci = k+1;
                break
            end
        end
        if ci > 0
            ci2 = find_nearest_xy(line_b,line_a(ci,1:2));
            crossover_start = [crossover_start; line_a(ci,:) line_b(ci2,:)];
        end
    end
end

if exist('plot_index') == 1
    plot(crossover_start(:,1),crossover_start(:,2),'o','MarkerFaceColor','red')
end


results = crossover_start;
end
   