:- module(genmultibar,[],[assertions,regtypes,isomodes]).

:- comment(author,"Isabel Mart@'{i}n Garc@'{i}a").


:- export(multibarchart/8).
:- export(multibarchart/10).


:- use_module(library('chartlib/genbar1'),
        [yelement/1,axis_limit/1,header/1,title/1,footer/1]).
:- use_module(library('chartlib/bltclass')).
:- use_module(library('chartlib/color_pattern')).
:- use_module(library('chartlib/test_format')).
:- use_module(library('chartlib/install_utils')).
:- use_module(library(lists)).
:- use_module(library(random)).

:- comment(title,"Multi barchart widgets").

:- comment(module,"This module defines predicates which show barchart
        widgets.  These bar charts are somewhat different from the bar
        charts generated by the predicates in modules genbar1, genbar2,
        genbar3 and genbar4. Predicates in the present module show
        different features of each dataset element in one chart at the same
        time. Each bar chart element is a group of bars, and the element
        features involve three vectors defined as follows:

	@begin{itemize}

        @item xvector is a list containing the names (atoms) of the bars (n
        elements). Each bar group will be displayed at uniform intervals.

        @item yvector is a list that contains m sublists, each one is
        composed of n elements. The i-sublist contains the y-values of the
        i-BarAttribute element for all of the XVector elements.

        @item bar_attributtes is a list containing the appearance features
        of the bars (m elements). Each element of the list can be partial
        or complete, which means that you can define as bar attributes only
        the element name or by setting the element name, its background and
        foreground color and its stipple pattern.

        @end{itemize}

        Other relevant aspects about this widgets are:

        @begin{itemize}

        @item If you don't want to display text in the elements
        header, barchart title, xaxis title, yaxis title or footer,
        simply type @tt{''} as the value of the argument. 

        @item The bar chart has a legend, and one entry (symbol and label)
        per feature group bar.

        @item The user can either select the appearance of the bars
        (background color, foreground color and stipple style) or not. See
        the multibar_attribute type definition.

        @item Data points can have their bar segments displayed in one of
        the following modes: stacked, aligned, overlapped or
        overlayed. They user can change the mode clicking in the checkboxes
        associated to each mode.

        @item The predicates test whether the format of the arguments is
        correct. If one or both vectors are empty, the exception
        @tt{error2} will be thrown. If the vectors contains elements but
        are not correct, the exception @tt{error5} or @tt{error6} will be
        thrown, depending on what is incorrect. @tt{error5} means that
        @var{XVector} and each element of @var{YVector} do not contain
        the same number of elements or that @var{YVector} and @var{BarsAtt}
        do not contain the same number of elements, while @tt{error6}
        indicates that not all the @var{BarsAtt} elements contain a correct
        number of attributes.

        @end{itemize}

        The examples will help you to understand how these predicates should
        be called.  

").


:- push_prolog_flag(multi_arity_warnings,off).

:- pred multibarchart(+header,+title,+title,+list(xelement),+title,
	+list(multibar_attribute),+list(yelement),+footer).

:- comment(
multibarchart(Header,BTitle,XTitle,XVector,YTitle,BarsAtts,YVector,Footer), 

        "The x axis limits are autoarrange. The user can call the predicate
        in two ways. In the first example the user sets the appearance of
        the bars, in the second one the appearance features will be chosen
        by the library.

Example1:
@begin{verbatim}
multibarchart('This is the Header text',
	'My BarchartTitle',
	'Processors',
	['processor1','processor2','processor3','processor4'],
	'Time (seconds)',
	[['setup time','MediumTurquoise','Plum','pattern2'],
	    ['sleep time','Blue','Green','pattern5'],
	    ['running time','Yellow','Plum','pattern1']],
	[[20,30,40,50],[10,8,5,35],[60,100,20,50]],
	'This is the Footer text').
@end{verbatim}
Example2:
@begin{verbatim}
multibarchart('This is the Header text',
	'My BarchartTitle',
	'Processors',
	['processor1','processor2','processor3','processor4'],
	'Time (seconds)',
	[['setup time'],['sleep time'],['running time']],
	[[20,30,40,50],[10,8,5,35],[60,100,20,50]],
	'This is the Footer text').
@end{verbatim}

").

multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,Footer):-
	srandom(_),
	not_empty(XVector,YVector,BarsAttibuttes,'multibarchart/8'),
	valid_format(XVector,YVector,BarsAttibuttes,'multibarchart/8'),
	valid_attributes(BarsAttibuttes,'multibarchart/8'),
	show_multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,Footer).

