%%
%% Class sun.misc.URLClassPath
%% NOTICE: Do not edit this file. This file has been generated from:
%% java.awt.event.ActionEvent
%%

:- class('URLClassPath').
:- use_package(objects).

:- export('JAVA_VERSION'/1).
:- export('URLClassPath'/1).
:- export('URLClassPath'/2).
:- export('USER_AGENT_JAVA_VERSION'/1).
:- export('access$0'/3).
:- export('access$1'/2).
:- export(addURL/1).
:- export(getLoader/2).
:- export(getResource/2).
:- export(getResource/3).
:- export(getResources/2).
:- export(getResources/3).
:- export(getURLs/1).
:- export(jarHandler/1).
:- export(lmap/1).
:- export(loaders/1).
:- export(path/1).
:- export(pathToURLs/2).
:- export(push/1).
:- export(urls/1).

%%--------------------------------------------------
%% Declared classes.
%%--------------------------------------------------

:- use_class(library('javaobs/java/util/ArrayList')).
:- use_class(library('javaobs/java/util/HashMap')).
:- use_class(library('javaobs/java/util/Stack')).
:- use_class(library('javaobs/java/lang/String')).
:- use_class(library('javaobs/java/net/URL')).
:- use_class(library('javaobs/java/net/URLStreamHandler')).
:- use_class(library('javaobs/java/net/URLStreamHandlerFactory')).


%%--------------------------------------------------
%% Inheritance information.
%%--------------------------------------------------

:- inherit_class(library('javaobs/java/lang/Object')).

%%--------------------------------------------------
%% Miscelanea.
%%--------------------------------------------------

:- redefining(_).
:- set_prolog_flag(multi_arity_warnings,off).

:- discontiguous java_assert/2.
:- use_module(library(lists)).

:- public(java_constructor/1).
:- public(java_invoke_method/1).
:- public(java_get_value/1).
:- public(java_set_value/1).
:- public(java_add_listener/2).
:- public(java_remove_listener/2).
:- public(java_delete_object/0).
:- public(get_java_id/1).
:- use_class(library('javaobs/java_obj')).

%%--------------------------------------------------
%% Destructor.
%%--------------------------------------------------

destructor :-
    java_delete_object.

%%--------------------------------------------------
%% Interface Information.
%%--------------------------------------------------



%%--------------------------------------------------
%% Java fields.
%%--------------------------------------------------


%%--------------------------------------------------
%% Constructors.
%%--------------------------------------------------

'URLClassPath'(_V0) :-
    list(_V0),
    java_constructor('sun.misc.URLClassPath'(_V0)).


'URLClassPath'(_V0, _V1) :-
    list(_V0),
    interface(_V1, 'URLStreamHandlerFactory'), _V1:get_java_id(_V1OBJ),
    java_constructor('sun.misc.URLClassPath'(_V0, _V1OBJ)).



%%--------------------------------------------------
%% Methods.
%%--------------------------------------------------

addURL(_V0) :-
    interface(_V0, 'URL'), _V0:get_java_id(_V0OBJ),
    java_invoke_method(addURL(_V0OBJ, _)).

getResource(_V0, Result) :-
    var(Result),
    atom(_V0),
    java_invoke_method(getResource(_V0, Result)).

getResource(_V0, _V1, Result) :-
    var(Result),
    atom(_V0),
    interface(_V1, boolean), _V1:get_java_id(_V1OBJ),
    java_invoke_method(getResource(_V0, _V1OBJ, Result)).

getResources(_V0, Result) :-
    var(Result),
    atom(_V0),
    java_invoke_method(getResources(_V0, Result)).

getResources(_V0, _V1, Result) :-
    var(Result),
    atom(_V0),
    interface(_V1, boolean), _V1:get_java_id(_V1OBJ),
    java_invoke_method(getResources(_V0, _V1OBJ, Result)).

getURLs(Result) :-
    var(Result),
    java_invoke_method(getURLs(Result)).

pathToURLs(_V0, Result) :-
    var(Result),
    atom(_V0),
    java_invoke_method(pathToURLs(_V0, Result)).


:- set_prolog_flag(multi_arity_warnings,on).
