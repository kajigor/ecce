%%---------------------------------------------------------------------
%%
%% MENU CLASS
%%
%%---------------------------------------------------------------------

:- module(menu_class_doc,[],[objects,assertions,isomodes,regtypes]).

:- use_class(library('tcltk/examples/interface/window_class')).
:- use_class(library('tcltk/examples/interface/menu_entry_class')).

:- use_module(library('tcltk/tcltk')).
:- use_module(library('tcltk/tcltk_low_level')).
:- use_module(library(lists),[append/3]).


name('').

:- export(set_name/1).

%%------------------------------------------------------------------------
:- pred set_name(+Name) :: atom
        # "Indicates the @var{Name} of the menubutton associated.".
%%------------------------------------------------------------------------
set_name(Name) :-
%       atom(Name),
        set_fact(name(Name)),
        notify_changes.

menu('').

:- export(set_menu/1).

%%------------------------------------------------------------------------
:- pred set_menu(+Menu) :: atom
        # "@var{Menu} posted when cascade entry is invoked.".
%%------------------------------------------------------------------------
set_menu(Menu) :-
        atom(Menu),
        set_fact(menu(Menu)),
        notify_changes.

:- export([get_menu/1]).

%%------------------------------------------------------------------------
:- pred get_menu(-Menu) :: atom
        # "Gets the @var{Menu} asociated to the cascade entry.".
%%------------------------------------------------------------------------
get_menu(Menu) :-
        menu(Menu).


label('').

:- export(set_label/1).

%%------------------------------------------------------------------------
:- pred set_label(+Name) :: atom
        # "@var{Name} specifies a string to be displayed as an identifying label in the menu entry.".
%%------------------------------------------------------------------------
set_label(Label) :-
        atom(Label),
        set_fact(label(Label)),
        notify_changes.

:- export([get_label/1]).

%%------------------------------------------------------------------------
:- pred get_label(-Name) :: atom
        # "Gets the @var{Name} which is displayed as an identifying label in the menu entry.".
%%------------------------------------------------------------------------
get_label(Label) :-
        label(Label).


tearoff('1').

:- export(set_tearoff/1).

%%------------------------------------------------------------------------
:- pred set_tearoff(+Tearoff) :: atom
        # "@var{Tearoff} must have a proper boolean value, which specifies wheter or not the menu should include a tear-off entry at the top. Defaults to 1.".
%%------------------------------------------------------------------------
set_tearoff(Tearoff) :-
        atom(Tearoff),
        set_fact(tearoff(Tearoff)),
        notify_changes.

:- export([get_tearoff/1]).

%%------------------------------------------------------------------------
:- pred get_tearoff(-Tearoff) :: atom
        # "Gets the @var{Tearoff} value".
%%------------------------------------------------------------------------
get_tearoff(Tearoff) :-
        tearoff(Tearoff).

list_name([],[]).

list_name([Des|Next],[write(X),write(Des)|Next1]) :-
        X='.',
        list_name(Next,Next1).

%%---------------------------------------------------------------------
%% IMPLEMENTATION
%%---------------------------------------------------------------------

:- export([tcl_name/1,creation_options/1,creation_options_entry/1,creation_menu_name/1]).

:- comment(hide,tcl_name/1).

%%---------------------------------------------------------------------
:- pred tcl_name(-Widget) :: atom 
        # "Specifies the name of the @var{Widget}. In this case is menu.".
%%---------------------------------------------------------------------
tcl_name('menu').

%%---------------------------------------------------------------------
:- pred creation_options(-OptionsList) :: list
        # "Creates a list with the options supported by the menu.".
%%---------------------------------------------------------------------
%creation_options([write(X),write(W),write(X),write(MB),write(X),write(N),' ',min(tearoff),T]) :-
creation_options(Opts) :-
        display('En el creation optitons'),nl,
%       name([W,MB,N]),
        name(P),
        display(P),nl,
        list_name(P,C),
        display(C),nl,
%       X='.',
%       name(N),
        tearoff(T),
        append(C,[' '],Opts0),
        append(Opts0,[min(tearoff)],Opts1),
        append(Opts1,[T],Opts),
        display('Opts'),nl.

%%---------------------------------------------------------------------
:- pred creation_menu_name(-OptionsList) :: list
        # "Creates a list with the name of the menu.".
%%---------------------------------------------------------------------
creation_menu_name([write(X),write(W),write(X),write(MB),write(X),write(N)]) :-
        name([W,MB,N]),
        X='.'.


%%---------------------------------------------------------------------
:- pred creation_options_entry(-OptionsList) :: list
        # "Creates a list with the options of the menu entry.".
