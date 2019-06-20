function figure_c_invert(method)

%%% method options:
%%%    0 - Flip axis and colorbar colors
%%%    1 - Flip axis colors
%%%    2 - Flip colorbar colors

if exist('method') == 0
    method = 0;
end

c_start = get(gcf,'Color');
c_end = 1 - c_start;
set(gcf,'Color',c_end);


cs = get(gcf,'Children');

for i = 1:length(cs)
    %%%%%%%%%%%%%%%%%%%%% This flips the colorbar colors
    if method == 0 | method == 2
        if length(get(cs(i),'Type')) == 8
            if get(cs(i),'Type') == 'colorbar'
                sc = get(cs(i),'Color');
                ec = 1 - sc;
                set(cs(i),'Color',ec);
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%% This flips the Axis colors
    if method == 0 | method == 1
        if length(get(cs(i),'Type')) == 4
            if get(cs(i),'Type') == 'axes'
                               
                sc1 = get(cs(i),'GridColor');
                ec1 = 1 - sc1;
                set(cs(i),'GridColor',ec1);
                
                sc2 = get(cs(i),'XColor');
                ec2 = 1 - sc2;
                set(cs(i),'XColor',ec2);
                
                sc3 = get(cs(i),'YColor');
                ec3 = 1 - sc3;
                set(cs(i),'YColor',ec3);
                
                sc3b = get(cs(i),'ZColor');
                ec3b = 1 - sc3b;
                set(cs(i),'ZColor',ec3b);
                
                sc4 = get(cs(i),'GridColor');
                ec4 = 1 - sc4;
                set(cs(i),'GridColor',ec4);
                            
                sc5 = cs(i).Title.Color;
                ec5 = 1 - sc5;
                cs(i).Title.Color = ec5;
            end
        end
    end
end







