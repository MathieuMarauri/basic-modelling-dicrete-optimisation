
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
array[1..u] of var WARRIOR: raid;

% constraint the array to represent unique sets of elements (execpt for the dummy negotiator)
constraint forall(i in 1..u-1) (raid[i] >= raid[i+1] + (raid[i] != dummy));

% constraint that at least l warrior are real (not dummy)
constraint forall(i in 1..l) (raid[i] != dummy);

% constraint the number of pairs with hate to be lower than m
constraint sum(i,j in 1..u where i < j) (hates[clan[raid[i]], clan[raid[j]]]) <= m;

% declare the objective function
var int: obj = sum(i in 1..u) (strength[raid[i]]);

% maximize the objective
solve maximize obj;

% output the result
output["raid = {"] ++ [if fix(raid[i]) != dummy then show(raid[i]) ++ if i < u /\ fix(raid[i+1]) != dummy then ", " else "" endif
else "" endif | i in 1..u ] ++ ["};\nobj = \(obj);"];