:- pred multibarchart(+header,+title,+title,+list(xelement),+title,
	+list(multibar_attribute),+list(yelement),+axis_limit,+axis_limit,
	+footer).

:- comment(
multibarchart(Header,BT,XT,XVector,YT,BAtts,YVector,YMax,YMin,Footer),

	"This predicate is quite similar to @pred{multibarchart/8}, except
        in that you can choose limits in the y axis. The part of the bars
        placed outside the limits will not be plotted.

Example2:
@begin{verbatim}
multibarchart('This is the Header text',
	'My BarchartTitle',
	'Processors',
	['processor1','processor2','processor3','processor4'],
	'Time (seconds)',
	[['setup time'],['sleep time'],['running time']],
	[[20,30,40,50],[10,8,5,35],[60,100,20,50]],
	[80],
	[0],
	'This is the Footer text').
@end{verbatim}

").

multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,YMax,YMin,Footer):-
	srandom(_),
	not_empty(XVector,YVector,BarsAttibuttes,'multibarchart/8'),
	valid_format(XVector,YVector,BarsAttibuttes,'multibarchart/8'),
	valid_attributes(BarsAttibuttes,'multibarchart/8'),
	show_multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,YMax,YMin,Footer).

%%show_multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,Footer).
show_multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,Footer):-
	new_interp(Interp),
	begin_graph(XVector,Interp),
	titles(BarchartTitle,XaxisTitle,YaxisTitle,Interp),
	header1(Header,Interp),
	header2(Interp),
	footer(Footer,Interp),
	yvalues(YVector,Interp),
	attributes(BarsAttibuttes,Interp),
	loop_xy(Interp),
	table(Interp).

%%show_multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,Footer).
show_multibarchart(Header,BarchartTitle,XaxisTitle,XVector,YaxisTitle,BarsAttibuttes,YVector,YMax,YMin,Footer):-
	new_interp(Interp),
	begin_graph(XVector,Interp),
	titles(BarchartTitle,XaxisTitle,YaxisTitle,Interp),
	header1(Header,Interp),
	header2(YMax,YMin,Interp),
	footer(Footer,Interp),
	yvalues(YVector,Interp),
	attributes(BarsAttibuttes,Interp),
	loop_xy(Interp),
	table(Interp).

%%begin_graph(XVector,Interp).
begin_graph(XVector,Interp):-
	name('package require BLT',G1),
	tcltk_raw_code(G1,Interp),
	name('if { $tcl_version >= 8.0 } {',G2),
	tcltk_raw_code(G2,Interp),
	name('namespace import blt::*',G3),
	tcltk_raw_code(G3,Interp),
	name('namespace import -force blt::tile::* }',G4),
	tcltk_raw_code(G4,Interp),
