function output = color_call(color_str);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Provide a named color and return the RGB values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% color_str - the named color value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - 3 value matrix containing the RGB values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if length(color_str) == 3; if color_str== 'red'; output = [255, 0, 0]; end; end;
if length(color_str) == 3; if color_str== 'tan'; output = [210, 180, 140]; end; end;
if length(color_str) == 4; if color_str== 'aqua'; output = [0, 255, 255]; end; end;
if length(color_str) == 4; if color_str== 'blue'; output = [0, 0, 255]; end; end;
if length(color_str) == 4; if color_str== 'cyan'; output = [0, 255, 255]; end; end;
if length(color_str) == 4; if color_str== 'gold'; output = [255, 215, 0]; end; end;
if length(color_str) == 4; if color_str== 'gray'; output = [128, 128, 128]; end; end;
if length(color_str) == 4; if color_str== 'lime'; output = [0, 255, 0]; end; end;
if length(color_str) == 4; if color_str== 'navy'; output = [0, 0, 128]; end; end;
if length(color_str) == 4; if color_str== 'peru'; output = [205, 133, 63]; end; end;
if length(color_str) == 4; if color_str== 'pink'; output = [255, 192, 203]; end; end;
if length(color_str) == 4; if color_str== 'plum'; output = [221, 160, 221]; end; end;
if length(color_str) == 4; if color_str== 'snow'; output = [255, 250, 250]; end; end;
if length(color_str) == 4; if color_str== 'teal'; output = [0, 128, 128]; end; end;
if length(color_str) == 5; if color_str== 'azure'; output = [240, 255, 255]; end; end;
if length(color_str) == 5; if color_str== 'beige'; output = [245, 245, 220]; end; end;
if length(color_str) == 5; if color_str== 'black'; output = [0, 0, 0]; end; end;
if length(color_str) == 5; if color_str== 'brown'; output = [165, 42, 42]; end; end;
if length(color_str) == 5; if color_str== 'coral'; output = [255, 127, 80]; end; end;
if length(color_str) == 5; if color_str== 'green'; output = [0, 128, 0]; end; end;
if length(color_str) == 5; if color_str== 'ivory'; output = [255, 255, 240]; end; end;
if length(color_str) == 5; if color_str== 'khaki'; output = [240, 230, 140]; end; end;
if length(color_str) == 5; if color_str== 'linen'; output = [250, 240, 230]; end; end;
if length(color_str) == 5; if color_str== 'olive'; output = [128, 128, 0]; end; end;
if length(color_str) == 5; if color_str== 'wheat'; output = [245, 222, 179]; end; end;
if length(color_str) == 5; if color_str== 'white'; output = [255, 255, 255]; end; end;
if length(color_str) == 6; if color_str== 'bisque'; output = [255, 228, 196]; end; end;
if length(color_str) == 6; if color_str== 'indigo'; output = [75, 0, 130]; end; end;
if length(color_str) == 6; if color_str== 'maroon'; output = [128, 0, 0]; end; end;
if length(color_str) == 6; if color_str== 'orange'; output = [255, 165, 0]; end; end;
if length(color_str) == 6; if color_str== 'orchid'; output = [218, 112, 214]; end; end;
if length(color_str) == 6; if color_str== 'purple'; output = [128, 0, 128]; end; end;
if length(color_str) == 6; if color_str== 'salmon'; output = [250, 128, 114]; end; end;
if length(color_str) == 6; if color_str== 'sienna'; output = [160, 82, 45]; end; end;
if length(color_str) == 6; if color_str== 'silver'; output = [192, 192, 192]; end; end;
if length(color_str) == 6; if color_str== 'tomato'; output = [255, 99, 71]; end; end;
if length(color_str) == 6; if color_str== 'violet'; output = [238, 130, 238]; end; end;
if length(color_str) == 6; if color_str== 'yellow'; output = [255, 255, 0]; end; end;
if length(color_str) == 7; if color_str== 'crimson'; output = [220, 20, 60]; end; end;
if length(color_str) == 7; if color_str== 'darkred'; output = [139, 0, 0]; end; end;
if length(color_str) == 7; if color_str== 'dimgray'; output = [105, 105, 105]; end; end;
if length(color_str) == 7; if color_str== 'fuchsia'; output = [255, 0, 255]; end; end;
if length(color_str) == 7; if color_str== 'hotpink'; output = [255, 105, 180]; end; end;
if length(color_str) == 7; if color_str== 'magenta'; output = [255, 0, 255]; end; end;
if length(color_str) == 7; if color_str== 'oldlace'; output = [253, 245, 230]; end; end;
if length(color_str) == 7; if color_str== 'skyblue'; output = [135, 206, 235]; end; end;
if length(color_str) == 7; if color_str== 'thistle'; output = [216, 191, 216]; end; end;
if length(color_str) == 8; if color_str== 'cornsilk'; output = [255, 248, 220]; end; end;
if length(color_str) == 8; if color_str== 'darkblue'; output = [0, 0, 139]; end; end;
if length(color_str) == 8; if color_str== 'darkcyan'; output = [0, 139, 139]; end; end;
if length(color_str) == 8; if color_str== 'darkgray'; output = [169, 169, 169]; end; end;
if length(color_str) == 8; if color_str== 'deeppink'; output = [255, 20, 147]; end; end;
if length(color_str) == 8; if color_str== 'honeydew'; output = [240, 255, 240]; end; end;
if length(color_str) == 8; if color_str== 'lavender'; output = [230, 230, 250]; end; end;
if length(color_str) == 8; if color_str== 'moccasin'; output = [255, 228, 181]; end; end;
if length(color_str) == 8; if color_str== 'seagreen'; output = [46, 139, 87]; end; end;
if length(color_str) == 8; if color_str== 'seashell'; output = [255, 245, 238]; end; end;
if length(color_str) == 9; if color_str== 'aliceblue'; output = [240, 248, 255]; end; end;
if length(color_str) == 9; if color_str== 'burlywood'; output = [222, 184, 135]; end; end;
if length(color_str) == 9; if color_str== 'cadetblue'; output = [95, 158, 160]; end; end;
if length(color_str) == 9; if color_str== 'chocolate'; output = [210, 105, 30]; end; end;
if length(color_str) == 9; if color_str== 'darkgreen'; output = [0, 100, 0]; end; end;
if length(color_str) == 9; if color_str== 'darkkhaki'; output = [189, 183, 107]; end; end;
if length(color_str) == 9; if color_str== 'firebrick'; output = [178, 34, 34]; end; end;
if length(color_str) == 9; if color_str== 'gainsboro'; output = [220, 220, 220]; end; end;
if length(color_str) == 9; if color_str== 'goldenrod'; output = [218, 165, 32]; end; end;
if length(color_str) == 9; if color_str== 'indianred'; output = [205, 92, 92]; end; end;
if length(color_str) == 9; if color_str== 'lawngreen'; output = [124, 252, 0]; end; end;
if length(color_str) == 9; if color_str== 'lightblue'; output = [173, 216, 230]; end; end;
if length(color_str) == 9; if color_str== 'lightcyan'; output = [224, 255, 255]; end; end;
if length(color_str) == 9; if color_str== 'lightgray'; output = [211, 211, 211]; end; end;
if length(color_str) == 9; if color_str== 'lightpink'; output = [255, 182, 193]; end; end;
if length(color_str) == 9; if color_str== 'limegreen'; output = [50, 205, 50]; end; end;
if length(color_str) == 9; if color_str== 'mintcream'; output = [245, 255, 250]; end; end;
if length(color_str) == 9; if color_str== 'mistyrose'; output = [255, 228, 225]; end; end;
if length(color_str) == 9; if color_str== 'olivedrab'; output = [107, 142, 35]; end; end;
if length(color_str) == 9; if color_str== 'orangered'; output = [255, 69, 0]; end; end;
if length(color_str) == 9; if color_str== 'palegreen'; output = [152, 251, 152]; end; end;
if length(color_str) == 9; if color_str== 'peachpuff'; output = [255, 218, 185]; end; end;
if length(color_str) == 9; if color_str== 'rosybrown'; output = [188, 143, 143]; end; end;
if length(color_str) == 9; if color_str== 'royalblue'; output = [65, 105, 225]; end; end;
if length(color_str) == 9; if color_str== 'slateblue'; output = [106, 90, 205]; end; end;
if length(color_str) == 9; if color_str== 'slategray'; output = [112, 128, 144]; end; end;
if length(color_str) == 9; if color_str== 'steelblue'; output = [70, 130, 180]; end; end;
if length(color_str) == 9; if color_str== 'turquoise'; output = [64, 224, 208]; end; end;
if length(color_str) == 10; if color_str== 'aquamarine'; output = [127, 255, 212]; end; end;
if length(color_str) == 10; if color_str== 'blueviolet'; output = [138, 43, 226]; end; end;
if length(color_str) == 10; if color_str== 'chartreuse'; output = [127, 255, 0]; end; end;
if length(color_str) == 10; if color_str== 'darkorange'; output = [255, 140, 0]; end; end;
if length(color_str) == 10; if color_str== 'darkorchid'; output = [153, 50, 204]; end; end;
if length(color_str) == 10; if color_str== 'darksalmon'; output = [233, 150, 122]; end; end;
if length(color_str) == 10; if color_str== 'darkviolet'; output = [148, 0, 211]; end; end;
if length(color_str) == 10; if color_str== 'dodgerblue'; output = [30, 144, 255]; end; end;
if length(color_str) == 10; if color_str== 'ghostwhite'; output = [248, 248, 255]; end; end;
if length(color_str) == 10; if color_str== 'lightcoral'; output = [240, 128, 128]; end; end;
if length(color_str) == 10; if color_str== 'lightgreen'; output = [144, 238, 144]; end; end;
if length(color_str) == 10; if color_str== 'mediumblue'; output = [0, 0, 205]; end; end;
if length(color_str) == 10; if color_str== 'papayawhip'; output = [255, 239, 213]; end; end;
if length(color_str) == 10; if color_str== 'powderblue'; output = [176, 224, 230]; end; end;
if length(color_str) == 10; if color_str== 'sandybrown'; output = [244, 164, 96]; end; end;
if length(color_str) == 10; if color_str== 'whitesmoke'; output = [245, 245, 245]; end; end;
if length(color_str) == 11; if color_str== 'darkmagenta'; output = [139, 0, 139]; end; end;
if length(color_str) == 11; if color_str== 'deepskyblue'; output = [0, 191, 255]; end; end;
if length(color_str) == 11; if color_str== 'floralwhite'; output = [255, 250, 240]; end; end;
if length(color_str) == 11; if color_str== 'forestgreen'; output = [34, 139, 34]; end; end;
if length(color_str) == 11; if color_str== 'greenyellow'; output = [173, 255, 47]; end; end;
if length(color_str) == 11; if color_str== 'lightsalmon'; output = [255, 160, 122]; end; end;
if length(color_str) == 11; if color_str== 'lightsalmon'; output = [255, 160, 122]; end; end;
if length(color_str) == 11; if color_str== 'lightyellow'; output = [255, 255, 224]; end; end;
if length(color_str) == 11; if color_str== 'navajowhite'; output = [255, 222, 173]; end; end;
if length(color_str) == 11; if color_str== 'saddlebrown'; output = [139, 69, 19]; end; end;
if length(color_str) == 11; if color_str== 'springgreen'; output = [0, 255, 127]; end; end;
if length(color_str) == 11; if color_str== 'yellowgreen'; output = [154, 205, 50]; end; end;
if length(color_str) == 12; if color_str== 'antiquewhite'; output = [250, 235, 215]; end; end;
if length(color_str) == 12; if color_str== 'darkseagreen'; output = [143, 188, 139]; end; end;
if length(color_str) == 12; if color_str== 'lemonchiffon'; output = [255, 250, 205]; end; end;
if length(color_str) == 12; if color_str== 'lightskyblue'; output = [135, 206, 250]; end; end;
if length(color_str) == 12; if color_str== 'mediumorchid'; output = [186, 85, 211]; end; end;
if length(color_str) == 12; if color_str== 'mediumpurple'; output = [147, 112, 219]; end; end;
if length(color_str) == 12; if color_str== 'midnightblue'; output = [25, 25, 112]; end; end;
if length(color_str) == 13; if color_str== 'darkgoldenrod'; output = [184, 134, 11]; end; end;
if length(color_str) == 13; if color_str== 'darkslateblue'; output = [72, 61, 139]; end; end;
if length(color_str) == 13; if color_str== 'darkslategray'; output = [47, 79, 79]; end; end;
if length(color_str) == 13; if color_str== 'darkturquoise'; output = [0, 206, 209]; end; end;
if length(color_str) == 13; if color_str== 'lavenderblush'; output = [255, 240, 245]; end; end;
if length(color_str) == 13; if color_str== 'lightseagreen'; output = [32, 178, 170]; end; end;
if length(color_str) == 13; if color_str== 'palegoldenrod'; output = [238, 232, 170]; end; end;
if length(color_str) == 13; if color_str== 'paleturquoise'; output = [175, 238, 238]; end; end;
if length(color_str) == 13; if color_str== 'palevioletred'; output = [219, 112, 147]; end; end;
if length(color_str) == 13; if color_str== 'rebeccapurple'; output = [102, 51, 153]; end; end;
if length(color_str) == 14; if color_str== 'blanchedalmond'; output = [255, 235, 205]; end; end;
if length(color_str) == 14; if color_str== 'cornflowerblue'; output = [100, 149, 237]; end; end;
if length(color_str) == 14; if color_str== 'darkolivegreen'; output = [85, 107, 47]; end; end;
if length(color_str) == 14; if color_str== 'lightslategray'; output = [119, 136, 153]; end; end;
if length(color_str) == 14; if color_str== 'lightsteelblue'; output = [176, 196, 222]; end; end;
if length(color_str) == 14; if color_str== 'mediumseagreen'; output = [60, 179, 113]; end; end;
if length(color_str) == 15; if color_str== 'mediumslateblue'; output = [123, 104, 238]; end; end;
if length(color_str) == 15; if color_str== 'mediumslateblue'; output = [123, 104, 238]; end; end;
if length(color_str) == 15; if color_str== 'mediumturquoise'; output = [72, 209, 204]; end; end;
if length(color_str) == 15; if color_str== 'mediumvioletred'; output = [199, 21, 133]; end; end;
if length(color_str) == 16; if color_str== 'mediumaquamarine'; output = [102, 205, 170]; end; end;
if length(color_str) == 17; if color_str== 'mediumspringgreen'; output = [0, 250, 154]; end; end;
if length(color_str) == 20; if color_str== 'lightgoldenrodyellow'; output = [250, 250, 210]; end; end;


if exist('output') ~= 1
    output = color_str;
else
    output = output/255;
end

end







