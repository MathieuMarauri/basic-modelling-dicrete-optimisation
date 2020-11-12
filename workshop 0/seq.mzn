
% create a set of indexes used to create the array
int: n;
set of int: indexes = 1..n;

% declare the array of our variables
array[indexes] of var 0..3: x;

% first value is 0, last is 3
constraint x[1] = 0;
constraint x[n] = 3;

% sum of any two adjacent numbers is at most 3
constraint forall (i in 1..n-1) (x[i] + x[i+1] <= 3);

% all values at indexes divisible by 3 >= 2
constraint forall (i in indexes where i mod 3 = 0) (x[i] >= 2);

solve maximize sum(x);

output ["\(sum(x)) = \(x)"]