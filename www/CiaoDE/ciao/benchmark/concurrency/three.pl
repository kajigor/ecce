:- module(three,
        [
            three_one/0,
            three_two/0,
            three_three/0,
            three_four/0,
            three_five/0,
            three_six/0,
            three_seven/0,
            three_eight/0,
            three_nine/0,
            three_ten/0
        ], []).


:- use_module(sleep, [sleep_and_print/2]).
:- use_module(success).
:- use_module(library(system)).
:- use_module(library(dummy)).
 

walltime(T):- statistics(walltime, [_, T]).

displaynl(W):-
        display(W),
        nl.



% Third module: in case of failure.  launch_goal/3 has three
% arguments: the goal to be executed, what to do in case of success,
% and what to do in case of failure.  The first and second one share
% variables, so the bindings of the initial goal will be seen by the
% case_of_success goal.


% 3.1: the call succeeds.

three_one:-
        launch_goal(success(1, _What_was_this), 
                    displaynl(success),
                    displaynl(failure)).


% 3.2: the call fails.

three_two:-
        launch_goal(success(3, _What_was_this), 
                    displaynl(success),
                    displaynl(failure)).



% 3.3: What about backtraking?  There is no backtraking from the
% outside to the inside of a launched predicate.  We wait for thread
% completion in order not to clutter up the display.

three_three:-
        launch_goal(success(_A, _What_was_this), 
                    displaynl(success),
                    displaynl(failure), GoalId),
        join_and_release_goal(GoalId),
        fail.


% 3.4: However, a launched goal can backtrack freely inside itself.
% Note that we are using launch_goal/4, which returns also the
% identifier of the thread.  

three_four:-
        launch_goal(all_successes, 
                    displaynl(success),
                    displaynl(failure), GoalId),
        join_and_release_goal(GoalId).



% 3.5: failure in the success continuation causes the failure
% continuation to be taken!  So the success continuacion can be as
% well be used to check that the initial gave the desired result.

three_five:-
        launch_goal(success(1, S), 
                    success(2, S),
                    displaynl(failure)).


% 3.6: the complementary: the test succeeds.

three_six:-
        launch_goal(success(1, S), 
                    success(_A, S),
                    displaynl(this_was_a_failure)).



% 3.7: A possible skeleton of a daemon.  A thread is launched and
% receives queries.  Every query is just a number, generated by the
% daemon itself, but which could come from, say, a socket connection.
% When the query arrives a process is launched.  This process executes
% (concurrently) the server code, which just prints out its thread
% number and which query arrived.  Simultaneously, the main daemon is
% "listening" for more queries, actually implementing a loop.  After
% some time the initial thread (bound to the toplevel) kills the
% initial loop thread (you may think that shutdown time has arrived).

three_seven:-
        walltime(_),                      % Initialize timing, if neessary
        launch_goal(daemon, GoalId),
        sleep_and_print(15, 'killing daemon'),
        kill_goal(GoalId).

daemon:-
        wait_for_query(Query),
        launch_goal(daemon_handler(query(Query)), true, error),
        daemon.

daemon_handler(query(X)):- 
        goal_self(Myself),
        display('thread '),
        display(Myself),
        display(' received query '),
        displaynl(X),
%        0 =:= X mod 2,                          % validate it
        displaynl('Correct query!!!!!').

error:- displaynl('*** error in request ***'). 

wait_for_query(Q):-
        walltime(Q),
        sleep_and_print(1, sending_query(Q)).



% 3.8: A funnier way to implement a daemon.  This dies the first time
% it receives a wrong query, because the received_query/1 predicate
% does not actually make the loop_code call.  Reversing the goals in
% the body of received_query/1 would solve this.  
%
% When goals and continuations are remotely copied, variables being
% shared by Goal and OnSuccess will still be shared in the new thread.
% The same happens with OnFailure, but in any case, if OnFailure is
% reached, than means that either Goal or OnSuccess have failed, so no
% bindings made by them are seen by OnFailure.

three_eight:-
        walltime(_),
        loop_code.


loop_code:- launch_goal(wait_for_query(Q), received_query(Q), error).

received_query(Q):-
        daemon_handler(query(Q)),
        loop_code.


% 3.9: Another way to arrange the code is by starting a new daemon
% upon receiving a query.  This does not die when a wrong query is
% received, since a new thread waiting for requests is generated
% before checking the received request.  The daemon is stopped by
% killing all threads but the one which started the whole enchilada:
% we cannot kill the daemon thread directly because it is forking
% endlessly.

three_nine:-
        walltime(_),
        launch_goal(loop_code_perp),
        pause(10),
        displaynl('Killing all threads'),
        kill_other_goals.

loop_code_perp:- launch_goal(w_f_q_l(Q), daemon_handler(query(Q)), error).

w_f_q_l(Query):-
        wait_for_query(Query),
        loop_code_perp.
        


% 3.10: a final arrangement.  The daemon code is not called as the
% body of a separate fact, but passed on as an argument to the
% wait_for part of the daemon, which launches a new server after a
% query has been received.
%%
% CAUTION: NOT WORKING.  There is a problem with the remote copy of
% self-referenced terms....

three_ten:-
       walltime(_),
       Code = launch_goal(w_f_q_l_c(Q, Code), daemon_handler(query(Q)), error),
       call(Code).

w_f_q_l_c(Query, Code):-
        wait_for_query(NewQuery),
        call(Code),
        Query = NewQuery.
