function Write_dV_V_Volume(TraceAveraging_Output,ColoredInversion_Output,OriginalSegy_Header,merge_onoff,prefix);
%% (C) 2015 - Chevron ETC - Author: Nick Holschuh (nick.holschuh@gmail.com)
% This code is designed to write the output of the spectral shaping and
% merge algorithm to a segy file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs: %
%%%%%%%%%%%
% TraceAveraging_Output - A sample volume output from the TraceAveraging_3D
%                         function.
%
% ColoredInversion_Output - The output volume from ColoredInversion_3D
%
% OriginalSegy_Header - A sample header from the original ReadSegy
%                       operations.
%
% merge_onoff - (0) for only shaping, (1) for shaping and merge, only used
%               in setting the output file_name which provides the date and 
%               time of output.
%
% prefix - A string which is added to the front of the output filename
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debugger = 0;
if debugger == 1
    TraceAveraging_Output = volumes1;
    ColoredInversion_Output = dV_V;
    OriginalSegy_Header = header1;
end

if exist('merge_onoff') == 0
    merge_onoff = 1;
end


locator = TraceAveraging_Output{10};
headers = OriginalSegy_Header;
data = zeros(length(TraceAveraging_Output{8}),length(headers));
for i = 1:length(OriginalSegy_Header);
    [row col] = find(locator == i);
    data(:,i) = squeeze(ColoredInversion_Output(row,col,:))';
end


clock_vals = clock;

%%% Compiling the relevent header objects
if merge_onoff == 0
    filename = ['''',prefix,'DV_V_nomerge_',num2str(clock_vals(2)),'_',num2str(clock_vals(3)),'_',num2str(clock_vals(4)),num2str(clock_vals(5)),'.segy'''];
    WriteString = ['WriteSegy(',filename,',data'];
else
    filename = ['''',prefix,'DV_V_merge',num2str(clock_vals(2)),'_',num2str(clock_vals(3)),'_',num2str(clock_vals(4)),num2str(clock_vals(5)),'.segy'''];
    WriteString = ['WriteSegy(',filename,',data'];
end

WriteString = [WriteString,',''dt'',dt'];
dt = headers(1).dt;

WriteString = [WriteString,',''ns'',ns'];
ns = headers(1).ns;

WriteString = [WriteString,',''LagTimeA'',LagTimeA'];
LagTimeA = [headers.LagTimeA];

WriteString = [WriteString,',''DelayRecordingTime'',DelayRecordingTime'];
DelayRecordingTime = [headers.DelayRecordingTime];

WriteString = [WriteString,',''cdp'',cdp'];
cdp = [headers.cdp];

WriteString = [WriteString,',''cdpX'',cdpX'];
cdpX = [headers.cdpX];

WriteString = [WriteString,',''cdpY'',cdpY'];
cdpY = [headers.cdpY];

WriteString = [WriteString,',''SourceX'',SourceX'];
SourceX = [headers.SourceX];

WriteString = [WriteString,',''SourceY'',SourceY'];
SourceY = [headers.SourceY];

WriteString = [WriteString,',''Inline3D'',Inline3D'];
Inline3D = [headers.Inline3D];

WriteString = [WriteString,',''Crossline3D'',Crossline3D'];
Crossline3D = [headers.Crossline3D];

WriteString = [WriteString,',''ElevationScalar'',ElevationScalar'];
ElevationScalar = [headers.ElevationScalar];

WriteString = [WriteString,',''SourceGroupScalar'',SourceGroupScalar'];
SourceGroupScalar = [headers.SourceGroupScalar];

WriteString = [WriteString,');'];
eval(WriteString)

disp(['File written to ',filename])


end
