% Figure 15.12  Some frames.


% A frame is represented as a set of Prolog facts:
%    frame_name( Slot, Value)
% where Value is either a simple value or a procedure

% Frame bird: the prototypical bird

bird( a_kind_of, animal).
bird( moving_method, fly).
bird( active_at, daylight).

% Frame albatross: albatross is a typical bird with some
% extra facts: it is black and white, and it is 115 cm long

albatross( a_kind_of, bird).
albatross( colour, black_and_white).
albatross( size, 115).

% Frame kiwi: kiwi is a rather untypical bird in that it
% walks instead of flies, and it is active at night

kiwi( a_kind_of, bird).
kiwi( moving_method, walk).
kiwi( active_at, night).
kiwi( size, 40).
kiwi( colour, brown).

% Frame albert: an instance of a big albatross

albert( instance_of, albatross).
albert( size, 120).

% Frame ross: an instance of a baby albatross

ross( instance_of, albatross).
ross( size, 40).

% Frame animal: slot relative_size obtains its value by
% executing procedure relative_size

animal( relative_size, execute( relative_size( Object, Value), Object, Value) ).

