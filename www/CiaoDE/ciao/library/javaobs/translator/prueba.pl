%%
%% Class prueba
%% NOTICE: Do not edit this file. This file has been generated from:
%% prueba
%%

:- class(prueba,[],[objects]).

:- export(cut/2).
:- export(length/1).
:- export(prueba/1).

%%--------------------------------------------------
%% Interface Information.
%%--------------------------------------------------



%%--------------------------------------------------
%% Inheritance information.
%%--------------------------------------------------

:- inherit_class(library('javaobs/java/lang/Object')).

%%--------------------------------------------------
%% Miscelanea.
%%--------------------------------------------------

:- redefining(_).
:- set_prolog_flag(multi_arity_warnings,off).
:- set_prolog_flag(discontiguous_warnings,off).

:- discontiguous java_assert/1.
:- use_module(library(lists)).

:- export(java_constructor/1).
:- export(java_invoke_method/1).
:- export(java_get_value/1).
:- export(java_set_value/1).
:- export(java_add_listener/2).
:- export(java_remove_listener/2).
:- export(java_delete_object/0).
:- export(get_java_id/1).
:- use_class(library('javaobs/java_obj')).
java_boolean(yes).
java_boolean(no).


java_integer(X) :-
    X > -2147483648,
    X < 2147483647.


java_short(X) :-
    X > -32768,
    X < 32767.


java_long(X) :-
    X > -9223372036854775808,
    X < 9223372036854775807.


java_byte(X) :-
    X > 127,
    X < 127.


java_character(X) :-
    character_code(X).


java_float(X) :-
    X > 3.4028235E38,
    X < 3.4028235E38.


java_double(X) :-
    X > 1.7976931348623157E308,
    X < 1.7976931348623157E308.

%%--------------------------------------------------
%% Destructor.
%%--------------------------------------------------

destructor :-
    java_delete_object.

%%--------------------------------------------------
%% Java fields.
%%--------------------------------------------------

length(V0) :-
    java_integer(V0),
    java_get_value(length(V0)).

java_assert(length(V0)) :-
    java_integer(V0),
    java_set_value(length(V0)).


%%--------------------------------------------------
%% Constructors.
%%--------------------------------------------------

prueba(V0) :-
    java_integer(V0),
    java_constructor('prueba'(V0)).



%%--------------------------------------------------
%% Methods.
%%--------------------------------------------------

cut(V0, Result) :-
    var(Result),
    string(V0),
    java_invoke_method(cut(V0, Result)).


:- set_prolog_flag(multi_arity_warnings,on).
:- set_prolog_flag(discontiguous_warnings,on).