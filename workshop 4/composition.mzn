
% declare the variable used in the data
int: n;

% declare the list of notes and positions
set of int: NOTES = 1..n;
set of int: POS = 1..n;

% declare the decision variables
array[NOTES] of var POS: pos;
array[POS] of var NOTES: order;

% contraint that the 2 viewpoints are the same 
include "globals.mzn";
constraint inverse(pos, order);

% declare the variable difference that keep track of the difference between adjacent notes
array[1..n-1] of var int: differences = [abs(order[i] - order[i+1]) | i in 1..n-1];

% constraint that the differences are all different
constraint alldifferent(differences);

% find a solution to the problem
solve satisfy;

output["order = \(order);\ndifferences = \(differences);\npositions = \(pos)"];
