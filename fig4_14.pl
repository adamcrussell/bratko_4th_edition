% Figure 4.14   Program 3 for the eight queens problem.


% solution( Ylist): 
%   Ylist is a list of Y-coordinates of eight non-attacking queens

solution( Ylist)  :-   
  sol( Ylist,                                    % Y-coordinates of queens
       [1,2,3,4,5,6,7,8],                        % Domain for X-coordinates
       [1,2,3,4,5,6,7,8],                        % Domain for Y-coordinates
       [-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7],   % Upward diagonals
       [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16] ). % Downward diagonals 

sol( [], [], Dy, Du, Dv).

sol( [Y | Ylist], [X | Dx1], Dy, Du, Dv)  :-
  del( Y, Dy, Dy1),                 % Choose a Y-coordinate
  U is X-Y,                         % Corresponding upward diagonal
  del( U, Du, Du1),                 % Remove it
  V is X+Y,                         % Corresponding downward diagonal
  del( V, Dv, Dv1),                 % Remove it
  sol( Ylist, Dx1, Dy1, Du1, Dv1).  % Use remaining values 

del( Item, [Item | List], List).

del( Item, [First | List], [First | List1] )  :-
   del( Item, List, List1).

