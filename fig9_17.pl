% Figure 9.17  Displaying a binary tree.


% show( Tree): display binary tree

show( Tree)  :-
  show2( Tree, 0).

% show2( Tree, Indent): display Tree indented by Indent

show2( nil, _).

show2( t( Left, X, Right), Indent)  :-
  Ind2 is Indent + 2,                 % Indentation of subtrees
  show2( Right, Ind2),                % Display right subtree
  tab( Indent), write( X), nl,        % Write root
  show2( Left, Ind2).                 % Display left subtree
