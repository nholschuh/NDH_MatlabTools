function output = parse_xmlstring(xmlString)

try
    % The following avoids the need for file I/O:
    inputObject = java.io.StringBufferInputStream(xmlString);  % or: org.xml.sax.InputSource(java.io.StringReader(xmlString))
    try
        % Parse the input data directly using xmlread's core functionality
        parserFactory = javaMethod('newInstance','javax.xml.parsers.DocumentBuilderFactory');
        p = javaMethod('newDocumentBuilder',parserFactory);
        xmlTreeObject = p.parse(inputObject);
        output = xml2struct(xmlTreeObject);
    catch
        % Use xmlread's semi-documented inputObject input feature
        xmlTreeObject = xmlread(inputObject);
        output = xml2struct(xmlTreeObject);
    end
catch
    % Fallback to standard xmlread usage, using a temporary XML file:
 
    % Store the XML data in a temp *.xml file
    filename = [tempname '.xml'];
    fid = fopen(filename,'Wt');
    fwrite(fid,xmlString);
    fclose(fid);
 
    % Read the file into an XML model object
    xmlTreeObject = xmlread(filename);
    output = xml2struct(xmlTreeObject);
 
    % Delete the temp file
    delete(filename);
end