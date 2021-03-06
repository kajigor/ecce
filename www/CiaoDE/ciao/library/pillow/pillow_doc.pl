:- use_package([assertions]).
:- comment(nodoc,assertions).

:- comment(title, "The PiLLoW Web programming library").
:- comment(subtitle,"REFERENCE MANUAL").
:- comment(subtitle,"@em{Generated/Printed on:} @today{}").

:- comment(author, "Daniel Cabeza").
:- comment(author, "Manuel Hermenegildo").

:- include(library('ClipAddress')).

:- comment(copyright,"Copyright @copyright{} D. Cabeza and M. Hermenegildo

@include{Copyright.Manuals}

").

:- comment(summary, "@include{pillow_summ.lpdoc}").

:- comment(module,"@cindex{WWW, interfacing with}
   @cindex{XML}@cindex{CGI}@cindex{HTML}@cindex{HTTP} This package
   implements the PiLLoW library @cite{pillow-ws-dist-short}.  The
   following three chapters document, respectively, the predicates for
   HTML/XML/CGI programming, the predicate for HTTP conectivity, and
   the types used in the definition of the predicates (key for fully
   understanding the other predicates).  You can find a paper and some
   additional information in the @file{library/pillow/doc} directory
   of the distribution, and in the WWW at
   @uref{http://clip.dia.fi.upm.es/Software/pillow/pillow.html}. There
   is also a @index{PiLLoW on-line tutorial} (slides) at
   @uref{http://clip.dia.fi.upm.es/logalg/slides/C_pillow/C_pillow.html} which
   illustrates the basic features and provides a number of examples of
   PiLLoW use.

@section{Installing PiLLoW}
@include{INSTALL_pillow.lpdoc}

").

:- include(library(pillow)).
