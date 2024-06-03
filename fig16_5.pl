% Figure 16.5  A specification of the belief network of Fig. 15.10 as 
% expected by the program of Fig. 15.11.


% Belief network "sensor"

parent( burglary, sensor).    % Burglary tends to trigger sensor
parent( lightning, sensor).   % Strong lightning may trigger sensor
parent( sensor, alarm).
parent( sensor, call).

p( burglary, 0.001).
p( lightning, 0.02).
p( sensor, [ burglary, lightning], 0.9).
p( sensor, [ burglary, not lightning], 0.9).
p( sensor, [ not burglary, lightning], 0.1).
p( sensor, [ not burglary, not lightning], 0.001).
p( alarm, [ sensor], 0.95).
p( alarm, [ not sensor], 0.001).
p( call, [ sensor], 0.9).
p( call, [ not sensor], 0.0).
