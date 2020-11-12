
% declare the variables holding data
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umami, bland};
enum TEMP = {hot, cold, warm};

array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umami = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;

int: len;
set of int: COURSE = 1..len;

% declare the decision variables
array[COURSE] of var DISH: dish;

% no dish can be used more than once
include "alldifferent.mzn";
constraint alldifferent(dish);

% add constraint on the sequence of tastes
constraint forall (i in 1..len-1) (taste[dish[i]] != taste[dish[i+1]]);
constraint taste[dish[1]] = salty;
constraint taste[dish[len]] = sweet;
constraint forall (i in 1..len-1) (taste[dish[i]] = spicy -> taste[dish[i+1]] in {bland, sweet});
constraint forall (i in 1..len-1) (taste[dish[i]] = sour -> taste[dish[i+1]] in {bland, umami});
constraint forall (i in 1..len-1) (taste[dish[i]] = sweet -> (taste[dish[i+1]] != spicy /\ taste[dish[i+1]] != umami));

% add constraint on the sequence of temperatures
constraint forall (i in 1..len-1) 
                      ((temp[dish[i]] = hot -> 
                          forall (j in i+1..len) (temp[dish[j]] = cold -> exists(k in i+1..j-1) (temp[dish[k]] = warm))));

% add contraint on the sequence of heaviness
constraint forall (i in 1..len-2) (heavy[dish[i]] /\ heavy[dish[i+1]] -> not heavy[dish[i+2]]);

% declare the objective function
var int: obj = sum(i in COURSE) (value[dish[i]]) + sum(i in 1..len-1) (taste[dish[i]] != taste[dish[i+1]]) + sum(i in 1..len-1) (temp[dish[i]] != temp[dish[i+1]]) + sum(i in 1..len-1) (heavy[dish[i]] != heavy[dish[i+1]]);

% maximise objective
solve maximize obj;

output["dish = \(dish);\nobj = \(obj)"];