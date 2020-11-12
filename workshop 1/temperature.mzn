
% declare the start variable and the readings array
int: start;
array[int] of int: readings;

% declare a set of integers representing the length of the decision variables array
int: l = length(readings);
set of int: indexes0 = 0..l;
set of int: indexes = 1..l;

% declare the actions array (enum + 2 dimensions corresponding to the value of the temperature added and the cost)
enum actions = {heat, strongly_heat, cool, strongl_cool, do_nothing};
array[actions] of int: cost = [1, 5, 3, 9, 0];
array[actions] of int: value = [1, 4, -2, -5, 0];

% declare an array of choices
array[indexes] of var actions: choices;

% declare the array of decision variables based on the size of the array of readings + 1
array[indexes0] of var 25..30: temperature;

% add constraint that govern the way the temperatures evolve
constraint temperature[0] = start;
constraint forall (i in indexes) (temperature[i] = ((readings[i] + temperature[i-1]) div 2) + value[choices[i]]);

% declare the objective function
var int: obj = sum(i in indexes) (cost[choices[i]]);

% minimize the objective function
solve minimize obj;

output["temp = \(temperature) \nchoice = \(choices)\ncost = \(obj)"];
