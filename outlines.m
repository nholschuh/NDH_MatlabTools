function [outlines image sizes] = outlines(object,min_size)

[B L] = bwboundaries(object);

counter = 1;
for i = 1:length(B)
    sizes(i,1) = length(find(L==i));
    if sizes(i) < min_size
        L(find(L==i)) = 0;
        remove_vec(counter) = i;
        counter = counter+1;
    end
    if mod(i,100) == 0
        i
    end
end

B = removerows(B,'ind',remove_vec);
sizes = removerows(sizes,'ind',remove_vec);

outlines = B;
image = L;
      
    
end