%%	name('bltdebug 1',G5),
%%	tcltk_raw_code(G5,Interp),
	name('proc XTicksLabel { w value } {',G7),
	tcltk_raw_code(G7,Interp),
	name('set index [expr round($value)]',G8),
	tcltk_raw_code(G8,Interp),
	name('if { $index != $value } {',G9),
	tcltk_raw_code(G9,Interp),
	name('return $value }',G10),
	tcltk_raw_code(G10,Interp),
	name('incr index -1',G11),
	tcltk_raw_code(G11,Interp),
	xticks(XVector,Interp),
	name('return $xticks }',G12),
	tcltk_raw_code(G12,Interp),
        img_dir(Imgdir),
	atom_concat(Imgdir,'_patterns.tcl',Patterns),
	atom_concat('source ',Patterns,P),
	name(P,G13),
	tcltk_raw_code(G13,Interp),
	atom_concat(Imgdir,'chalk.gif',BackImage),
	atom_concat('image create photo bgTexture -file ',BackImage,BI),
	name(BI,G14),
	tcltk_raw_code(G14,Interp),
	name('option add *Button.padX	5',G15),
	tcltk_raw_code(G15,Interp),
	name('option add *tile	bgTexture',G16),
	tcltk_raw_code(G16,Interp),
	name('option add *Radiobutton.font   -*-courier*-medium-r-*-*-14-*-*',G17),
	tcltk_raw_code(G17,Interp),
	name('option add *Radiobutton.relief	flat',G18),
	tcltk_raw_code(G18,Interp),
	name('option add *Radiobutton.borderWidth     2',G19),
	tcltk_raw_code(G19,Interp),
	name('option add *Radiobutton.highlightThickness 0',G20),
	tcltk_raw_code(G20,Interp),
	name('option add *Htext.font	-*-times*-bold-r-*-*-14-*-*',G21),
	tcltk_raw_code(G21,Interp),
	name('option add *Htext.tileOffset	no',G22),
	tcltk_raw_code(G22,Interp),
	name('option add *header.font	-*-times*-medium-r-*-*-14-*-*',G23),
	tcltk_raw_code(G23,Interp),
	name('option add *Barchart.font	  -*-helvetica-bold-r-*-*-14-*-*',G24),
	tcltk_raw_code(G24,Interp).
	

%%xticks(XVector,Interp).
xticks(XVector,Interp):-
	name('set xticks [lindex {',Begin),
	xticks1(XVector,X1),
	list_concat(X1,X2),
	append(Begin,X2,BX),
	name('} $index]',End),
	append(BX,End,Line),
	tcltk_raw_code(Line,Interp).

xticks1([],[]).
xticks1([Xtick1|L1s],[Xtick2,[32]|L2s]):-
	name(Xtick1,Xtick2),
	xticks1(L1s,L2s).

