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
%% @deftypefn {Function File} {@var{retval} =} dtw (@var{input1}, @var{input2})
%%
%% @seealso{}
%% @end deftypefn

%% Author: Arulkumar <aruls@cse.iitm.ac.in>
%% Created: 2015-10-25

function [distance] = dtw (object1, object2, windowsize)

len1 = size(object1, 1);
len2 = size(object2, 1);

%% take maximum of windowsize , object1 length - object2 length
windowsize = max(windowsize, abs(len1 - len2)); % adapt window size

%% initialization of the table
Buffer = zeros(len1+1, len2+1) + Inf; % cache matrix & set all elements to infinity

Buffer(1,1)=0; % set Buffer 0,0 to 0

%% begin dynamic programming
for i=1 : len1
    for j = max(i-windowsize, 1) : min(i + windowsize, len2)
        cost=norm(object1(i,:) - object2(j,:));
        Buffer(i+1,j+1) = cost + min( [Buffer(i,j+1), Buffer(i+1,j), Buffer(i,j)] );
       
    end
end

distance = Buffer(len1+1, len2+1); 

end
