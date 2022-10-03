function outputStruct = importTrace(filename, dataLines)
%IMPORTFILE Import data from a text file
%  TRACE = IMPORTFILE(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  TRACE = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  trace = importfile("C:\Users\david\Desktop\060322Ac2\trace.swc", [7, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 27-Jun-2022 13:04:52

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [7, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ["\t", " "];

% Specify column names and types
% opts.VariableNames = ["Var1", "Var2", "from", "SNT", "v411", "Var6", "Var7"];
% opts.SelectedVariableNames = ["from", "SNT", "v411"];
% opts.VariableTypes = ["string", "string", "double", "double", "double", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var6", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var6", "Var7"], "EmptyFieldRule", "auto");

% Import the data
temp = readtable(filename, opts);
temp = table2cell(temp);
temp = str2double(temp);
trace = temp(:,3:5);
trace = trace - mean(trace,1);%center the nodes at the centroid
parentNode = temp(:,7);

%% calculate total dendritic distance
curLoc = trace(2:end,:);
parentLoc = trace(parentNode(2:end),:);

nodeDists = sqrt((curLoc(:,1) - parentLoc(:,1)).^2 + (curLoc(:,2)-parentLoc(:,2)).^2 + (curLoc(:,3) - parentLoc(:,3)).^2);
totalDendDist = sum(nodeDists);

%% output the trace, total dendritic distance, and the index of the location of the parent node
outputStruct = struct();
outputStruct.trace = trace;
outputStruct.totalLength = totalDendDist;
outputStruct.parentLoc = parentLoc;


end