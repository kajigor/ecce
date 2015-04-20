:- module( ddlist , [
	              null_list/1,
	              create_from_list/2,
		      to_list/2,
	              next/2,
		      prev/2,
		      insert/3,
		      insert_top/3,
		      insert_after/3,
		      insert_begin/3,
		      insert_end/3,
		      delete/2,
		      delete_top/2,
		      delete_after/2,
		      remove_all_elements/3,
		      top/2,
		      rewind/2,
		      forward/2,
		      length/2,
		      length_next/2,
		      length_prev/2,
		      ddlist/1
		    ], [assertions, regtypes, isomodes] ).

:- use_module( library(lists) , [length/2, append/3] ).

:- comment(title,"Doubly linked lists").
:- comment(author, "David Trallero Mena").

:- comment(module, "This library implements doubly linked lists. An
   index is used for referencing the current element in the list. This
   index can be modified by the @em{next} and @em{prev}
   predicates. The value of the current index can be obtained via the
   @em{top} predicate").


:- regtype ddlist(X) # "@var{X} is doubly linked list.".

ddlist( (A,B) ) :-
	list(A),
	list(B).

:- pred null_list( ?NullList )
	:  (var( A ))
        => (ddlist( A ))
# "@var{NullList} is an empty ddlist.".


null_list( ([],[]) ).


:- pred to_list( DDList , List )
	:  (ddlist( DDList ),var( List ))
        => (list( List ))
# "Converts from doubly linked list to list.".

to_list( DL , L ) :-
	rewind( DL , ([],L) ).


:- pred create_from_list( List , DDList )
	:  (list(List),var( DDList ))
        => (ddlist( DDList ))
# "Creates a doubly linked list from normal list @var{List}.".

create_from_list( L , ([],L) ).


:- pred next( ddlist(OldList) , ddlist(NewList) )

# "@var{NewList} is @var{OldList} but index is set to the element
   following the current element of OldList.\n It satisfies
   @tt{next(A,B), prev(B,A)}.".

next( (Mirror , [A|R]) , ([A|Mirror] , R) ).

:- pred prev( ddlist(OldList) , ddlist(NewList) )

# "@var{NewList} is @var{OldList} but index is set to the element
   before the current element of @var{OldList}.".

prev( ([A|Mirror] , R) , (Mirror , [A|R]) ).


:- pred delete( ddlist(OldList) , ddlist(NewList) )

# "@var{NewList} does not have the previous element (top(prev)) of
   @var{OldList}.".

delete( ([_|A],B) , ( A,B) ).
delete( ([_]  ,B) , ([],B) ).


:- pred delete_after( ddlist(OldList) , ddlist(NewList) )

# "@var{NewList} does not have next element to current element (top)
  of @var{OldList}.".

delete_after( (A,[T|[_|B]]) , (A, [T|B]) ).


:- pred delete_top( ddlist(OldList) , ddlist(NewList) )

# "@var{NewList} does not have the current element (top) of @var{OldList}.".

delete_top( (A,[_|B]) , (A, B) ).
delete_top( (A,[_]  ) , (A,[]) ).


:- pred remove_all_elements( OldList , E , NewList ) 
	: (ddlist(OldList) , nonvar(E))
        => ddlist(NewList)
# "Remove all elements that unify with @var{E} from
   @var{OldList}. @var{NewList} is the result of this operation. The
   pointer is not modified unless there it is pointing at element that
   unifies with @var{E}.".

remove_all_elements( (A,B) , E , (NA,NB) ) :-
	remove_all( A , E , NA ),
	remove_all( B , E , NB ).


remove_all( [] , _ , [] ).
remove_all( [A|As] , A , Bs ) :-
	!,
	remove_all( As , A , Bs ).
remove_all( [A|As] , E , [A|Bs] ) :-
	remove_all( As , E , Bs ).


:- pred insert( ddlist(List) , Element , ddlist(NewList) )

# "@var{NewList} is like @var{List} but with @var{Element} inserted
  @bf{before} the current index.\n It satisfies @tt{insert( X , A , Xp ) ,
  delete( Xp , X )}.".

insert( (A,B), I , (IA,B) ) :-
	list( I ),
	!,
	append( I , A , IA ).
insert( (A,B), I , ([I|A],B) ).


:- pred insert_after( ddlist(List) , Element , ddlist(NewList) )

# "@var{NewList} is like @var{List} but with @var{Element} inserted
  @bf{after} the current index.\n It satisfies @tt{insert_after(X, A,
  Xp), delete_after(Xp, X)}.".

insert_after( (A,[T|B]), I , (A,[T|IB]) ) :- 
	list(I),
	!,
	append( I , B, IB ).
insert_after( (A,[T|B]), I , (A,[T|[I|B]]) ) :- !.


:- pred insert_begin( ddlist(List) , Element , ddlist(NewList) )

# "@var{NewList} is like @var{List} with @var{Element} as first
  element.".

insert_begin( (M ,F), I , (MI,  F  ) ) :-
	(list(I) -> append( M , I , MI ) ; append( M , [I] , MI )).


:- pred insert_end( ddlist(List) , Element , ddlist(NewList) )

# "@var{NewList} is like @var{List} with @var{Element} as last
  element.".

insert_end( (M,F), I , (M,FI) ) :-
	(list(I) -> append( F , I , FI ) ; append( F , [I] , FI )).


:- pred insert_top( ddlist(List) , Element , ddlist(NewList) )

# "Put @var{Element} as new top of @var{NewList} and push the rest of
  elements after it.  It satisfies top( NewList , element )".

insert_top( (A,B), I , (A,IB) ) :- 
	!,
	(list(I) -> append( I , B , IB ) ; IB = [I|B]).


:- pred top( ddlist(List) , Element )
# "@var{Element} is the element pointed by index.".

top( (_,[A|_]), A).


:- pred length( ddlist(List) , Len )
# "@var{Len} is the length of the @var{List}".

length( (A,B) , L ) :- 
	lists:length(A,LA), 
	lists:length(B,LB),
	L is LA + LB.


:- pred length_next( ddlist(List) , Len )
# "@var{Len} is the length from the current index till the end.".

length_next( (_,B) , L ) :- lists:length( B , L ).


:- pred length_prev( ddlist(List) , Len )
# "@var{Len} is the length from the beginning till the current index.".

length_prev( (A,_) , L ) :- lists:length( A , L ).


:- pred rewind( ddlist(OldList) , ddlist(NewList) )
# "@var{NewList} is the @var{OldList} but index is set to 0.".

rewind( ([] , A), ([],A) ) :- !.
rewind( ([M|MR] , A), S ) :-
	rewind( (MR,[M|A]) , S ).


:- pred forward( ddlist(OldList) , ddlist(NewList) )

# "@var{NewList} is the @var{OldList} but index is set to lentgh of
  @var{NewList}.".

forward( (A,[]) , (A,[]) ) :- !.
forward( (A,[M|MR]), S ) :-
	forward( ([M|A],MR) , S ).


:- comment(appendix,"

   Two simple examples of the use of the ddlist library package
   follow.  

    @subsection{Using insert_after}

@noindent
@begin{verbatim}
@includeverbatim{examples/ddl1}
@end{verbatim}
 

    @subsection{More Complex example}

@noindent
@begin{verbatim}
@includeverbatim{examples/ddl2}
@end{verbatim}

   ").
