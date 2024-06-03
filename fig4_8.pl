% Figure 4.8    Solving cryptarithmetic puzzle 

%  			D O N A L D
%                     +	G E R A L D
%        		-----------
%       		R O B E R T

%  donald( Digits): Digits is a list of digits assigned to letters in the above puzzle

donald( [D,O,N,A,L,G,E,R,B,T])  :-				% All the letters in the puzzle
  assign( [0,1,2,3,4,5,6,7,8,9], [D,O,N,A,L,G,E,R,B,T]),	% Assign digits to letters
  100000*D + 10000*O + 1000*N +100*A + 10*L + D  +		% Number 1 plus
  100000*G + 10000*E + 1000*R + 100*A + 10*L + D  =:=	 	% Number 2 equals
  100000*R + 10000*O + 1000*B + 100*E + 10*R + T.		% Number 3

% assign( Digits, Vars):  Assign chosen distinct digits from list Digits to variables in list Vars

assign( _, [ ]).		% No variable to be assigned a digit

assign( Digs, [D | Vars])  :-	
  del( D, Digs, Digs1),		% Deleting D from list Digs gives Digs1
  assign( Digs1, Vars).		% Assign digits to remaining variables
