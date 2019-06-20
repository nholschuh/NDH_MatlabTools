function out_box = make_box(input_line,r_or_l,aspect_ratio)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% Takes an input line and generates a box with that as one side.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input_line - 2x2 input line
% r_or_l - [0] = to the right, 1 = to the left
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('r_or_l') == 0
    r_or_l = 0;
end
if exist('aspect_ratio') == 0
    aspect_ratio = 1;
end

ol1 = make_ortholine(input_line,0,r_or_l);

s1 = (flipud(ol1)-[ol1(2,:); ol1(2,:)])*aspect_ratio+[ol1(2,:); ol1(2,:)];
ol2 = make_ortholine(s1,0,r_or_l);

s2 = (flipud(ol2)-[ol2(2,:); ol2(2,:)])/aspect_ratio+[ol2(2,:); ol2(2,:)];
ol3 = make_ortholine(s2,0,r_or_l);

s3 = (flipud(ol3)-[ol3(2,:); ol3(2,:)])*aspect_ratio+[ol3(2,:); ol3(2,:)];
ol4 = make_ortholine(s3,0,r_or_l);

out_box = [input_line(1,:); ...
    ol1(2,:); ...
    ol2(2,:); ...
    ol3(2,:); ...
    ol4(2,:)];
end







