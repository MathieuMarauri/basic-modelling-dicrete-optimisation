
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
array[NEGOTIATOR, NEGOTIATOR] of int: joint;

% declare the decision variable: the set of negotiator to chose
var set of NEGOTIATOR: party;

% declare the objective variable which is the minimum value of honor
var opt int: obj = min([honor[i] | i in party]);

% constraint the number of negotiators to be between l and u
constraint card(party) <= u;
constraint card(party) >= l;

% constraint the total negotiation power to be at least m
constraint sum(i, j in party where i < j) (joint[i, j]) >= m;

% maximize the objective function
solve maximize obj;

% format output
output["party = \(party)\nobj = \(obj)"];