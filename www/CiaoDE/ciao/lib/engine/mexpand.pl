% This code is included in builtin.pl and in compiler.pl.
% It uses the following facts (defined either in builtin or in compiler):
%  imports/5    - MODULE imports from MODULE2 F/A, which resides in ENDMODULE
%  meta_args/2  - MODULE has meta declaration META
%  multifile/3  - MODULE defines multifile F/A
%  defines/3    - MODULE defines F/A
%  goal_trans/2 - MODULE defines goal translation G

% Called from c_itf

:- use_module(engine(hiord_rt), ['$meta_call'/1]).

% EXPORTED
body_expansion(V, M, QM, NA) :- var(V), !,
        body_expansion(hiord_rt:call(V), M, QM, NA).
body_expansion(QM:G, M, QM0, NG) :- !,
        ( atom(QM) ->
            body_expansion(G, M, QM, NG)
        ; body_expansion(hiord_rt:call(QM:G), M, QM0, NG)
        ).
body_expansion((A,B), M, QM, (NA,NB)):- ciaopp_expansion, !,
	body_expansion(A, M, QM, NA),
	body_expansion(B, M, QM, NB).
body_expansion((A;B),M,QM,(NA;NB)):- ciaopp_expansion, !,
	body_expansion(A,M,QM,NA),
	body_expansion(B,M,QM,NB).
body_expansion((A->B),M,QM,(NA->NB)):- ciaopp_expansion, !,
	body_expansion(A,M,QM,NA),
	body_expansion(B,M,QM,NB).
body_expansion((X^A),M,QM,(X^NA)):- ciaopp_expansion, !,
	body_expansion(A,M,QM,NA).
body_expansion((\+ A),M,QM,(\+ NA)):- ciaopp_expansion, !,
	body_expansion(A,M,QM,NA).
body_expansion(if(A,B,C),M,QM,if(NA,NB,NC)) :- ciaopp_expansion, !,
	body_expansion(A,M,QM,NA),
	body_expansion(B,M,QM,NB),
        body_expansion(C,M,QM,NC).
body_expansion(!,_M,_QM,!):- ciaopp_expansion, !.
body_expansion(true,_M,_QM,true):- ciaopp_expansion, !.
body_expansion(A, M, QM, NC) :-
        current_fact(goal_trans(M,_)) ->
	expand_goal(A, M, QM, NB), !,
	body_expansion(NB, M, -, NC).
body_expansion(Call,M,QM,NCall) :-
        functor(Call, call, N), N > 1, % call/n
        ( mexpand_imports(M, _, call, 2, HM) -> HM = hiord_rt ),
        !,
        Call =.. [_, P| LAs],
        As =.. [''| LAs],
        N1 is N-1,
        meta_expansion_arg1(P, pred(N1), M, QM, true, NP, NCall, 'hiord_rt:call'(NP,As)).
body_expansion(A, M, QM, NA) :-
        atom_expansion_add_goals(A, M, QM, A1, NA, A1).

% JF: todo: add a skip goal declaration?
expand_inside(','(inside,inside), basiccontrol).
expand_inside(';'(inside,inside), basiccontrol).
expand_inside('->'(inside,inside), basiccontrol).
%expand_inside('^'(?,inside), aggregates).
expand_inside('\\+'(inside), basiccontrol).
expand_inside('if'(inside,inside,inside), basiccontrol).

expand_goal(G, M, QM, NG) :-
	\+ ( functor(G, N, A), functor(Meta, N, A), expand_inside(Meta, _) ),
        ( QM = (-) -> QG = G ; QG = QM:G ),
        goal_trans(M, T),
          arg(1, T, QG),
          arg(2, T, NG),
          '$meta_call'(T), !.

atom_expansion_add_goals(V, _, _, _, _, _) :- var(V), !, fail.
atom_expansion_add_goals('$meta_call'(X), M, -, 'hiord_rt:call'(X), G, G) :-
        accessible_in(M, hiord_rt, '$meta_call', 1), !.
atom_expansion_add_goals(A, M, QM, NA, G, G_) :-
        functor(A, F, N),
        atom_expansion(A, F, N, M, QM, A1, RM),
        possibly_meta_expansion(F, N, A1, M, RM, NA, G, G_).

accessible_in(M, M, _, _) :- !.
accessible_in(M, EM, F, A) :-
        mexpand_imports(M, _, F, A, EM).

atom_expansion(_, F, _, _, _, NA, error) :- number(F), !, NA = F.
atom_expansion(A, F, N, M, -, NA, RM) :- !,
        unqualified_atom_expansion(A, F, N, M, NA, RM).
atom_expansion(A, F, N, M, M, NA, RM) :- !,
        atom_expansion_here(A, F, N, M, NA),
        RM = M.
atom_expansion(A, F, N, M, QM, NA, RM) :-
        M = user(_), QM = user, !,
        atom_expansion_here(A, F, N, M, NA),
        RM = M.
atom_expansion(A, F, N, M, QM, NA, RM) :-
        ( mexpand_imports(M, QM, F, N, EM) -> true
        ; module_warning(not_imported(F, N, M, QM)),
          EM = '$bad_qualification$'
        ),
        module_concat(EM, A, NA),
        RM = EM.

