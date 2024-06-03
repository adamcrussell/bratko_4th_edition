% Figure  13.10   An implementation of RTA*. 
% To change the depth limit for lookahead after the program has been consulted, 
% lookahead_depth/1 has first to be retracted, and then a new definition asserted.


% Real-time A*

% rta( StartNode, SolutionPath)

rta( StartNode, [StartNode | Rest])  :-
  retractall( visited( _, _)),		% Retract all previously stored visited nodes
  rta( [StartNode | Rest]).		% Perform RTA* search to find a solution path

% rta( [Node | Rest]):  find a solution path from Node to a goal state

rta( [ Node])  :-
  goal( Node).

rta( [ Node, BestSucc | Rest])  :-
  setof( F/Cost/Succ, 
         H^( s( Node, Succ, Cost), h( Succ, H), F is Cost + H),
         SuccList),   	% Successor nodes ordered according to shallow F
  best( SuccList, none, 999999, 999999, _/C/BestSucc, SecondBestF),
  DeepH is C + SecondBestF,   	
  update_visited( Node, DeepH),		% Store Node’s second best f value
  rta( [BestSucc | Rest]).

% best( NodeList, BestSoFar, BestFsoFar, SecondBestFsoFar, BestNode, SecondBestF):
%   BestNode is the best node among NodeList according to fixed`depth lookahed

best( [], BestSoFar, _, SecondBestF, BestSoFar, SecondBestF)  :-  !.

best( [Node | Nodes], BestSoFar, BestFsoFar, SecondBestFsoFar, BestNode,  SecondBestF)  :-
  lookahead_depth( D),
  lookahead( Node, DeepF, D, SecondBestFsoFar),    % Obtain "deep" F by D-move lookahead
  (
    DeepF < BestFsoFar, !,           		% New best
    best( Nodes, Node, DeepF, BestFsoFar, BestNode, SecondBestF)
    ;
    DeepF < SecondBestFsoFar, !,     	% New second best
    best( Nodes, BestSoFar, BestFsoFar, DeepF, BestNode, SecondBestF)
    ;
    best( Nodes, BestSoFar, BestFsoFar, SecondBestFsoFar, BestNode, SecondBestF)
  ).

update_visited( Node, DeepH)  :-	% DeepH is Node’s heuristic value for next encounter
  retractall( visited( Node, _)),    	% Retract previous value if any
  asserta( visited( Node, DeepH)).

%  lookahead( ShallowF/G/Node, DeepF, LookaheadDepth, Bound)
%    DeepF is Node's F-value after lookahead to LookaheadDepth
%    In case of monotonic F, alpha-pruning is possible when current F >= Bound
%    Alpha-pruning is not implemented in this version

lookahead( ShallowF/G/Node, DeepF, LookaheadDepth, Bound)  :-
  asserta( bestF( Bound)),    	% We have to improve on Bound else alpha-prune
  lookahead( ShallowF/G/Node, LookaheadDepth),
  retract( bestF( DeepF)).

lookahead( _/G/Node, D)  :-
  (
    goal( Node), !, DeepF = G                       			 % Goal node
    ;
    visited( Node, DeepH), !, DeepF is G + DeepH     	% Already visited
    ;
    D = 0, !, h( Node, H), DeepF is G + H           		 % Lookahead depth reached
  ),
  update_bestF( DeepF).	

lookahead( _/G/Node, D)  :-    		    % Here lookahead depth not yet reached
  s( Node, ChildNode, Cost),
  G1 is G + Cost,
  h( ChildNode, H1), F1 is G1 + H1,
  bestF( Bound), F1 < Bound,       	% Child's F must be lower than Bound, else alpha-prune
  D1 is D - 1,
  lookahead( _/G1/ChildNode, D1),
  fail                                 		% Look at other successor nodes
  ;
  true.   

update_bestF( F)  :-
  bestF( BestFsoFar),
  BestFsoFar =< F, !         	 % Do not change best F
  ;   
  retract( bestF( _)), !,
  asserta( bestF( F)).     	   % Update best F
  
% lookahead_depth( SearchDepthLimit): lookahead depth, to be set by user

:- asserta( lookahead_depth( 1)).		% Depth limit for lookahead set to 1, for example

