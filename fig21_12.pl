% Figure 21.12  Learning the concept of arch.


% Learning about arch

backliteral( isa(X,Y), [X:object], [])  :-
  member( Y, [polygon,convex_poly,stable_poly,unstable_poly,triangle,
              rectangle, trapezium, unstable_triangle, hexagon]).      % Y is any figure

backliteral( support(X,Y), [X:object, Y:object], []).
backliteral( touch(X,Y), [X:object, Y:object], []).
backliteral( \+(G), [X:object,Y:object], [])  :-
  G = touch(X,Y); G = support(X,Y).

prolog_predicate( isa(X,Y)).
prolog_predicate( support(X,Y)).
prolog_predicate( touch(X,Y)).
prolog_predicate( \+(G)).

ako( polygon, convex_poly).         % Convex polygon is a kind of polygon
ako( convex_poly, stable_poly).     % Stable polygon is a kind of convex polygon
ako( convex_poly, unstable_poly).   % Unstable polygon is a kind of convex poly.
ako( stable_poly, triangle).        % Triangle is a kind of stable polygon
ako( stable_poly, rectangle).       % Rectangle is a kind of stable polygon
ako( stable_poly, trapezium).       % Trapezium is a kind of stable polygon
ako( unstable_poly, unstable_triangle).  % Unstable triangle is a.k.o. unstable poly.
ako( unstable_poly, hexagon).            % Hexagon is a kind of unstable polygon

ako( rectangle, X)  :-
  member( X, [a1,a2,a3,a4,a5,b1,b2,b3,b4,b5,c1,c2,c3]).    % All rectangles

ako( triangle, c4).                % Stable triangle
ako( unstable_triangle, c5).       % Triangle upside down

isa( Figure1, Figure2)  :-         % Figure1 is a Figure2
  ako( Figure2, Figure1).

isa( Fig0, Fig) :-
  ako( Fig1, Fig0),
  isa( Fig1, Fig).

support(a1,c1).    support(b1,c1).
support(a3,c3).    support(b3,c3).   touch(a3,b3).      
support(a4,c4).    support(b4,c4).
support(a5,c5).    support(b5,c5).

start_clause( [ arch(X,Y,Z)] / [X:object,Y:object,Z:object]).

ex( arch(a1,b1,c1)).
ex( arch(a4,b4,c4)).

nex( arch(a2,b2,c2)).
nex( arch(a3,b3,c3)).
nex( arch(a5,b5,c5)).
nex( arch(a1,b2,c1)). 
nex( arch(a2,b1,c1)).        
