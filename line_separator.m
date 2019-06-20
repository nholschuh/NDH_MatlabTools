function line_object = line_separator(data,xcol,ycol,dist_threshold,plotter)
% Takes a data matrix containing x and y locations, and separates it into
% separate objects according to the distance between the points (ie
% separates a combined data set that contains multiple lines and produces
% data objects for each individual line)

if exist('plotter') == 0
    plotter = 0;
end

separatorvec = [0];
counter = 2;

for i = 1:(length(data(:,xcol))-1)
    if pointdistance([data(i,xcol) data(i,ycol)],[data(i+1,xcol) data(i+1,ycol)]) > dist_threshold
        separatorvec(counter) = i;
        counter = counter+1;
    end
end
separatorvec(counter) = length(data(:,1));



final_object = {};

for i = 1:(length(separatorvec)-1)
    name = ['line',num2str(i)];
    operation = [name,'=data(',num2str(separatorvec(i)+1),':',num2str(separatorvec(i+1)),',:);'];
    eval(operation);
end



counter = 1;
skipcounter = 1;
skipvec = [];

for i = 1:(length(separatorvec)-1)
    j = i+1;
    name = ['line',num2str(i)];
    while j < (length(separatorvec))
        if length(find(skipvec == i)) == 1
            break
        end
        if length(find(skipvec == j)) == 0
            name2 = ['line',num2str(j)];
            length1 = eval(['length(',name,'(:,1));']);
            length2 = eval(['length(',name2,'(:,1));']);
            point1eval = ['point1 = [',name,'(length(',name,'(:,1)),',num2str(xcol),') ',name,'(length(',name,'(:,1)),',num2str(ycol),')];'];
            eval(point1eval);
            if plotter == 1
                plot(point1(1),point1(2),'o')
                pause(0.5)
                hold all
            end
            for k = 1:2
                if k == 1
                    point2eval = ['point2 = [',name2,'(1,',num2str(xcol),') ',name2,'(1,',num2str(ycol),')];'];
                end
                if k == 2
                    point2eval = ['point2 = [',name2,'(length(',name2,'(:,1)),',num2str(xcol),') ',name2,'(length(',name2,'(:,1)),',num2str(ycol),')];'];
                end
                eval(point2eval);
                
                if plotter == 1
                plot(point2(1),point2(2),'o')
                hold all
                end
                if pointdistance(point1,point2) < dist_threshold
                    if k == 1
                        for m = 1:length2
                            operator = [name,'(',num2str(m+length1),',:) = ',name2,'(',num2str(m),',:);'];
                            eval(operator);
                        end
                    end
                    if k == 2
                        for m = 1:length2
                            operator = [name,'(',num2str(m+length1),',:) = ',name2,'(',num2str(length2+1-m),',:);'];
                            eval(operator);
                        end
                    end
                    skipvec(skipcounter) = j;
                    skipcounter = skipcounter + 1;
                end
            end
            j = j+1;
        else
            j = j+1;
        end
    end
end
                      

lineindex = 1:(length(separatorvec)-1);

counter = 1;
for i = lineindex
    if length(find(skipvec == i)) == 0
        finallines(counter) = i;
        counter = counter+1;
    end
end


counter = 1;
for i = finallines
    name = ['line',num2str(i)];
    entry = ['final_object{',num2str(counter),'} = ',name,';'];
    eval(entry);
    counter = counter+1;
end



line_object = final_object;

end