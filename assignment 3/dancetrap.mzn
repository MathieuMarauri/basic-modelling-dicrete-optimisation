
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
constraint forall (i in 2..len) (legs[i] = leap -> legs[i-1] = prep);
constraint legs[1] != leap;
constraint forall (i in 1..len-1) (legs[i] = spin -> legs[i+1] in {curtsey, prep, stand});
constraint forall (i in 1..len-1) (legs[i] = leap -> legs[i+1] in {spin, waltz, stand});
constraint forall (i in 1..len-3) (legs[i] = waltz /\ legs[i+1] = waltz /\ legs[i+2] = waltz -> legs[i+3] != waltz);
constraint forall (i in 1..len-1) (legs[i] = curtsey -> legs[i+1] != prep);
constraint forall (i in 1..len-1) 
                      ((legs[i] = waltz -> 
                          forall (j in i+1..len) (legs[j] = curtsey -> exists(k in i+1..j-1) (legs[k] = stand))));

% add constraint on the sequence of possible arms moves
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
constraint forall (leg in LEGS) (sum(i in 1..len) (legs[i] = leg) <= maxlegs[leg]);
constraint forall (arm in ARMS) (sum(i in 1..len) (arms[i] = arm) <= maxarms[arm]);
constraint forall (faces in FACE) (sum(i in 1..len) (face[i] = faces) <= maxface[faces]);

% add constraint that moves at steps higher than the len are stand, neutral and blank
constraint forall (i in STEP where i > len) (legs[i] = stand);
constraint forall (i in STEP where i > len) (arms[i] = neutral);
constraint forall (i in STEP where i > len) (face[i] = blank);

% declare the objective function
var int: obj = sum(i in 1..len) (dance_value[legs[i], arms[i]]) + sum(i in 1..len) (entice_value[arms[i], face[i]]) - boredom * len;

solve maximize obj;

output["len = \(len);\nlegs = \(legs);\narms = \(arms);\nface = \(face);\nobj = \(obj)"];




