% The landward limit of flexure
gl_1 = [];

% The point where ice is hydrostatically balanced
gl_2 = [];

% The break in slope associated with flexure
gl_3 = [];



a = dlmread('Amery_GZ.txt');
b = dlmread('New_ANTP_GZ.txt');
c = dlmread('New_Coates_GZ.txt');
d = dlmread('New_EANT_GZ.txt');
e = dlmread('New_Enderby_GZ.txt');
f = dlmread('New_Maud_GZ.txt');
g = dlmread('New_PIG_GZ.txt');
h = dlmread('New_Ronne_GZ.txt');
k = dlmread('New_Ross_GZ.txt');

name_vec = {'a','b','c','d','e','f','g','h','k'};

for i = 1:length(name_vec)
    temp = eval(name_vec{i});
    for j = 1:length(temp)
        if temp(j,4) == 1
            gl_1 = [gl_1; temp(j,1:2)];
        elseif temp(j,4) == 2
            gl_2 = [gl_2; temp(j,1:2)];
        elseif temp(j,4) == 3
            gl_3 = [gl_3; temp(j,1:2)];
        end
    end
end

[gl_1(:,1) gl_1(:,2)] = polarstereo_fwd(gl_1(:,2),gl_1(:,1));
[gl_2(:,1) gl_2(:,2)] = polarstereo_fwd(gl_2(:,2),gl_2(:,1));
[gl_3(:,1) gl_3(:,2)] = polarstereo_fwd(gl_3(:,2),gl_3(:,1));

save ICEsat_gl.mat gl_1 gl_2 gl_3