%%titles(BarchartTitle,XaxisTitle,YaxisTitle,Interp).
titles(BarchartTitle,XaxisTitle,YaxisTitle,Interp):-
	name('option add *Barchart.title ',B1),
	name(BarchartTitle,B2),
	add_doublequotes(B2,B3),
	append(B1,B3,B4),
	tcltk_raw_code(B4,Interp),
	name('option add *Axis.tickFont	  -*-helvetica-medium-r-*-*-12-*-*',T1),
	tcltk_raw_code(T1,Interp),
	name('option add *Axis.titleFont  -*-helvetica-bold-r-*-*-12-*-*',T2),
	tcltk_raw_code(T2,Interp),
	name('option add *x.Command	XTicksLabel',T3),
	tcltk_raw_code(T3,Interp),
	name('option add *x.Title ',X1),
	name(XaxisTitle,X2),
	add_doublequotes(X2,X3),
	append(X1,X3,X4),
	tcltk_raw_code(X4,Interp),
	name('option add *y.Title ',Y1),
	name(YaxisTitle,Y2),
	add_doublequotes(Y2,Y3),
	append(Y1,Y3,Y4),
	tcltk_raw_code(Y4,Interp),
	name('option add *activeBar.Foreground	black',T4),
	tcltk_raw_code(T4,Interp),
	name('option add *activeBar.stipple   pattern1',T5),
	tcltk_raw_code(T5,Interp),
	name('option add *Element.Background	white',T6),
	tcltk_raw_code(T6,Interp),
	name('option add *Element.Relief   raised',T7),
	tcltk_raw_code(T7,Interp),
	name('option add *Grid.dashes	{ 2 4 }',T8),
	tcltk_raw_code(T8,Interp),
	name('option add *Grid.hide	no',T9),
	tcltk_raw_code(T9,Interp),
	name('option add *Grid.mapX	""',T10),
	tcltk_raw_code(T10,Interp),
	name('option add *Legend.Font	-*-helvetica*-bold-r-*-*-12-*-*',T11),
	tcltk_raw_code(T11,Interp),
	name('option add *Legend.activeBorderWidth	2 ',T12),
	tcltk_raw_code(T12,Interp),
	name('option add *Legend.activeRelief	raised ',T13),
	tcltk_raw_code(T13,Interp),
	name('option add *Legend.anchor	  ne',T14),
	tcltk_raw_code(T14,Interp),
	name('option add *Legend.borderWidth	0',T15),
	tcltk_raw_code(T15,Interp),
	name('option add *Legend.position	right',T16),
	tcltk_raw_code(T16,Interp),
	name('option add *TextMarker.Font	*Helvetica-Bold-R*14*',T17),
	tcltk_raw_code(T17,Interp),
	name('set visual [winfo screenvisual .] ',T18),
	tcltk_raw_code(T18,Interp),
	name('if { $visual != "staticgray" && $visual != "grayscale" } {',T19),
	tcltk_raw_code(T19,Interp),
	name('option add *print.background	yellow',T20),
	tcltk_raw_code(T20,Interp),
	name('option add *quit.background	red',T21),
	tcltk_raw_code(T21,Interp),
	name('option add *quit.activeBackground	red2 }',T22),
	tcltk_raw_code(T22,Interp).


%%header1(Header,Interp).
header1(Header,Interp):-
	name('htext .title -text {',H1),
	tcltk_raw_code(H1,Interp),
	name(Header,H2),
	append(H2,[125],H3),      %%[125] = }
	tcltk_raw_code(H3,Interp),
	name('htext .header -text {',H4),
	tcltk_raw_code(H4,Interp),
	name('%% radiobutton .header.stacked -text stacked -variable barMode -anchor w -value "stacked" -selectcolor red -command {',H5),
	tcltk_raw_code(H5,Interp),
	name('.graph configure -barmode $barMode }',H6),
	tcltk_raw_code(H6,Interp),
	name('.header append .header.stacked -width 1.5i -anchor w',H7),
	tcltk_raw_code(H7,Interp),
	name('%% Bars are stacked on top of each other.',H8),
	tcltk_raw_code(H8,Interp),
	name('%% radiobutton .header.aligned -text aligned -variable barMode -anchor w -value "aligned" -selectcolor yellow -command {',H9),
	tcltk_raw_code(H9,Interp),
	name('.graph configure -barmode $barMode }',H10),
	tcltk_raw_code(H10,Interp),
	name('.header append .header.aligned -width 1.5i -fill x',H11),
	tcltk_raw_code(H11,Interp),
	name('%%  Bars are drawn side-by-side at a fraction of their normal width.',H12),
	tcltk_raw_code(H12,Interp),
	name('%% radiobutton .header.overlap -text "overlap" -variable barMode -anchor w -value "overlap" -selectcolor green -command {',H13),
	tcltk_raw_code(H13,Interp),
	name('.graph configure -barmode $barMode }',H14),
	tcltk_raw_code(H14,Interp),
	name('.header append .header.overlap -width 1.5i -fill x',H15),
	tcltk_raw_code(H15,Interp),
	name(' %%  Bars overlap slightly.',H16),
	tcltk_raw_code(H16,Interp),
	name(' %% radiobutton .header.normal -text "overlayed" -variable barMode -anchor w -value "normal" -selectcolor blue -command {',H17),
	tcltk_raw_code(H17,Interp),
	name('.graph configure -barmode $barMode }',H18),
	tcltk_raw_code(H18,Interp),
	name('.header append .header.normal -width 1.5i -fill x',H19),
	tcltk_raw_code(H19,Interp),
	name('%%  Bars are overlayed one on top of the next. }',H20),
	tcltk_raw_code(H20,Interp).	

