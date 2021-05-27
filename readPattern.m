% DISCLAIMER
% Modified to fit our current purposes viz. The simulation of Conway's 
% Game of Life in agreement to the following licence: 
%
% Copyright (c) 2012, The MathWorks, Inc.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%
% All credits  to the Original Author of this function
% Cleve Moler
% MathWorks, Inc.
% See Cleve's Corner Blog, Game of Life
%   http://blogs.mathworks.com/cleve/2012/09/03/game-of-life 

function [P, patName] = readPattern(name)
% This function imports the specified population pattern from a file. 
	
	% Import patterns.txt 
	getFile = fopen('patterns.txt');
        if(getFile == -1)
            error('patterns.txt does not exist');
        end
   	
	% Search name in patterns.txt  
	name = [':' name];
    while (~feof(getFile))
      readLine = fgetl(getFile);
      if strncmpi(name, readLine, length(name))
         break
      end
    end
    if feof(getFile) 
      error(['Not found ' name(2:end) ', in patterns.txt.']) 
    end
   
    % Returns the name of pattern to the function call 
    nameEndIndex = find(readLine == ':', 2);
    patName = readLine(2:nameEndIndex(2)-1);
	
    % Patterns are specified using '*' and '.' characters and begin with a
    % TAB space. This segment sets the 'readLine' variable to the first
    % line of the pattern.
    tab = char(9);
    task = [tab '*'];
    tdot = [tab '.'];
    while (isempty(readLine) || (any(readLine(1:2) ~= task) && any(readLine(1:2) ~= tdot)))
      readLine = fgetl(getFile);
    end
    
	% Creates a sparse matrix of the pattern.
	S = sparse(0,0);
    rowCount = 0;
    while (~isempty(readLine) && (readLine(1) == tab))
      row = sparse(readLine(2:end) == '*');
      rowCount = rowCount + 1;
      colCount = length(row);
      S(rowCount, colCount) = 0;
      S(rowCount, 1:colCount) = row;
      readLine = fgetl(getFile);
    end
   
   % Make the sparse matrix a square one.
   [rowCount, colCount] = size(S);
   squareSide = max(rowCount, colCount);
   rowAdjust = floor((squareSide - rowCount) / 2);
   colAdjust = floor((squareSide - colCount) / 2);
   P = sparse(squareSide, squareSide);
   P(rowAdjust+1:rowAdjust+rowCount, colAdjust+1:colAdjust+colCount) = S;

   fclose(getFile);
end