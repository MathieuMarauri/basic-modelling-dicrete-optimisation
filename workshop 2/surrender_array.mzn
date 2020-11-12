
% declare the input data variables -----

% the negotiators and the dummy one
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

% the minimium and maximum size of the party
int: l;
int: u;

% the minimum negotiation power
int: m;

% the honor array
array[NEGOTIATOR] of int: honor;

% the array of joint negotiation power
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

% declare the decision variable: an array of bool
array[1..u] of var NEGOTIATOR: party;

% constraint the array to represent unique sets of elements (execpt for the dummy negotiator)
constraint forall(i in 1..u-1) (party[i] >= party[i+1] + (party[i] != dummy));

% constraint that at least l negotiator are real (not dummy)
%constraint sum(i in 1..u) (party[i] != dummy) >= l;
constraint forall(i in 1..l) (party[i] != dummy); % more direct way of specifying the constraint

% constraint the total negotiation power to be more than m
constraint sum(i, j in 1..u where i < j) (joint[party[i], party[j]]) >= m;

% declare the objectve function
var int: obj = min(i in 1..u)(honor[party[i]] + (party[i] = dummy) * (max(honor) + 1)); % make sure that honor of dummy is not taken into account as for an array if u is too large then multiple dummy will be selected and then the obj will be 0.

% maximize the objective
solve maximize obj;

% format output
output["party = \(party)\nobj = \(obj)"]