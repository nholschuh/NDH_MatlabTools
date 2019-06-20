function output = CresisPath();

if exist([OnePath,'Research_Projects/00_CresisData/'],'dir') == 7
     output = [OnePath,'Research_Projects/00_CresisData/'];
else
    output = [];
end