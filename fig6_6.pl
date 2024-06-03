% Figure 6.6  A procedure to transform a sentence into a list of atoms.

/*
  Procedure getsentence reads in a sentence and combines the words 
  into a list of atoms. For example

    getsentence( Wordlist)

  produces

    Wordlist = [ 'Mary', was, pleased, to, see, the, robot, fail]

  if the input sentence is:

    Mary was pleased to see the robot fail.
*/

getsentence( Wordlist)  :-
  get0( Char),
  getrest( Char, Wordlist).

getrest( 46, [] )  :-  !.         	    % End of sentence: 46 = ASCII for '.'

getrest( 32, Wordlist)  :-  !,   	    % 32 = ASCII for blank   
  getsentence( Wordlist).        	    % Skip the blank 

getrest( Letter, [Word | Wordlist] )  :-
  getletters( Letter, Letters, Nextchar),   % Read letters of current word
  name( Word, Letters),
  getrest( Nextchar, Wordlist).

getletters( 46, [], 46)  :-  !.      	    % End of word: 46 = full stop 

getletters( 32, [], 32)  :-  !.      	    % End of word: 32 = blank 

getletters( Let, [Let | Letters], Nextchar)  :-
   get0( Char),
   getletters( Char, Letters, Nextchar).


