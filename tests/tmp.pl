
/* Specialised program generated by ECCE 2.0 */
/* PD Goal: rev([a,b,c],A,B) */
/* Parameters: Abs:l InstCheck:v Msv:s NgSlv:g Part:e Prun:n Sel:t Whstl:f Raf:yesFar:yes Dce:yes Poly:y Dpu:yes ParAbs:yes Msvp:no Rrc:yes */
/* Transformation time: 10.0 ms */
/* Unfolding time: 10.0 ms */
/* Post-Processing time: 0.0 ms */

/* Specialised Predicates: 
rev__1(A,B) :- rev([a,b,c],A,B).
*/

rev([a,b,c],A,[c,b,a|A]).
rev__1(A,[c,b,a|A]).