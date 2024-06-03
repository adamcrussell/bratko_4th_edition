% Figure 4.6  A CLP(FD) program for eight queens

solution( Ys)  :-             	% Ys is list of Y-coordinates of queens
  Ys = [ _, _, _, _, _, _, _, _],     	% There are 8 queens
  domain( Ys, 1, 8),         	 % All the coordinates have domains 1..8
  all_different( Ys),       		  % All different to avoid horizontal attacks
  safe( Ys),                 		 % Constrain to prevent diagonal attacks
  labeling( [], Ys).         		 % Find concrete values for Ys

safe( []).

safe( [Y | Ys])  :-
  no_attack( Y, Ys, 1),      	 % 1 = horizontal distance between queen Y and Ys
  safe( Ys).

% no_attack( Y, Ys, D):
%   queen at Y doesn't attack any queen at Ys; 
%   D is column distance between first queen and other queens

no_attack( Y, [], _).

no_attack( Y1, [Y2 | Ys], D)  :-
  D #\= Y1-Y2,
  D #\= Y2-Y1,
  D1 is D+1,
  no_attack( Y1, Ys, D1).



