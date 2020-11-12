
% declare the variables defined in the data file
% variable related to the court members: number, the emperor and their rank and ability
int: n;
set of int: COURT = 1..n;
int: emperor = 1;

array[COURT] of int: rank;
array[COURT] of int: ability;

% variable related to the horses: number and their beauty and speed
int: m;
set of int: HORSE = 1..m;

array[HORSE] of int: beauty;
array[HORSE] of int: speed;

% variable giving the enjoyness of the combination horse/court member
array[COURT, HORSE] of int: enjoy;

% define a dummy value
int: dummy = 0;

% add "no horse" and "no rider" to the set of horses and riders
set of int: HORSE0 = 0..m;
set of int: COURT0 = 0..n;

% declare the decision variable
array[COURT] of var HORSE0: horse;
array[HORSE] of var COURT0: rider;

% link the 2 viewpoints
constraint forall (r in COURT, h in HORSE) (horse[r] = h <-> rider[h] = r);

% every horses and riders must all be different (except the 0)
include "alldifferent_except_0.mzn";
constraint alldifferent_except_0(horse);

% each rider has an horse if m >= n, each horse is used if n >= m
constraint (sum(r in COURT) (horse[r] > 0) = min(n, m));

% some court members cannot be on certain horses
constraint forall (h in HORSE where rider[h] != dummy) (enjoy[rider[h], h] >= 0);

% higher rank court members should have a more beautiful horse if possible
constraint forall (r, s in COURT where rank[r] > rank[s]) (beauty[horse[r]] >= beauty[horse[s]] \/ horse[s] = dummy);

% the emperor enjoys the day the most
constraint forall (r in 2..n where horse[r] != dummy) (enjoy[r, horse[r]] < enjoy[emperor, horse[emperor]]);

% declare the objective function
var int: obj = sum(h in HORSE where rider[h] != dummy) (enjoy[rider[h], h]) - 100 * violations;

% define the violations as constraint on the agility not fullfilled 
var int: violations = sum(h, i in HORSE) (speed[h] > speed[i] /\ (not(ability[rider[h]] >= ability[rider[i]] \/ rider[h] = dummy)));

% maximize the objective function
solve maximize obj;

output["horse = \(horse);\nobj = \(obj)"];