:- pred header2/1.
header2(Interp):-
	name('set types {{{Poscript files} {.ps} }}',FileTypes),
	tcltk_raw_code(FileTypes,Interp),
	name('htext .header2 -text {',H1),
	tcltk_raw_code(H1,Interp),
	name('Pressing the %%',H3),
	tcltk_raw_code(H3,Interp),			   
	name('set w $htext(widget)',H4),
	tcltk_raw_code(H4,Interp),
	name('button $w.print -text {Save} -command {',H5),
	tcltk_raw_code(H5,Interp),
	name('set file_select [tk_getSaveFile -title "Save barchart as" -filetypes $types]',H6),
	tcltk_raw_code(H6,Interp),
	name('.graph postscript output $file_select.ps }',H7),
	tcltk_raw_code(H7,Interp),
	name('$w append $w.print',H8),
	tcltk_raw_code(H8,Interp),
	name('%% button will create a Postcript file}',H9),
	tcltk_raw_code(H9,Interp),
	name('barchart .graph',B),
	tcltk_raw_code(B,Interp).

:- pred header2/3.

header2(YMax,YMin,Interp):-
	name('set types {{{Poscript files} {.ps} }}',FileTypes),
	tcltk_raw_code(FileTypes,Interp),
	name('htext .header2 -text {',H1),
	tcltk_raw_code(H1,Interp),
	name('Pressing the %%',H3),
	tcltk_raw_code(H3,Interp),			   
	name('set w $htext(widget)',H4),
	tcltk_raw_code(H4,Interp),
	name('button $w.print -text {Save} -command {',H5),
	tcltk_raw_code(H5,Interp),
	name('set file_select [tk_getSaveFile -title "Save barchart as" -filetypes $types]',H6),
	tcltk_raw_code(H6,Interp),
	name('.graph postscript output $file_select.ps }',H7),
	tcltk_raw_code(H7,Interp),
	name('$w append $w.print',H8),
	tcltk_raw_code(H8,Interp),
	name('%% button will create a Postcript file}',H9),
	tcltk_raw_code(H9,Interp),
	name('barchart .graph',B),
	tcltk_raw_code(B,Interp),
	maxmin_y(YMax,YMin,Interp).

:- pop_prolog_flag(multi_arity_warnings).

maxmin_y([],[],_Interp).
maxmin_y([YMax],[],Interp):-
	name('.graph axis configure y -max ',M1),
	number_codes(YMax,M2),
	append(M1,M2,M3),
	tcltk_raw_code(M3,Interp).
maxmin_y([],[YMin],Interp):-
	name('.graph axis configure y -min ',M1),
	number_codes(YMin,M2),
	append(M1,M2,M3),
	tcltk_raw_code(M3,Interp).
maxmin_y([YMax],[YMin],Interp):-
	name('.graph axis configure y -max ',M1),
	number_codes(YMax,M2),
	append(M1,M2,M3),
	tcltk_raw_code(M3,Interp),
	name('.graph axis configure y -min ',M4),
	number_codes(YMin,M5),
	append(M4,M5,M6),
	tcltk_raw_code(M6,Interp).

%%footer(Footer,Interp).
footer(Footer,Interp):-
	name('htext .footer -text {',F1),
	tcltk_raw_code(F1,Interp),
	name(Footer,F2),
	tcltk_raw_code(F2,Interp),
	name('Hit the %%',F3),
	tcltk_raw_code(F3,Interp),
	name('set w $htext(widget)',F4),
	tcltk_raw_code(F4,Interp),
	name('button $w.quit -text quit -command exit ',F5),
	tcltk_raw_code(F5,Interp),
	name('$w append $w.quit',F6),
	tcltk_raw_code(F6,Interp),
	name('%% button to close the widget. }',F7),
	tcltk_raw_code(F7,Interp).

