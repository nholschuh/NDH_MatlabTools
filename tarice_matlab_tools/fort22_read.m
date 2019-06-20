function [data headers] = fort22_read(name,var_prefix)
%Reads a Clean_fort.22 file and produces a data file

if exist('name') == 0
    filename ='fort.22';
else
    filename = name;
end

startRow = 4;
% For more information, see the TEXTSCAN documentation.
formatSpec = '%10s%7s%7s%7s%7s%7s%7s%7s%7s%8s%8s%8s%7s%7s%7s%12s%12s%12s%12s%12s%12s%8s%9s%9s%9s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

exclude_vec = [];
for i = 1:length(dataArray{1,3})
    if dataArray{1,1}{i}(1) ~= dataArray{1,1}{1}(1)
        exclude_vec = [exclude_vec i];
    end
end

for i = 1:length(dataArray)
    for j = 1:length(exclude_vec)
        dataArray{1,i}(exclude_vec(end+1-j)) = [];
    end
end
       

if length(dataArray{1,1}) > 5000
    scaler = round(length(dataArray{1,1})/5000);
    for i = 1:length(dataArray)
        dataArray{1,i} = dataArray{1,i}(1:scaler:length(dataArray{1,i}));
%         for j = fliplr(1:length(dataArray{1,1}))
%             if mod((j-1),scaler) ~= 0
%                 dataArray{1,i}(j) = [];
%             end
%         end
    end
end


%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end

            Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = eval(numbers);
                raw{row, col} = eval(numbers);
            end
        catch me
        end
    end
end



%% Replace non-numeric cells with NaN
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
% raw(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
varnames = {'time','weirun','ro18','sealev','dtanta','dtants','dtantj','dtseas',...
    'rco2','ecc','obl','prec','facice','facorb','facco2','totikm3','totigkm3','totifkm3',...
    'totakm2','totagkm2','totafkm2','hm','eslem','eslwm','eslm','esl2m'};

for i = 1:length(varnames)
    eval_string = [varnames{i},' = (str2mat(raw(:,',num2str(i),')));'];
    eval(eval_string);
    eval_string = [varnames{i},' = (str2num(',varnames{i},'));'];
    eval(eval_string);
end
% time = (str2num(raw(:, 1)));
% weirun = (str2num(raw(:, 2)));
% ro18 = (str2num(raw(:, 3)));
% sealev = (str2num(raw(:, 4)));
% dtanta = (str2num(raw(:, 5)));
% dtants = (str2num(raw(:, 6)));
% dtantj = (str2num(raw(:, 7)));
% dtseas = (str2num(raw(:, 8)));
% rco2 = (str2num(raw(:, 9)));
% ecc = (str2num(raw(:, 10)));
% obl = (str2num(raw(:, 11)));
% prec = (str2num(raw(:, 12)));
% facice = (str2num(raw(:, 13)));
% facorb = (str2num(raw(:, 14)));
% facco2 = (str2num(raw(:, 15)));
% totikm3 = (str2num(raw(:, 16)));
% totigkm3 = (str2num(raw(:, 17)));
% totifkm3 = (str2num(raw(:, 18)));
% totakm2 = (str2num(raw(:, 19)));
% totagkm2 = (str2num(raw(:, 20)));
% totafkm2 = (str2num(raw(:, 21)));
% hm = (str2num(raw(:, 22)));
% eslem = (str2num(raw(:, 23)));
% eslwm = (str2num(raw(:, 24)));
% eslm = (str2num(raw(:, 25)));
% esl2m = (str2num(raw(:, 26)));

%% Clear temporary variables
clearvars filename startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;

counter = 1;
remove_vec = [];
for i = 1:length(time)
    if isnan(time(i)) == 1
        remove_vec(counter) = i;
        counter = counter+1;
    end
end

if length(remove_vec) > 0
for i = 1:length(varnames)
    op_string = [varnames{i},' = removerows(',varnames{i},',''ind'',remove_vec);'];
	eval(op_string);
end
end
    
remove_vec = [];
for i = 2:length(time)
    if time(i) < time(i-1)
        stop_vec = find(time(i) == time);
        remove_vec = [remove_vec stop_vec(1):(i-1)];
    end
end
     

if length(remove_vec) > 0
for j = 1:length(varnames)
    op_string = ['removerows(',varnames{j},',''ind'',remove_vec);'];
    eval(op_string);
end
end


if exist('var_prefix') == 0
    var_prefix = [];
end


for i = 1:length(varnames)
    op_string = ['assignin(''base'', ''',var_prefix,varnames{i},''', ',varnames{i},');'];
    eval(op_string);
end

end
        
        
        