% This is not recursive since we want the expansion not depending on the
% imports of the modules used
unqualified_atom_expansion(A, F, N, M, NA, RM) :-
        mexpand_multifile(M, F, N), !,
        module_concat(multifile, A, NA),
        RM = M,
        check_if_imported(M, F, N).
unqualified_atom_expansion(A, F, N, M, NA, RM) :-
        ( mexpand_defines(M, F, N) ->  % local defined have priority
              module_concat(M, A, NA),
              RM = M,
              check_if_imported(M, F, N)
        ; mexpand_imports(M, IM, F, N, EM) ->
              module_concat(EM, A, NA),
              RM = EM,
              check_if_reimported(M, IM, F, N, EM)
        ; ( M = user(_) -> true
          ; module_warning(not_defined(F, N, M))
          ),
          module_concat(M, A, NA),
          RM = M
        ).

check_if_imported(M, F, N) :- 
        \+ redefining(M, F, N),
        mexpand_imports(M, IM, F, N, _) ->
          module_warning(imported_needs_qual(F, N, IM))
        ; true.

check_if_reimported(M, IM, F, N, EM) :-
        \+ redefining(M, F, N),
        mexpand_imports(M, IM0, F, N, EM0),
        EM0 \== EM ->
          module_warning(imported_needs_qual(F, N, IM0, IM))
        ; true.

atom_expansion_here(A, F, N, M, NA) :-
        mexpand_multifile(M, F, N), !,
        module_concat(multifile, A, NA).
atom_expansion_here(A,_F,_N, M, NA) :-
        module_concat(M, A, NA).

% Called from c_itf

% EXPORTED
possibly_meta_expansion(F, N, A1, M, RM, NA, G, G_) :-
        functor(Meta, F, N),
	% JF: This is a work around, not a good solution...
	( expand_inside(Meta, RM) ->
	    Primitive = true
        ; mexpand_meta_args(RM, Meta, Primitive)
	), !,
        functor(A1, F_, N_),
        meta_expansion_args(1, N_, A1, M, Meta, Primitive, NAL, G, G_),
        NA =.. [F_|NAL].
possibly_meta_expansion(_F,_N, A1,_M,_RM, A1, G, G). % No meta expansion

% EXPORT
possibly_meta_expansion_head(F, N, A1, M, RM, NA, G, G_) :-
        functor(Meta, F, N),
	% JF: it does not take into account expand_inside/2
        mexpand_meta_args(RM, Meta, Primitive), !,
        functor(A1, F_, N_),
        meta_expansion_args(1, N_, A1, M, Meta, Primitive, NAL, G, G_),
        NA =.. [F_|NAL].
possibly_meta_expansion_head(_F,_N, A1,_M,_RM, A1, G, G). % No meta expansion

meta_expansion_args(N, Max,_G,_M,_Meta,_Primitive, [], NG, NG) :-
        N > Max, !.
meta_expansion_args(N, Max, G, M, Meta, Primitive, AL, NG, R) :-
        arg(N, Meta, Type),
        arg(N, G, X),
        meta_expansion_arg(Type, X, M, Primitive, AL, AL_, NG, NG_),
        N1 is N+1,
        meta_expansion_args(N1, Max, G, M, Meta, Primitive, AL_, NG_, R).

meta_expansion_arg(?, X, _M, _Primitive, [X|AL], AL, R, R) :- !.
meta_expansion_arg(addmodule, X, M, _Primitive, [X,M|AL], AL, R, R) :- !.
meta_expansion_arg(Type, X, M, Primitive, [NX|AL], AL, NG, NG_) :-
        meta_expansion_type(Type, X, M, -, Primitive, NX, NG, NG_).

% EXPORTED
meta_expansion_type(Type, X, M, QM, Primitive, NX, NG, NG_) :- 
	( Type = list(Type2), nonvar(X), ( X = [] ; X = [_|_] ) ->
	    meta_expansion_list(X, Type2, M, QM, Primitive, NX, NG, NG_)
	; meta_expansion_arg1(X, Type, M, QM, Primitive, NX, NG, NG_)
	).

meta_expansion_list([], _,   _,  _,  _, [], R, R) :- !.
meta_expansion_list([E|Es], Type, M, QM, Primitive, [NE|NEs], G, R) :- !,
        meta_expansion_arg1(E, Type, M, QM, Primitive, NE, G, G_),
        meta_expansion_list(Es, Type, M, QM, Primitive, NEs, G_, R).

meta_expansion_arg1(A, Type, M, QM, Primitive, NA, R, R) :-
        expand_meta(A, Type, M, QM, XA), !,
        term_to_meta_or_primitive(Primitive, XA, NA).
meta_expansion_arg1(X, Type, M, QM, Primitive, NX, G, R) :-
        runtime_module_expansion(G, Type, Primitive, M, QM, X, NX, R).

term_to_meta_or_primitive(true, T, T).
term_to_meta_or_primitive(fail, T, T) :- ciaopp_expansion, !.
term_to_meta_or_primitive(fail, T, NT) :- term_to_meta(T,NT).