%%yvalues(YVector,Interp).
yvalues(YVector,Interp):-
	number_bars(YVector,NBars),
	name('vector X',X1),
	tcltk_raw_code(X1,Interp),
	name('X set {',X2),
	create_x(NBars,1,NBarsList1),
	list_concat(NBarsList1,NBarsList2),
	append(X2,NBarsList2,X3),
	tcltk_raw_code(X3,Interp),
	yvalues1(YVector,1,Interp).
	
%%yvalues1(YVector,Number,Interp).
yvalues1([],_Number,_Interp).
yvalues1([YValues|YVs],Number1,Interp):-
	yvalues2(YValues,Number1,Interp),
	Number2 is Number1 + 1,
	yvalues1(YVs,Number2,Interp).
	
%%yvalues2(YValues,NumberBars,Number1,Interp):-
yvalues2(YValues,Number1,Interp):-
	name('vector Y',E1),
	number_codes(Number1,E2),
	append(E1,E2,E3),
	tcltk_raw_code(E3,Interp),
	name('Y',E4),
	append(E4,E2,E5),
	name(' set {',E6),
	append(E5,E6,E7),
	tcltk_raw_code(E7,Interp),
	yvalueslist(YValues,YValuesList1),
	list_concat(YValuesList1,YValuesList2),
	tcltk_raw_code(YValuesList2,Interp).

%%yvalueslist(YValues,YValuesList),
yvalueslist([],[[125]]).   %%[125] = }
yvalueslist([Y1|Y1s],[Y2|Y2s]):-
	number_codes(Y1,N1),
	append(N1,[32],Y2),
	yvalueslist(Y1s,Y2s).


%%number_bars(YVector,NBars).
%%number_bars([[_,_,_,_,[YList]]|_],NBars):-
%%	length(YList,NBars).
%%number_bars([[A,B,C,D,[YList]]|_],NBars):-
%%	atom(A),
%%	atom(B),
%%	atom(C),
%%	atom(D),
%%	length(YList,NBars).
number_bars([YList|_],NBars):-
	length(YList,NBars).

%%create_x(NBars,Number,NBarsList).
create_x(NBars,NBars,[EndList]):-
	number_codes(NBars,N1),
	append(N1,[125],EndList).
create_x(NBars,Number,[NList|NLs]):-
	NBars > Number,
	number_codes(Number,N1),
	append(N1,[32],NList),
	Number1 is Number + 1,
	create_x(NBars,Number1,NLs).
	
%%attributes(BarsAttributes,Interp).
attributes(BarsAttributes,Interp):-
	name('set attributes {',A),
	tcltk_raw_code(A,Interp),
	attributes1(BarsAttributes,1,Interp).
attributes1([],_,Interp):-
	name('}',A),
	tcltk_raw_code(A,Interp).
attributes1([[LegendElement,FColor,BColor,SPattern]|XVs],NVecY1,Interp):-
	name(LegendElement,LE),
	add_doublequotes(LE,EN1),
	color(FColor,ForegroundColor),
	number_codes(NVecY1,NY),
	append([89],NY,NY1),  %%[89] = 'Y'
	name(ForegroundColor,FC1),
	color(BColor,BackgroundColor),
	name(BackgroundColor,BC1),
	pattern(SPattern,StipplePattern),
	name(StipplePattern,SP),
	append(EN1,[32],EN),
	append(NY1,[32],Ydata),
	append(FC1,[32],FC),
	append(BC1,[32],BC),
	append(EN,Ydata,ENYdata),
	append(ENYdata,FC,ENYdataFC),
	append(BC,SP,BCSP),
	append(ENYdataFC,BCSP,BarAttr),
	tcltk_raw_code(BarAttr,Interp),
	NVecY2 is NVecY1 + 1,
	attributes1(XVs,NVecY2,Interp).
