%  Figure 4.16  Searching for paths between words and synsets in WordNet.

%  r0( Syn1, Syn2, rel( Rel, S1, S2) ):
%      Syn1 and Syn2 are in relation Rel, in direction from S1 to S2

r0( Syn1, Syn2, rel( Rel, S1, S2) )  :-
    ( S1 = Syn1, S2 = Syn2;   	% Choose first and second arg. of relation between Syn1 and Syn2
      S1 = Syn2, S2 = Syn1),      
    ( hyp( S1, S2), Rel = hyp;	% Check hyp relation
      mm( S1, S2), Rel = mm; 	% Check mm relation
      mp( S1, S2), Rel = mp	% Check mp relation
     ).

%  r( W1/T1/Sen1, W2/T2/Sen2, MaxLength, WordPath):
%     Sense Sen1 of word W1 of type T1 is related to sense Sen2 of word W2 of type T2
%     by a chain WordPath of basic relations given in WordNet; 
%     chain contains at most MaxLength relations
  
r( W1/T1/Sen1, W2/T2/Sen2, MaxLength, WordPath)  :-
   length( MaxList, MaxLength),		% MaxList is a general list of length MaxLength
   conc( SynPath, _, MaxList),     	% SynPath = list not longer than MaxLength
					% Shorter lists SynPath are tried first
   s( Syn1, _, W1, T1, Sen1, _),
   s( Syn2, _, W2, T2, Sen2, _),
   s_path( Syn1, Syn2, SynPath),
   word_path( SynPath, WordPath),
   mentioned( W1/T1/Sen1, WordPath),	% Word W1 mentioned in WordPath
   mentioned( W2/T2/Sen2, WordPath).	% Word W2 mentioned in WordPath

% s_path( Syn1, Syn2, Path):
%    Path connects synsets Syn1 and Syn2; Path is list of relationships rel( Rel, S1, S2) 

s_path( Syn, Syn, [ ]).			% Path from synset to itself

s_path( Syn1, Syn2, [Rel | L])  :-	
  s_path( Syn1, Syn, L),  	% Path from Syn1 to one-but-last synset Syn on the path
  r0( Syn, Syn2, Rel),		% Last step on the path: direct relation between Syn and Syn2
  \+ mentioned( Syn2, L).	% Syn2 is not mentioned in path L

%  word_path( SynList, WordList):
%     WordList is list of relationships between triples Word/Type/Sense 
%     that correspond to synsets in SynList

word_path( [], []).

word_path( [ rel(Rel,Syn1,Syn2) | SynRels], [ rel(Rel,W1/T1/Sen1,W2/T2/Sen2) | WordRels])  :-
   s( Syn1, _, W1, T1, Sen1, _),
   s( Syn2, _, W2, T2, Sen2, _),
   word_path( SynRels, WordRels).

% mentioned( X, RelationChain):  X is mentioned in list RelationChain as an argument of a relation 

mentioned( X, L)  :-
   member( Rel, L),
   ( Rel = rel( _, X, _); Rel = rel( _, _, X) ).