%%---------------------------------------------------------------------
%creation_options([write('.'),write(Widget),write('.'),write(C),' add command',min(label),label(L)|Other]) :-
creation_options_entry([write(X),write(W),write(X),write(MB),write(X),write(N),' add command',min(label),label(L)]) :-
        name([W,MB,N]),
        X='.',
        label(L).
%       inherited creation_options(Other).


notify_changes:-
%       display('En el notify changes menu'),nl,
        self(Menu),
        owner(AnOwner),
        AnOwner instance_of window_class,
        AnOwner:menu_changed(Menu),
        fail.
notify_changes.


:- export([add_owner/1,remove_owner/1]).
:- comment(hide,add_owner/1).
:- comment(hide,remove_owner/1).

add_owner(Owner) :-
        \+ owner(Owner),
        Owner instance_of window_class,
        assertz_fact(owner(Owner)),
        self(Menu),
        Owner:add_menu(Menu),
        !.
add_owner(_).


remove_owner(Owner) :-
        retract_fact(owner(Owner)),
        Owner instance_of window_class,
        self(Menu),
        Owner:remove_menu(Menu),
        !.

remove_owner(_).



%%---------------------------------------------------------------------
%% CONSTRUCTOR
%%---------------------------------------------------------------------
:- comment(hide,'class$call'/3).
:- comment(hide,'class$used'/2).

:- set_prolog_flag(multi_arity_warnings,off).

menu_class.  % Not owned

menu_class([]):- !.  

menu_class([Menuentry|Next]) :-
        ( add_menu_entry(Menuentry) ; true ),
        !,
        menu_class(Next).

%menu_class([]) :- !.

%menu_class([AnOwner|Next]) :-
%       add_owner(AnOwner),
%       !,
%       menu_class(Next).

%menu_class(AnOwner) :-
%       !,
%       add_owner(AnOwner).

:- set_prolog_flag(multi_arity_warnings,on).
%%---------------------------------------------------------------------
%% SHOW / HIDE ENTIRE WIDGET
%%---------------------------------------------------------------------

%:- export(show/0).

show :-
        display('En el show'),nl,
        menuentry(Menuentry,hidden),
%       display('__________w'),display(Menuentry),nl,
        show_menu_entry(Menuentry),
        fail.
show.

%:- export(hide/0).

hide :-
        menuentry(Menuentry,shown),
        hide_menu_entry(Menuentry),
        fail.
hide.
%%---------------------------------------------------------------------
%% SHOW / HIDE SPECIFIC ITEMS
%%---------------------------------------------------------------------

%:- export(show_menu_entry/1).

show_menu_entry(Menuentry) :-
        display('En el show_menu_entry 1'),nl,
%       menuentry(Menu,hidden),
        Menuentry instance_of menu_entry_class,
%       display('despues intace'),nl,
        owner(Ow),
        Menuentry:creation_options(Opts),
%       display(Opts),nl,
        Ow:interp(I),
%       display(I),nl,
        tcl_eval(I,Opts,_),
        retract_fact(menuentry(Menuentry,hidden)),
        asserta_fact(menuentry(Menuentry,shown)).

%:- export(hide_menu_entry/1).

hide_menu_entry(Menuentry) :-
        retract_fact(menuentry(Menuentry,shown)),
        !,
        Menuentry instance_of menu_entry_class,
        owner(Ow),
        Ow:interp(I),
        Menuentry:creation_options_delete(Opts),
        tcl_eval(I,Opts,_),
        asserta_fact(menuentry(Menuentry,hidden)).

%%---------------------------------------------------------------------
%% ADD/REMOVE ITEMS
%%---------------------------------------------------------------------

%:- export(add_menu_entry/1).
%:- export(remove_menu_entry/1).
%:- export(menu_entry_changed/1).

add_menu_entry(Menuentry) :-
        \+ menuentry(Menuentry,_),
        Menuentry instance_of menu_entry_class,
        assertz_fact(menuentry(Menuentry,hidden)),
        self(Principal),
        Menuentry:add_owner(Principal),
        !.
add_menu_entry(_).

remove_menu_entry(Menuentry) :-
        hide_menu_entry(Menuentry),
        retract_fact(menuentry(Menuentry,_)),
        Menuentry instance_of menu_entry_class,
        self(Principal),
        Menuentry:remove_owner(Principal),
        !.
remove_menu_entry(_).


menu_entry_changed(Menuentry) :-
        display('En el item_changed'),nl,
        hide_menu_entry(Menuentry),
        show_menu_entry(Menuentry).
