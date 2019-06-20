function results = pointdistance(p1,p2)
% Calculates the distance between two points p1 and p2
if length(p1(1,:)) == 2
else
    p1 = p1';
    p2 = p2';
end
for i = 1:length(p1(:,1))
    results(i) = norm(p2(i,:)-p1(i,:));
end
end
    
