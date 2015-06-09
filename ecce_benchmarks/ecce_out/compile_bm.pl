
compile :- print(compiling),nl,
  fcompile('advisor.bm.pro'),
  fcompile('applast.bm.pro'),
  %fcompile('contains.bm.pro'),
  %fcompile('depth.bm.pro'),
  fcompile('doubleapp.bm.pro'),
  fcompile('ex_depth.bm.pro'),
  fcompile('flip.bm.pro'),
  %fcompile('grammar.bm.pro'),
  fcompile('groundunify.complex.bm.pro'),
  fcompile('groundunify.simple.bm.pro'),
  fcompile('imperative-solve.bm.pro'),
  fcompile('liftsolve.app.bm.pro'),
  fcompile('liftsolve.lmkng.bm.pro'),
  fcompile('map.reduce.bm.pro'),
  fcompile('map.rev.bm.pro'),
  fcompile('match.kmp.bm.pro'),
  fcompile('matchapp.bm.pro'),
  %fcompile('maxlength.bm.pro'),
  fcompile('model_elim.bm.pro'),
  %fcompile('partialevaluator.bm.pro'),
  fcompile('regexp.r1.bm.pro'),
  fcompile('regexp.r2.bm.pro'),
  fcompile('regexp.r3.bm.pro'),
  fcompile('relative.bm.pro'),
  fcompile('remove.bm.pro'),
  fcompile('remove2.bm.pro'),
  fcompile('rev.bm.pro'),
  fcompile('rev_acc_type.bm.pro'),
  %fcompile('revlast.bm.pro'),
  fcompile('rotateprune.bm.pro'),
  fcompile('ssuply.bm.pro'),
  fcompile('transpose.bm.pro'),
  %fcompile('upto.bm.pro'),
  fcompile('vanilla.doubleapp.bm.pro'),
  print(finished),nl.
  
  :- compile,halt.
  
  /* /bin/ls -l *.ql > ls_out.txt */