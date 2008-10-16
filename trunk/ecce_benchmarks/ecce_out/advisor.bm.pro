
/* Specialised program generated by ECCE 2.0 */
/* PD Goal: A */
/* Parameters: Abs:l InstCheck:v Msv:s NgSlv:g Part:e Prun:n Sel:t Whstl:f Raf:yesFar:yes Dce:yes Poly:y Dpu:yes ParAbs:yes Msvp:no Rrc:yes */
/* Transformation time: 0 ms */
/* Unfolding time: 0 ms */
/* Post-Processing time: 0 ms */

/* Specialised Predicates: 
what_to_do_today__1(A,B) :- what_to_do_today(first_of_may,A,B).
proposal__2(A) :- proposal(weekend,nice,A).
proposal__3(A) :- proposal(weekend,nasty,A).
*/

what_to_do_today(first_of_may,A,B) :- 
    what_to_do_today__1(A,B).
what_to_do_today__1(sunny,A) :- 
    proposal__2(A).
what_to_do_today__1(rainy,A) :- 
    proposal__3(A).
what_to_do_today__1(foggy,A) :- 
    proposal__3(A).
what_to_do_today__1(windy,A) :- 
    proposal__3(A).
proposal__2(go_out_to_the_nature).
proposal__2(visit_the_golf_club).
proposal__2(wash_your_car).
proposal__2(it_is_fun_to_learn_Japanese).
proposal__3(go_out_to_the_town).
proposal__3(visit_the_bridge_club).
proposal__3(enjoy_yourself_at_home).
proposal__3(it_is_fun_to_learn_Japanese).
