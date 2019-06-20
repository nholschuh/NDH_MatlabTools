LastDir2 = pwd;

spaces = find(LastDir==' ');
dashes = find(LastDir=='\');
ind = 1;
if length(dashes) == 0
    dashes = find(LastDir=='/');
    ind = 2;
end

if length(spaces) > 0
   for i = 1:length(spaces)
       dashstopper = [];
       for j = 1:length(dashes)
           if dashes(j) > spaces(i)
                dashstopper = dashes(j);
                break
           end
       end
       if length(dashstopper) == 0
           dashstopper = length(LastDir)+1;
       end
       obj1 = LastDir(1:(spaces(i)-1));
       obj1a ='''';
       obj2 = LastDir((spaces(i)):(dashstopper-1));
       obj3 = '''';
       if length(LastDir) > dashstopper
           obj4 = LastDir(dashstopper:end);
       else
           obj4 = [];
       end
       LastDir = [obj1,obj1a,obj2,obj3,obj4];
   end
end
       

str1 = ['cd ',LastDir];
eval(str1)

LastDir = LastDir2;

clear obj* dashes spaces ind dashstopper LastDir2 i j str1