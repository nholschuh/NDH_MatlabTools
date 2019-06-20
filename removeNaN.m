function [result removed_inds] = removeNaN(object)
% Recreates the object with any rows containing NaN's excluded.


if length(object(:,1)) == 1 | length(object(:,1)) < length(object(1,:))
    object = object';
    flag_n = 1;
end


[r c] = find(isnan(object) == 1);
object(r,:) = [];
result = object;

removed_inds = r;

if exist('flag_n') == 1
    result = result';
end

end