% Called from internals
% Predicate fails if expansion has to be done at runtime
expand_meta(V,       inside,  M,  QM,    NA) :- ( var(V) ; nonvar(V), V = (_:_) ), !,
        expand_meta_of_type(inside, V, M, QM, NA).
expand_meta(V,        _Type, _M, _QM,   _NA) :- var(V), !, fail.
expand_meta('$:'(X),  _Type, _M, _QM,     X). % to handle lists...
expand_meta(QM:A,      Type,  M, _OldQM, NA) :- !,
        atom(QM),
        expand_meta(A, Type, M, QM, NA).
expand_meta(A, Type, M, QM, NA) :-
        expand_meta_of_type(Type, A, M, QM, NA).

expand_meta_of_type(clause, C, M, QM, NC) :- !,
        expand_clause(C, M, QM, NC).
expand_meta_of_type(spec, S, M, QM, NS):- !,
        spec_expansion(S, M, QM, NS).
expand_meta_of_type(fact, Atom, M, QM, NAtom):- !,
	atom_expansion_add_goals(Atom, M, QM, NAtom, no, no).
expand_meta_of_type(goal, Goal, M, QM, NGoal):- !,
	body_expansion(Goal, M, QM, NGoal).
expand_meta_of_type(inside, Goal, M, QM, NGoal):- !,
	body_expansion(Goal, M, QM, NGoal).
expand_meta_of_type(pred(0), Goal, M, QM, NGoal):- !,
	body_expansion(Goal, M, QM, NGoal).
expand_meta_of_type(pred(N), P, M, QM, NP):-
        integer(N),
        pred_expansion(P, N, M, QM, NP0),
	( ciaopp_expansion, \+ P = {_ :- _}, \+ P = (_ :- _) -> % predicate abstractions won't work
	    NP0 = 'PA'(_,_,NP1),
	    functor(P, _, A),
	    functor(NP1, NP1Name, _),
	    functor(NP, NP1Name, A),
	    unify_args(1, A, NP, 2, NP1)
	; NP = NP0
	).

expand_clause((H:-B), M, QM, (NH:-NB)):- !,
	atom_expansion_add_goals(H, M, QM, NH, no, no),
	body_expansion(B, M, QM, NB).
expand_clause(H, M, QM, NH):- !,
	atom_expansion_add_goals(H, M, QM, NH, no, no).

spec_expansion(F/A, M, QM, NF/A) :-
	atom(F),
	integer(A),
	functor(G,F,A),
	atom_expansion(G, F, A, M, QM, NG, _),
	functor(NG,NF,A).

pred_expansion({H :- B}, N, M, QM, Term) :- !,
        pred_expansion_pa(H, B, N, M, QM, Term).
pred_expansion((H :- B), N, M, QM, Term) :- !,
        pred_expansion_pa(H, B, N, M, QM, Term).
% For higher-order terms, all variables are shared
pred_expansion(P, N, M, QM, 'PA'(P,H,NG)) :-
        nonvar(P),
        functor(P, F, A),
        atom(F),
        functor(H,'',N),
        T is N+A,
        functor(G, F, T),
        unify_args(1, A, P, 2, G), % Unify pred args skipping first
        arg(1,H,I), % Unify first head arg
        arg(1,G,I),
        A2 is A+2,
        unify_args(2, N, H, A2, G), % Unify rest head args
        atom_expansion(G, F, T, M, QM, G1, RM),
	possibly_meta_expansion(F, T, G1, M, RM, NG, no, no).

pred_expansion_pa(Hh, B, N, M, QM, 'PA'(ShVs,H,NB)) :-
        head_and_shvs(Hh, H, ShVs),
        check_pred(H, N, {Hh :- B}),
        body_expansion(B, M, QM, NB).

head_and_shvs((ShVs-> H), H, ShVs) :- !.
head_and_shvs(H, H, []).

check_pred(H, N, PredAbs) :-
        functor(H, F, A),
        ( F = '', ! ; module_warning(bad_pred_abs(PredAbs)) ),
        compare(R,A,N),
        ( R = (=) -> true
        ; R = (<) ->
            module_warning(short_pred_abs(PredAbs, N))
        ;%R = (>) ->
            module_warning(big_pred_abs(PredAbs, N))
        ).

unify_args(I, N,_F,_A,_G) :- I > N, !.
unify_args(I, N, F, A, G) :- 
        arg(I, F, X),
        arg(A, G, X),
        I1 is I+1,
        A1 is A+1,
        unify_args(I1, N, F, A1, G).

runtime_module_expansion(G,_Type,_Primitive,_M,_QM, X, X, G) :-
	ciaopp_expansion, !. % no runtime exp.
runtime_module_expansion('basiccontrol:,'(P, R), Type, Primitive, M, QM, X, NX, R) :- !,
        % This predicate is defined diff. in compiler.pl and builtin.pl
        uses_runtime_module_expansion,
        P = 'internals:rt_module_exp'(X, Type, M, QM, Primitive, NX).
runtime_module_expansion(G,_Type,_Primitive,_M,_QM, X, X, G). % no runtime exp.
