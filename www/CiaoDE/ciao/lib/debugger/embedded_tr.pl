:- module(embedded_tr, [
	                srcdbg_expand/4,
			srcdbg_no_expand/4,
			srcdbg_expand_decl/3,
			srcdbg_no_expand_decl/3
		       ], [assertions]).

:- use_module(library('compiler/c_itf'), [location/3]).
:- use_module(library(lists),[delete/3,length/2]).
:- use_module(library(sets),[insert/3]).
:- use_module(library(write),[printable_char/1]).
:- use_module(library('debugger/debugger_lib'),[functor_spec/5]).

:- pred srcdbg_expand/5 # "This is the expansion needed to perform
   source-level debugging.".
% for debug and trace
srcdbg_expand_decl((:- IsDecl), (:- initialization(spy(Arg))), _Mod):- 
	functor(IsDecl, Decl, 1),
	Decl=spy, !,
	arg(1, IsDecl, Arg).
%for nodebug
srcdbg_no_expand_decl((:- IsDecl), [], _Mod):- !,
	functor(IsDecl, Decl, 1),
	Decl=spy, !.

% for debug and trace
srcdbg_expand(clause(Head, Old_B), clause(Head, New_B), _Mod, Dict) :-
   srcdbg_expand1(clause(Head, Old_B), clause(Head, New_B), expand, Dict).

% for nodebug
srcdbg_no_expand(clause(Head, Old_B), clause(Head, New_B), _Mod, Dict) :-
   srcdbg_expand1(clause(Head, Old_B), clause(Head, New_B), noexpand, Dict).

srcdbg_expand1(clause(Head, Old_B), clause(Head, New_B), Expand, Dict) :-
	location(Src, L0, L1),
	search_head(Head, Xs, Dict),
	srcdbg_expand_(Old_B, New_B, Src, L0, L1, Xs, _Zs, Expand, Dict).

srcdbg_expand_(','(A,B), ','(NewA, NewB), Src, L0, L1, Xs, Zs, Expand, Dict):- 
	!,
	srcdbg_expand_(A, NewA, Src, L0, L1, Xs, Ys, Expand, Dict),
	srcdbg_expand_(B, NewB, Src, L0, L1, Ys, Zs, Expand, Dict).
srcdbg_expand_('->'(A,B), '->'(NewA, NewB), Src, L0, L1, Xs, Zs, Expand, Dict)
	:- !,
	srcdbg_expand_(A, NewA, Src, L0, L1, Xs, Ys, Expand, Dict),
	add_pred_to_list('->',Ys,Ks),
	srcdbg_expand_(B, NewB, Src, L0, L1, Ks, Zs, Expand, Dict).
srcdbg_expand_(';'(A,B), ';'(NewA, NewB), Src, L0, L1, Xs, Zs, Expand, Dict):- 
	!,
	srcdbg_expand_(A, NewA, Src, L0, L1, Xs, Ys, Expand, Dict),
	srcdbg_expand_(B, NewB, Src, L0, L1, Ys, Zs, Expand, Dict).
srcdbg_expand_(if(A, B, C), if(NewA, NewB, NewC), Src, L0, L1, Xs, Ks, 
	       Expand, Dict):- 
	!,
	add_pred_to_list('if',Xs,Ts),
	srcdbg_expand_(A, NewA, Src, L0, L1, Ts, Ys, Expand, Dict),
	srcdbg_expand_(B, NewB, Src, L0, L1, Ys, Zs, Expand, Dict),
	srcdbg_expand_(C, NewC, Src, L0, L1, Zs, Ks, Expand, Dict).
srcdbg_expand_(\+(A), \+(NewA), Src ,L0, L1, Xs, Ys, Expand, Dict):- 
	!,
	srcdbg_expand_(A, NewA, Src, L0, L1, Xs, Ys, Expand, Dict).
srcdbg_expand_(!, !, _, _, _, Xs, Xs, _, _):- !. 
srcdbg_expand_(true, true, _, _, _, Xs, Ys, _, _):- 
	add_pred_to_list(true, Xs, Ys), !.
srcdbg_expand_(debug, debug, _, _, _, Xs, Ys, _, _):- 
	add_pred_to_list(debug, Xs, Ys), !.
srcdbg_expand_(trace, trace, _, _, _, Xs, Ys, _, _):- 
	add_pred_to_list(trace, Xs, Ys), !.
srcdbg_expand_(nodebug, nodebug, _, _, _, Xs, Ys, _, _):- 
	add_pred_to_list(nodebug, Xs, Ys), !.
srcdbg_expand_(notrace, notrace, _, _, _, Xs, Ys, _, _):-
	add_pred_to_list(notrace, Xs, Ys), !.
srcdbg_expand_(spy(X), debugger_lib:spy(X), _, _, _, Xs, Ys, expand, _):- 
	add_pred_to_list(spy, Xs, Ks),
	add_spy_pred_to_list(X, Ks, Ys), !.
srcdbg_expand_(spy(_X), true, _, _, _, Xs, Xs, noexpand, _):- !.
srcdbg_expand_(nospy(X), nospy(X), _, _, _, Xs, Ys, expand, _):- 
	add_pred_to_list(nospy, Xs, Zs),
	add_spy_pred_to_list(X, Zs, Ys), !.
srcdbg_expand_(nospy(_X), true, _, _, _, Xs, Xs, noexpand, _):- !.
srcdbg_expand_(nospyall, nospyall, _, _, _, Xs, Ys, _, _):- 
	add_pred_to_list(nospyall, Xs, Ys), !.