attributes1([[LegendElement]|XVs],NVecY1,Interp):-
	name(LegendElement,LE),
	add_doublequotes(LE,EN1),
	random_color(ForegroundColor),
	number_codes(NVecY1,NY),
	append([89],NY,NY1),  %%[89] = 'Y'
	name(ForegroundColor,FC1),
	random_color(BackgroundColor),
	name(BackgroundColor,BC1),
	random_pattern(StipplePattern),
	name(StipplePattern,SP),
	append(EN1,[32],EN),
	append(NY1,[32],Ydata),
	append(FC1,[32],FC),
	append(BC1,[32],BC),
	append(EN,Ydata,ENYdata),
	append(ENYdata,FC,ENYdataFC),
	append(BC,SP,BCSP),
	append(ENYdataFC,BCSP,BarAttr),
	tcltk_raw_code(BarAttr,Interp),
	NVecY2 is NVecY1 + 1,
	attributes1(XVs,NVecY2,Interp).

%%loop_xy(Interp):-
loop_xy(Interp):-
	name('foreach {label yData fgcolor bgcolor stipple} $attributes {',L1),
	tcltk_raw_code(L1,Interp),
	name('.graph element create $yData -label $label -bd 1 -ydata $yData -xdata X -fg $fgcolor -bg $bgcolor -stipple $stipple }',L2),
	tcltk_raw_code(L2,Interp),
	name('.header.stacked invoke',L3),
	tcltk_raw_code(L3,Interp).

table(Interp):-
	name('table . 0,0 .title -fill x 1,0 .header -fill x 2,0 .header2 -fill x 3,0 .graph -fill both 4,0 .footer -fill x',T1),
	tcltk_raw_code(T1,Interp),
	name('table configure . r0 r1 r3 -resize none',T2),
	tcltk_raw_code(T2,Interp),
	name('Blt_ZoomStack .graph',T3),
	tcltk_raw_code(T3,Interp),
	name('Blt_Crosshairs .graph',T4),
	tcltk_raw_code(T4,Interp),
	name('Blt_ActiveLegend .graph',T5),
	tcltk_raw_code(T5,Interp),
	name('Blt_ClosestPoint .graph',T6),
	tcltk_raw_code(T6,Interp).


:- comment(doinclude,multibar_attribute/1).

:- regtype multibar_attribute/1.

multibar_attribute([LegendElement]):-
	atomic(LegendElement).

multibar_attribute([LegendElement, ForegroundColor, BackgroundColor,
	StipplePattern]):-
	atom(LegendElement),
	color(ForegroundColor),
	color(BackgroundColor),
	pattern(StipplePattern).

:- comment(multibar_attribute/1,"@includedef{multibar_attribute/1}

   Defines the attributes of each feature bar along the different
   datasets.

   @begin{description}

   @item{LegendElement} Legend element name. It may be a number or an
   atom. Every @var{LegendElement} value of the list must be unique.

   @item{@var{ForegroundColor}} It sets the Foreground color of the
   bar. Its value must be a valid color, otherwise the system will
   throw an exception. If the argument value is a variable, it gets
   instantiated to a color chosen by the library.

   @item{@var{BackgroundColor}} It sets the Background color of the
   bar. Its value must be a valid color, otherwise the system will
   throw an exception. If the argument value is a variable, it gets
   instantiated to a color chosen by the library.

   @item{@var{StipplePattern}} It sets the stipple of the bar. Its
   value must be a valid pattern, otherwise the system will throw an
   exception. If the argument value is a variable, it gets
   instantiated to a pattern chosen by the library.

   @end{description}


").

:- comment(doinclude,xelement/1).

:- regtype xelement/1.

xelement(Label):-
	atomic(Label).

:- comment(xelement/1," @includedef{xelement/1} This type defines a dataset
	label. Although @var{Label} values may be numbers, the will be
	treated as atoms, So it will be displayed at uniform intervals
	along the x axis.

").
