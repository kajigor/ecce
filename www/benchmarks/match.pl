/* A naive pattern matcher */

match(Pat,T) :- match1(Pat,T,Pat,T).