srcdbg_expand_(this_module(X), this_module(X), _, _, _, Xs, Xs, _, _):- !.
srcdbg_expand_(debug_module(X), debug_module(X), _, _, _, Xs, Xs, _, _):- !.
srcdbg_expand_(Goal, srcdbg_byrd(Goal, Pred, Src, L0, L1, Number), 
	       Src, L0, L1, Xs, Zs, expand, Dict):- 
	!,
	functor(Goal, Pred, Arity),
	add_pred_to_list(Pred, Xs, Ks),
	get_pred_number(Pred, Ks, Number),
	search_args(1, Ks, Goal, Arity, Zs, Dict).
srcdbg_expand_(Goal, Goal, _Src, _L0, _L1, _Xs, _Zs, noexpand, _Dict):- !.

%% search_head: Add pred to the list and all arguments
search_head(Goal, Xs, Dict):-
	functor(Goal, Pred, Arity),
	search_args(1, [pred(Pred, 1)], Goal, Arity, Xs, Dict).

%% search_args: Search the whole list of arguments. It calls 
%% search_arg which add individual arguments to the list of strings
search_args(_Number, Xs, _Goal, 0, Xs, _Dict):- !.
search_args(Number, Xs, Goal, Number, Ys, Dict):-
	!,
	arg(Number, Goal, Arg),
	search_arg(Arg, Xs, Ys, Dict).
search_args(Number, Xs, Goal, Arity, Ys, Dict):-
	!,
	arg(Number, Goal, Arg),
	search_arg(Arg, Xs, Zs, Dict),
	Next_arg is Number+1,
	search_args(Next_arg, Zs, Goal, Arity, Ys, Dict).

%% search_arg: Add argument to the list. 
% Variables
search_arg(Arg, Xs, Ys, Dict):- 
	var(Arg), !,
        nonvar(Dict),
 	name_var_realname(Dict, Arg, RealName),
 	add_pred_to_list(RealName, Xs, Ys).
% Strings
search_arg([X|Xs], Ys, Zs, _Dict):- 
	is_string([X|Xs]), !,
	atom_codes(Word, [X|Xs]),
	add_pred_to_list(Word, Ys, Zs).
% Lists
search_arg(.(X,Y), Ys, Zs, Dict):-
	!, 
	search_arg(X, Ys, Ks, Dict),
	search_arg(Y, Ks, Zs, Dict).
% Empty list
search_arg([], Xs, Xs, _Dict):- !.
% Numbers
search_arg(Arg, Xs, Xs, _Dict):- number(Arg).
% Atoms
search_arg(Arg, Xs, Ys, _):-
	nonvar(Arg),
	atom(Arg),
	add_pred_to_list(Arg, Xs, Ys).
% Preds
search_arg(Arg, Xs, Ys, Dict):-
	functor(Arg, Pred, Arity),
	Arity > 0,
	add_pred_to_list(Pred, Xs, Zs),
	search_args(1, Zs, Arg, Arity, Ys, Dict).

%% name_var_realname
name_var_realname([], _Var, '_'):- !.
name_var_realname([Name=Var|_Rest], TheVar, Name):- 
	TheVar==Var,!.
name_var_realname([_|Xs], TheVar, Name):- 
	name_var_realname(Xs, TheVar, Name).

%% Add_pred_to_list
add_pred_to_list(Pred, Xs, Ys):-
	(member(pred(Pred, OldNumber), Xs) ->
	    delete(Xs, pred(Pred, OldNumber), Zs),
	    NewNumber is OldNumber+1,
	    insert(Zs, pred(Pred, NewNumber), Ys)
	;
	    insert(Xs, pred(Pred,1), Ys)
	).

%% add_spy_pred_to_list
add_spy_pred_to_list(Arg, Xs, Ys):-
	functor_spec(Arg, Name, _, _, _),
	add_pred_to_list(Name, Xs, Ys).

% Used when searching in emacs for subexpressions. Not the whole word
get_pred_number(_, [], 0).
get_pred_number(Word, [pred(Pred, Number)|Xs], Occur_Number):-
	count_suffix(Word, Pred, Suffix_Number),
	Count_Number is Number * Suffix_Number,
	get_pred_number(Word, Xs, Rest_Number),
	Occur_Number is Count_Number + Rest_Number.
	
%count_suffix
count_suffix(Word, Pred, Number):-
	atom_codes(Word, WordList),
	atom_codes(Pred, PredList),
	find_sublist(WordList, PredList, Number, WordList).

% find_sublist/4
% Arguments: 
%  1.- Word to search
%  2.- List where search for the word.
%  3.- Number of times the word was found.
%  4.- The whole word for recursive search.
find_sublist(_, [], 0, _):-!.
find_sublist(WordList, PredList, 0, _):-
	length(WordList, WordNumber),
	length(PredList, PredNumber),
	WordNumber > PredNumber,!.
find_sublist([], Ys, Number, Word):-
	find_sublist(Word, Ys, NewNumber, Word),!,
	Number is NewNumber + 1.
find_sublist([X|Xs], [X|Ys], NewNumber, Word):-
	find_sublist_(Xs, Ys, Number, Rest),!,
	find_sublist(Word, Rest, Rest_Number, Word),
	NewNumber is Number+Rest_Number.
find_sublist([X|Xs],[_|Ys],Number,Word):-
	find_sublist([X|Xs], Ys, Number, Word),!.

find_sublist_([], Ys, 1, Ys):-!.
find_sublist_([X|Xs], [X|Ys], Number, Zs):-
	find_sublist_(Xs, Ys, Number, Zs),!.

%is string
is_string([X]):-printable_char(X).
is_string([X|Xs]):-
	printable_char(X),
	is_string(Xs).
