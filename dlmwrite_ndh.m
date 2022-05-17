function dlmwrite_ndh(savename,mat_in,header,delimit_opt,precision_opt,notes_field)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% Writes out a text file with an appropriate header line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% savename - the filename (including extension) to write to
% mat_in - the matrix containing data to write (can also take structure)
% header - a cell array, containing strings to use for header information
% delimit_opt - a character string defining the delimeter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

sname1 = 'temptemptemp.txt';

if exist('delimit_opt') == 0;
    delimit_opt = '\t';
end
if exist('precision_opt') == 0;
    precision_opt = 8;
end

if isstruct(mat_in) == 1
    temp_data = mat_in;
    header = fields(temp_data);
    mat_in = [];
    for i = 1:length(header)
        read_str = ['mat_in(:,',num2str(i),') = temp_data.',header{i},';'];
        eval(read_str);
    end
end

%%%%%%%%%%%%%% This adds in the header line if it is provided
if exist('header') == 1
    
    fid = fopen(sname1, 'wt');
    write_str = ['>'];
    for i = 1:length(header)
        write_str = [write_str '%s' delimit_opt ' '];
    end
    write_str = [write_str(1:end-1),'\n'];
       
    %%%%%%%%%%% Add the header words to the first row
    fprintf_str = ['fprintf(fid, write_str,'];
    for i = 1:length(header)
        fprintf_str = [fprintf_str,'''',header{i},''','];
    end
    fprintf_str = [fprintf_str(1:end-1),');'];
    eval(fprintf_str);
    
    %%%%%%%%%%% Add line breaks to the second row
%     fprintf_str = ['fprintf(fid, write_str,'];
%     for i = 1:length(header)
%         fprintf_str = [fprintf_str,'''',repmat('-',1,length(header{i})),''','];
%     end
%     fprintf_str = [fprintf_str(1:end-1),');'];
%     eval(fprintf_str);
    
    
    fclose(fid);
end

%%%%%%%%%%%%% Add the data to subsequent rows
dlmwrite(sname1,mat_in,'delimiter',delimit_opt,'-append','precision',precision_opt);
fid2 = fopen(savename, 'wt');

if exist('notes_field') == 1
    fid = fopen(sname1);
    line = fgetl(fid); %fgetl does not return the /n character
    fprintf(fid2,line);
    fprintf(fid2,[delimit_opt,'[[notes]]\n']);
    for i = 1:length(notes_field)
        line = fgetl(fid); %fgetl does not return the /n character
        fprintf(fid2,line);
        fprintf(fid2,[delimit_opt,'[[',notes_field{i},']]\n']);
    end
    fclose(fid);
else
    
    copyfile(sname1,savename,'f')
    
end

fclose(fid2);

delete(sname1);


    













