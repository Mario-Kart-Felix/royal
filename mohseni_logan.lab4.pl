% Logan Mohseni
% CSCI lab 4
% prolog
% note:  the following line failed to compile for me, so I had to load royal.pl
% by hand each time
consult('royal.pl').

%  M is a mother of C if she is parent of C, and if she is female
mother(M, C):- parent(M, C), female(M).
%  F is a father of C if he is parent of C, and if he is male
father(F, C):- parent(F, C), male(F).

% semicolon = or.  to make the relationship reflexive
% i.e, spouse(x, y) = spouse (y, x)
%  therefore 2 people are spouses if and only if they are married to each other.
%  really, it's just a matter of making the relationship undirected, or `or`ing 
%  together the 2 directed relationships
spouse(X, Z):- married(X, Z); married(Z, X).

%  X has a child Y if and only if Y has a parent X, but we need to protect against 
%  the reflective case
child(X, Y):- parent(Y, X), X\=Y.

%  narrowing case of `child`, but also taking into account gender
%  therefor Y is a son of X if he is a child of X, and if he is male
son(X, Y):- child(X, Y), male(Y).
daughter(X, Y):- child(X, Y), female(Y).

%  2 can be siblings if they share a parent, and are not themselves to eachother
sibling(X, Y):- child(X, P), child(Y, P), X\=Y.
%  specialization of sibling, but narrowing on gender
brother(X, Y):- sibling(X, Y), male(Y).
sister(X, Y):- sibling(X, Y), female(Y).

% blood case:
uncle(X, Y):- child(X, P), brother(Y, P).
% marriage case:
uncle(X, Y):- child(X, P), spouse(Y, P), male(Y).

%  Y has aunt X if and only if X has parent P, and Y is sister to P (which already
%  takes into account for gender, or Y is spouse to P
% blood case:
aunt(X, Y):- child(X, P), sister(Y, P).
% marriage case:
aunt(X, Y):- child(X, P), spouse(Y, P), female(Y).

% Y has a grand parent X if and only if P has a child X and Y has a child P. 
grandparent(X, Y):- child(X, P), child(P, Y).
%  Special case of grandparent, but this time, Y must be male
grandfather(X, Y):- child(X, P), child(P, Y), male(Y).
%  Special case of grandparent, but this time, Y must be female
grandmother(X, Y):- child(X, P), child(P, Y), female(Y).

grandchild(X, Y):- grandparent(Y, X).

%  CAUTION:  these functions reliably overflow the stack, but
%  not before giving a few alright relations.  Also `ancestor` likes to list siblings
%  as ancestors.  Basically they "work" like so:  Y has an ancestor X if X is one of
%  Y's  parents, or if one of Y's parents has X as an ancestor, so a recursive 
%  relationshxp%  However, this is what I think causes the overflow.  Since prolog
%  is already recursive, it just ends up evaluating this over and over agian, with 
%  no base case to escape to.  Maybe I could think up some sort of chain relationship
ancestor(X, Y):- child(X, P), child(P, Y); ancestor(Y, P), X\=Y, X\=sibling(X, Y).
%  descendant is just the inverse of ancestor.  However, neither function works.
descendant(X, Y):- ancestor(Y, X).

% X is older than Y if X was born in year A, Y was born in Year B, and if A is greate
% than B.  So you might ask yourself, why is the relationship backwards in the follow
% ing code?  The answer is I have no idea.  But you can't argue with results, and i'm
% pretty sure princess Di is not older than queen elizabeth the second.  :|.  
older(X, Y):- born(X, A), born(Y, B), A<B.
younger(X, Y):- born(X, A), born(Y, B), A>B.

%  If Y was born in year A, and regent X reigned from year M to year N, then if M is 
%  less than A, and if N is greater than A, (M<A<N), then person Y was born during
%  the reign of regent X.
regentWhenBorn(X, Y):- born(Y, A), reigned(X, M, N), M<A, N>A.

%  Cousins are like siblings, but with grandparents, instead of parents.
%  note each relationship is computed at most 4 times, since that is the maximum 
%  of grandparents a person can have.  Oh wait, I guess a person's siblings also share
%  grandparents.
cousin(X, Y):- grandparent(G, X), grandparent(G, Y), X\=Y.


