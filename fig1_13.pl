% Figure 1.13: Map coloring

% Possible pairs of colors of neighbour countries

n( red, green).   	n( red, blue).        	n( red, yellow).
n( green, red).   	n( green, blue).     	n( green, yellow).
n( blue, red).     	n( blue, green).      	n( blue, yellow).
n( yellow, red).  	n( yellow, green).   	n( yellow, blue).

% Part of Europe (IT=Italy, SI=Slovenia, HR=Croatia,  CH=Switzerland, ...)

colors( IT, SI, HR, CH, AT, HU, DE, SK, CZ, PL, SEA)  :-
  SEA = blue,						% Adriatic sea has to be colored blue
  n( IT, CH), n( IT, AT), n( IT, SI), n( IT, SEA),   	% Italy and Switzerland are neighbours, etc.
  n( SI, AT), n( SI, HR), n( SI, HU), n( SI, SEA),
  n( HR, HU), n( HR, SEA),
  n( AT, CH), n( AT, DE), n( AT, HU), n( AT, SK), n( AT, CZ),
  n( CH, DE), 
  n( HU, SK),
  n( DE, SK), n( DE, CZ), n( DE, PL),
  n( SK, CZ), n( SK, PL),
  n( CZ, PL).

