function result = NaN2value(object,value1,value2)
% converts all value1's to value2s in an object

index = find(object == value1);
object(index) = value2;
result = object;
end
