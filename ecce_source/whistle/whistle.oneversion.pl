:- module('whistle.oneversion',['whistle.oneversion:whistle'/4]).

% WARNING: do not use when perform parent abstraction is set to no !!

:- use_package( .('../ecce_no_rt2') ).

%:- dynamic whistle/4.

:- set_prolog_flag(multi_arity_warnings,off).
%:- set_prolog_flag(discontiguous_warnings,off).
:- set_prolog_flag(single_var_warnings,off).

:- use_module('../bimtools').
:- use_module('../global_tree').
:- use_module('../homeomorphic').
:- use_module('../calc_chtree').


'whistle.oneversion:whistle'(GoalID,Goal,Chtree,WhistlGoalID) :-
	/* print(call_whistle(GoalID,Goal)),nl, */
	(Chtree\=empty),
	gt_node_descends_from(GoalID,ParID,_LeafLocalID),
	'whistle.oneversion:find_growing_among_ancestors'(ParID,Goal,Chtree,WhistlGoalID),
	debug_print(blow_whistle(WhistlGoalID)),debug_nl.


'whistle.oneversion:find_growing_among_ancestors'(ParID,Goal,Chtree,ParID) :-
	gt_node_pe_status(ParID,pe(ImpStat)),
		/* only test with non-abstracted ancestors */
	gt_node_goal(ParID,ParGoal),
	pp_cll(msg_can_be_taken(Goal,ParGoal)).
'whistle.oneversion:find_growing_among_ancestors'(ParID,Goal,Chtree,WhistlGoalID) :-
	gt_node_descends_from(ParID,ParID2,_LeafLocalID),
	'whistle.oneversion:find_growing_among_ancestors'(ParID2,Goal,Chtree,WhistlGoalID).
	
