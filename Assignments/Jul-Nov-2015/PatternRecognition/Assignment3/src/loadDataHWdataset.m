%% Copyright (C) 2015 Arulkumar
%% 
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*- 
%% @deftypefn {Function File} {@var{retval} =} loadDataHWdataset (@var{input1}, @var{input2})
%%
%% @seealso{}
%% @end deftypefn

%% Author: Arulkumar <Arulkumar@MYVAIO>
%% Created: 2015-10-25

function [data] = loadDataHWdataset (filepath, classIndex)
   
data = [];
fileID = fopen(filepath);

count = 0;

while ~feof(fileID)
    % read the dummy ID
    line = fgets(fileID);
    [~] = sscanf(line, '%d');

    % read the character name
    line = fgets(fileID);
    character = sscanf(line, '%s');

    % read the number of points and the point values
    length=fscanf(fileID, '%d', 1);
    vals=fscanf(fileID, '%g', 2 * length);
    
    %dummy read to avoid space
    [~] = fgets(fileID);

    % reshape the data to give out x, y of pixels
    vals = reshape(vals, 2, length);
    vals = vals';
  
    %append the data
    newData.contents = vals;
    plot(vals(:, 1), vals(:, 2));
    newData.class = classIndex;
    data = [data; newData;];
end

fclose(fileID);

allData = collectAllDataFromStruct(data);
plot(allData(:, 1), allData(:, 2));
    
end
