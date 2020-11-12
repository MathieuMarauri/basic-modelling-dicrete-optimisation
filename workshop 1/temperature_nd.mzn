
% declare the start variable and the readings array
int: start;
array[int] of int: readings;

% declare a set of integers representing the length of the decision variables array
int: l = length(readings);
set of int: indexes = 0..l;

% declare the array of decision variables based on the size of the array of readings + 1
array[indexes] of var int: x;

% add constraint that govern the way the temperatures evolve
constraint x[0] = start;
constraint forall (i in 1..l) (x[i] = ((readings[i] + x[i-1]) div 2));

solve satisfy;

output["temp=\(x)"];