% Logan Mohseni
% CSCI lab 4
% prolog
consult('royal.pl').

mother(M, C):- parent(M, C), female(M).
father(F, C):- parent(F, C), male(F).

spouse(X, Z):- married(X, Z); married(Z, X).

child(X, Y):- parent(Y, X).

son(X, Y):- child(X, Y), male(X).
daughter(X, Y):- child(X, Y), female(X).

sibling(X, Y):- child(X, P), child(Y, P), X\=Y.
brother(X, Y):- sibling(X, Y), male(Y).
sister(X, Y):- sibling(X, Y), female(Y).

% blood case:
uncle(X, Y):- child(X, P), brother(Y, P).
% marriage case:
uncle(X, Y):- child(X, P), spouse(Y, P), male(Y).


% blood case:
aunt(X, Y):- child(X, P), sister(Y, P).
% marriage case:
aunt(X, Y):- child(X, P), spouse(Y, P), female(Y).

grandparent(X, Y):- child(X, P), child(P, Y).
grandfather(X, Y):- child(X, P), child(P, Y), male(Y).
grandmother(X, Y):- child(X, P), child(P, Y), female(Y).

grandchild(X, Y):- grandparent(Y, X).
