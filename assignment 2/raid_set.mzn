
% declare the input variables: the warriors enum, the dummy warrior, the clans enum
enum WARRIOR;
WARRIOR: dummy;
enum CLAN;

% declare the input variables: the minimum and maximum number of warriors to select and the maximum number of pairs of warriors from clans that hate each other.
int: l;
int: u;
int: m;

% declare the input variables: the strengh and the clan of each warrior
array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

% declare the input variable: the array specifying who hates who
array[CLAN,CLAN] of 0..1: hates;

% declare the decision variables that is the set of warriors to select
var set of WARRIOR: x;

% constraint this set to be of cardinality less than u and higher than l
constraint card(x) >= l;
constraint card(x) <= u;

% constraint the number of pairs with hate to be lower than m
constraint sum(i,j in x where i < j) (hates[clan[i], clan[j]]) <= m;

% declare the objective function
var int: obj = sum(i in x) (strength[i]);

% maximize the objective
solve maximize obj;

% output the result
output["raid = \(x);\nobj = \(obj)"];

