
% declare the enums containing the possible actions to select
enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

% declare the variable listed in the data file
int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
int: boredom;

% check that it is possible to stand the whole tie
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");

% check that stand, neutral and blank lead to 0 value
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");

% declare the decision variables
var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;

% add constraint on the sequence of possible legs moves
include "regular.mzn";
constraint regular(legs, 7, 6, l, 1, {2, 3, 4, 5, 6, 7});
array[1..7, LEGS] of 0..7: l = 
                    [| 2, 0, 4, 5, 6, 7
                     | 0, 0, 0, 5, 6, 7
                     | 2, 0, 4, 0, 0, 7
                     | 2, 0, 4, 0, 6, 7
                     | 2, 0, 4, 5, 0, 7
                     | 2, 3, 4, 0, 6, 7
                     | 2, 0, 4, 5, 6, 7 |];
constraint forall (i in 1..len-1) 
                      ((legs[i] = waltz -> 
                          forall (j in i+1..len) (legs[j] = curtsey -> exists(k in i+1..j-1) (legs[k] = stand))));

% add constraint on the sequence of possible arms moves
%constraint regular(arms, 6, 5, a, 1, {2, 3, 4, 5, 6});
%array[1..6, ARMS] of 0..6: a = 
%                    [| 0, 3, 4, 5, 6
%                     | 0, 3, 4, 5, 6
%                     | 2, 0, 4, 0, 6
%                     | 2, 3, 0, 0, 6 
%                     | 0, 3, 4, 0, 6
%                     | 0, 3, 4, 5, 6 |];
                     
constraint forall (i in 2..len) (arms[i] = beckon -> arms[i-1] in {out, up});
constraint arms[1] != beckon;
constraint forall (i in 2..len) (arms[i] = wrapped -> arms[i-1] in {beckon, neutral});
constraint forall (i in 1..len-1 where arms[i] != neutral) (arms[i] != arms[i+1]);

% add constraint on the sequence of possible facial gestures
constraint forall (i in 1..len-1 where face[i] != blank) (face[i] != face[i+1]);
constraint forall (i in 1..len-1) (face[i] in {smile, batt} -> face[i+1] != think);

% add constraint on the combination of moves
constraint forall (i in 1..len) (dance_value[legs[i], arms[i]] >= 0);
constraint forall (i in 1..len) (entice_value[arms[i], face[i]] >= 0);

% add constraint on the number of moves allowed
include "globals.mzn";
constraint global_cardinality_low_up(legs, LEGS, [0 | i in LEGS], maxlegs);
constraint global_cardinality_low_up(arms, ARMS, [0 | i in ARMS], maxarms);
constraint global_cardinality_low_up(face, FACE, [0 | i in FACE], maxface);


% add constraint that moves at steps higher than the len are stand, neutral and blank
constraint forall (i in STEP where i > len) (legs[i] = stand);
constraint forall (i in STEP where i > len) (arms[i] = neutral);
constraint forall (i in STEP where i > len) (face[i] = blank);

% declare the objective function
var int: obj = sum(i in 1..len) (dance_value[legs[i], arms[i]]) + sum(i in 1..len) (entice_value[arms[i], face[i]]) - boredom * len;

solve maximize obj;

output["len = \(len);\nlegs = \(legs);\narms = \(arms);\nface = \(face);\nobj = \(obj)"];




