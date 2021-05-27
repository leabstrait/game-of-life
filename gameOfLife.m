%% Yet Another simulation of Conway's Game of Life.
% ================================================
% Use as >>gameOfLife(grid_dimension, number_of_generations, simulation_delay, name_of_population)    
% This script runs the simulation of Game of Life. 
%     The universe of the Game of Life is an infinite two-dimensional orthogonal grid of square
% cells, each of which is in one of two possible states, alive or dead. Every cell interacts with 
% its eight neighbours, which are the cells that are horizontally, vertically, or diagonally 
% adjacent. At each step in time, the following transitions occur:
% 
%   #1  Any live cell with fewer than two live neighbours dies, as if caused by under-population.
%   #2  Any live cell with two or three live neighbours lives on to the next generation.
%   #3  Any live cell with more than three live neighbours dies, as if by overcrowding.
%   #4  Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
% 
% The initial pattern constitutes the seed of the system. The first generation is created by 
% applying the above rules simultaneously to every cell in the seed—births and deaths occur
% simultaneously, and the discrete moment at which this happens is sometimes called a tick 
% (in other words, each generation is a pure function of the preceding one). The rules continue
% to be applied repeatedly to create further generations.
%
% http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Rules     


function gameOfLife(gridSize, runGenerations, delay, name)

	% Default pattern to load
    if (isempty(name)) 
        name = 'gosper';
    end

    format bank;
  	% Initialize a sparse matrix of dimensions gridSize by gridSize
	M = sparse(gridSize, gridSize);
    origX = round(gridSize/2); 
    origY = round(gridSize/2);
           
	%Insert initial pattern
    [P, nameLife] = readPattern(name); 
    [offsetX, offsetY] = size(P);
    M([origX+1:(origX+offsetX)], [origY+1:(origY+offsetY)]) = P([1:end], [1:end]);

    % Big random initial patterns
    %M([origX+1:(origX+offsetX)], [origY+1:(origY+offsetY)]) = round(rand(offsetX, offsetY));
    %M(40:160 , 40:160) = (rand(121, 121) > .95);
    %nameLife = 'random';
   

	% Initialize variables 
    gen = 0; % generations counter
    counter = 0;
    alive = 0;
    fig = figure;
    fig.NumberTitle = 'off';
    fig.Name = ' Game of Life ';
      
    % Loop to generate life successions
    while (counter <= runGenerations)
        
        % Visualize the sparse matrix in a 2D grid with 1 and 0
        % representing different colours
        colormap(bone);
        pcolor(M);
        title(['Name of Pattern: ', nameLife ' | Generations: ', num2str(gen) ...
              ' | Cells: ', num2str(alive) ' | Density: ', num2str(alive*100/gridSize^2) '%']);
        drawnow;
        pause(delay);
        
        % Counting neighbours for each cell
        n = size(M, 1);
        offset1 = [2:n 1];       % The world  
        offset2 = [n 1:n-1];     % is continuous
%         offset1 = [1 1:n-1];       % The world  
%         offset2 = [2:n n];         % is bounded
		N = M(:, offset1) + M(:, offset2) + M(offset1, :) + M(offset2, :) + M(offset1, offset1) + M(offset2, offset2) + M(offset1, offset2) + M(offset2, offset1);

        % Elements in the map matrix 'M' is set to 1(i.e alive) only if sum
        % of neighbouring elements is either 2 or 3
        M = (M & (N == 2) | (N == 3)); 
        %Other custom rules?
        % The shorthand way for writing this "rule" is 2,3/3, meaning that a living
        % cell remains alive next generation if it has 2 or 3 neighbors, and a
        % non-living cell comes to life if it has exactly three neighbors. (Note:
        % this shorthand allows us to write many rules - e.g. 1,2,4/2,4, etc. But
        % only 2,3/3 is the "Conway life" rule, which is a subset of a large number
        % of "Cellular Automata" rules.)
        %M = ;

        % Counter variables
        counter = counter + 1;
        gen = gen + 1;
        alive = nnz(M);
    end 
    
    % Cleanup
    clear,clc;

end % gameOfLife
