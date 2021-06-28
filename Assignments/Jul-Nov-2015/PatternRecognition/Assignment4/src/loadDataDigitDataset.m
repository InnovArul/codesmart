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
%% @deftypefn {Function File} {@var{retval} =} loadDataDigitDataset (@var{input1}, @var{input2})
%%
%% @seealso{}
%% @end deftypefn

%% Author: Arulkumar <Arulkumar@MYVAIO>
%% Created: 2015-10-25

function [data, labels] = loadDataDigitDataset (input1, input2)
    dataSetPath = 'data/digit_data/';
    digits = {'four', 'five', 'three', 'six', 'zero'};
    
    data = containers.Map;
    
    for digit = digits
        currentPath = strcat(dataSetPath, digit);
        data(digit{:}) = loadDataFromDir(currentPath{:});
    end
end
