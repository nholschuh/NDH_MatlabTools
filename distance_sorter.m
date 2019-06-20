function newmatrix = distance_sorter(mat,colX,colY)
% Takes input matrix with columns containing x data (column index = colX)
% and y data (column index = colY) and sorts them to minimize the distance
% between points.

Xs = mat(:,colX);
Ys = mat(:,colY);

[C,I1] = max(Xs);
[C,I2] = min(Xs);
[C,I3] = max(Ys);
[C,I4] = min(Ys);

clear C;
Is = [I1 I2 I3 I4];
matlength = length(mat(:,1));

indexvec = [1:matlength]';

sortmat1full = [Xs Ys indexvec];
sortmat2full = [Ys Xs indexvec];

% Starting with the leftmost value
sortmat11 = sortrows(sortmat1full);
sortmat21 = sortrows(sortmat2full);
indexsequence1 = [sortmat11(:,3) sortmat21(:,3)];

% Starting with the bottommost value
sortmat12 = sortrows(sortmat2full);
sortmat22 = sortrows(sortmat1full);
indexsequence2 = [sortmat12(:,3) sortmat22(:,3)];

% Starting with the rightmost value
sortmat13 = flipud(sortrows(sortmat1full));
sortmat23 = flipud(sortrows(sortmat2full));
indexsequence3 = [sortmat13(:,3) sortmat23(:,3)];

% Starting with the topmost value
sortmat14 = flipud(sortrows(sortmat2full));
sortmat24 = flipud(sortrows(sortmat1full));
indexsequence4 = [sortmat14(:,3) sortmat24(:,3)];


distvec = zeros(1,4);

for m = 1:2
    start = 1;
    finish = 4;
    
    for j = start:finish
        
        index = Is(j);
        
        if j ==1
            indexsequencetemp = indexsequence1;
        end
        if j ==2
            indexsequencetemp = indexsequence2;
        end
        if j ==3
            indexsequencetemp = indexsequence3;
        end
        if j ==4
            indexsequencetemp = indexsequence4;
        end
        
        
        disttemp = zeros(1,matlength-1);
        finalmat = zeros(matlength,length(mat(1,:)));
        
        for i = 1:matlength
            finalmat(i,:) = mat(index,:);
            dist = zeros(1,4);
            next = zeros(1,4);
            temp = find(indexsequencetemp == index);
            temp(2) = temp(2) - length(indexsequencetemp(:,1));
            
            if temp(1) < length(indexsequencetemp(:,1))
                next(1) = indexsequencetemp(temp(1)+1,1);
                dist(1) = norm([mat(index,colX) mat(index,colY)] - [mat(next(1),colX) mat(next(1),colY)]);
            end
            
            if temp(2) < length(indexsequencetemp(:,1))
                next(2) = indexsequencetemp(temp(2)+1,2);
                dist(2) = norm([mat(index,colX) mat(index,colY)] - [mat(next(2),colX) mat(next(2),colY)]);
            end
            
            if temp(1) > 1
                next(3) = indexsequencetemp(temp(1)-1,1);
                dist(3) = norm([mat(index,colX) mat(index,colY)] - [mat(next(3),colX) mat(next(3),colY)]);
            end
            
            if temp(2) > 1
                next(4) = indexsequencetemp(temp(2)-1,2);
                dist(4) = norm([mat(index,colX) mat(index,colY)] - [mat(next(4),colX) mat(next(4),colY)]);
            end
            
            for m = 1:4
                if dist(m) == 0
                    dist(m) = max(dist)+15;
                end
            end
            distindex = find(dist == min(dist));
            
            indexsequencetemp1 = removerows(indexsequencetemp(:,1),'ind',temp(1));
            indexsequencetemp2 = removerows(indexsequencetemp(:,2),'ind',temp(2));
            indexsequencetemp = [indexsequencetemp1 indexsequencetemp2];
            
            
            index = next(distindex(1));
            if i > 1
                disttemp(i-1) = dist(distindex(1));
            end
        end
        
        distvec(j) = sum(disttemp);
    end
    start = find(distvec == min(distvec));
    start = finish;
    
end

workingmat = finalmat;


%%%%% Line Crossing Filter
% This section of code switches rows until no two adjacent line segments
% cross (adjectent meaning the end points are not within 'kinksearch' nodes
%  of one another

crosssearch = 20;
if crosssearch > matlength-2
    crosssearch = matlength-2;
end


for m = fliplr(3:crosssearch+2)
    counter = 2;
    while counter > 1
        counter = 1;
        for i = 1:matlength-m
            lin1 = [workingmat(i,colX) workingmat(i,colY); workingmat(i+1,colX) workingmat(i+1,colY)];
            lin2 = [workingmat(i+m-1,colX) workingmat(i+m-1,colY); workingmat(i+m,colX) workingmat(i+m,colY)];
            if segment_intersect(lin1,lin2) == 1
                temprow = workingmat(i+1,:);
                workingmat(i+1,:) = workingmat(i+m-1,:);
                workingmat(i+m-1,:) = temprow;
                counter = counter+1;
            end
        end
    end
end


%%%%% Kink Filter
% This section of code is designed to eliminate any kinks found within the
% final line. The angle threshold for a kink is defined as 'athreshold'

athreshold = 10;

athreshold = deg2rad(athreshold);
counter = 2;
inf_protect_counter = 0;

while counter > 1
    counter = 1;
    for i = 1:matlength-2
        lin1 = [workingmat(i,colX) workingmat(i,colY); workingmat(i+1,colX) workingmat(i+1,colY)];
        lin2 = [workingmat(i+1,colX) workingmat(i+1,colY); workingmat(i+2,colX) workingmat(i+2,colY)];
        angle = segment_angle(lin1,lin2);
        if angle < athreshold
            temprow = workingmat(i,:);
            workingmat(i,:) = workingmat(i+1,:);
            workingmat(i+1,:) = temprow;
            counter = counter+1;
        end
    end
    inf_protect_counter = inf_protect_counter + 1
    if inf_protect_counter > 2
        break
    end
end



%%%%% Line Crossing Filter 2
% This section of code switches rows until no two adjacent line segments
% cross (adjectent meaning the end points are not within 'kinksearch' nodes
%  of one another

crosssearch = 20;
if crosssearch > matlength-2
    crosssearch = matlength-2;
end


for m = fliplr(3:crosssearch+2)
    counter = 2;
    while counter > 1
        counter = 1;
        for i = 1:matlength-m
            lin1 = [workingmat(i,colX) workingmat(i,colY); workingmat(i+1,colX) workingmat(i+1,colY)];
            lin2 = [workingmat(i+m-1,colX) workingmat(i+m-1,colY); workingmat(i+m,colX) workingmat(i+m,colY)];
            if segment_intersect(lin1,lin2) == 1
                temprow = workingmat(i+1,:);
                workingmat(i+1,:) = workingmat(i+m-1,:);
                workingmat(i+m-1,:) = temprow;
                counter = counter+1;
            end
        end
    end
end



newmatrix = workingmat;
end
        



