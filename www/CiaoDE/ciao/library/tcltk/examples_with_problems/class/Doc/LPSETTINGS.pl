:- module(_, _, [functions]).
:- use_module(library(terms)).
:- use_module(ciaosrc('CIAOSETTINGS')).
:- use_module(ciaosrc('CIAOSHARED')).

:- reexport(ciaosrc('doc/common/LPDOCCOMMON')).

:- reexport(ciaosrc('CIAOSETTINGS'), [lpdoclib/1]).

:- redefining(_).

:- discontiguous fileoption/2.

% -*- mode: Makefile; -*-
% ----------------------------------------------------------------------------
% 
% ****             lpdoc document generation SETTINGS                  *****
% 
%         These SETTINGS should be changed to suit your application
% 
% The defaults listed are suggestions and/or the ones used for local 
% installation in the CLIP group machines.
% ----------------------------------------------------------------------------
% List of all directories where the .pl files to be documented can be found
% (separated by spaces; put explicit paths, i.e., do not use any variables)
% You also need to specify all the paths of files used by those files!
% 

% ----------------------------------------------------------------------------
% List of all the *system* directories where .pl files used are
% (separated by spaces; put explicit paths, i.e., do not use any variables)
% You also need to specify all the paths of files used by those files!
% You can put these in FILEPATHS instead. Putting them here only
% means that the corresponding files will be assumed to be "system"
% files in the documentation.
% 
systempath := ~atom_concat( [ ~ciaosrc , '/lib' ] )|
    ~atom_concat( [ ~ciaosrc , '/library' ] )|
    ~atom_concat( [ ~ciaosrc , '/library/tcltk' ] )|
    ~atom_concat( [ ~ciaosrc , '/library/tcltk/examples/class' ] ).
% ----------------------------------------------------------------------------
% Uncommenting this allows loading a file including path alias definitions 
% (i.e., this has the same functionality as the @tt{-u} option in @apl{ciaoc})
% Simply leave uncommented if you do not use path aliases.
% 
% PATHSFILE = 
% ----------------------------------------------------------------------------
% Define this to be the main file name (include a path only if it
% should appear in the documentation) 
% 
mainfile := 'canvas_class_doc'.
% ----------------------------------------------------------------------------
% Select lpdoc options for main file (do 'lpdoc -h' to get list of options)
% Leaving this blank produces most verbose manuals
% -v -nobugs -noauthors -noversion -nochangelog -nopatches -modes 
% -headprops -literalprops -nopropnames -noundefined -nopropsepln -norefs 
% -nobullet -nosysmods -noengmods -noisoline -propmods -shorttoc
%

% ----------------------------------------------------------------------------
% List of files to be used as components. These can be .pl files
% or .src files (manually produced files in texinfo format). 
% (include a path only if it should appear in the documentation, i.e.,
% for sublibraries) 
% 
component := 'shape_class_doc' | 'oval_class_doc' | 'poly_class_doc' | 'arc_class_doc'.
% ----------------------------------------------------------------------------
% Select lpdoc opts for component file(s) 
% (see above or do 'lpdoc -h' to get complete list of opts))
% Leaving this blank produces most verbose manuals
% 

% ----------------------------------------------------------------------------
% Define this to be the list of documentation formats to be generated by 
% default when typing gmake (*** keep them in this order ***)
% texi dvi ps pdf ascii manl info infoindex html htmlindex 
% 
% Leaving out pdf since many systems don't have ps to pdf conversion yet
% DOCFORMATS = texi dvi ps pdf ascii manl info infoindex html htmlindex 
docformat := 'texi' | 'dvi' | 'ps' | 'ascii' | 'manl' | 'info' | 'infoindex' | 'html' | 'htmlindex'.
% ----------------------------------------------------------------------------
% Define this to be the list (separated by spaces) of indices to be 
% generated ('all' generates all the supported indices)
% Note: too many indices may exceed the capacity of texinfo!
% concept lib apl pred prop regtype decl op modedef file global
% all
% 
index := 'concept' | 'pred' | 'prop' | 'regtype' | 'modedef' | 'global'.
% ----------------------------------------------------------------------------
% If you are using bibliographic references, define this to be the list 
% (separated by commas, full paths, no spaces) of .bib files to be used 
% to find them. 
% 
:- reexport(ciaosrc('CIAOSHARED'), [bibfile/1]).
% ----------------------------------------------------------------------------
% Only need to change these if you will be installing the docs somewhere else
% ----------------------------------------------------------------------------
% Define this to be the dir in which you want the document(s) installed. 
% 
docdir := ~('CIAOSETTINGS':docdir).
% ----------------------------------------------------------------------------
% Uncomment this for .dvi and .ps files to be compressed on installation
% If uncommented, set it to path for gzip
% 
% COMPRESSDVIPS = gzip
% ----------------------------------------------------------------------------
% Uncomment this to specify a gif to be used as page background in html 
% 
htmlbackground := 'http://www.clip.dia.fi.upm.es/images/Clip_bg.gif'.
% ----------------------------------------------------------------------------
% Define this to be the permissions for automatically generated data files
% 
datapermissions := perm(rw, rw, r).
% ----------------------------------------------------------------------------
% Define this to be the perms for automatically generated dirs and exec files
% 
execpermissions := perm(rwx, rwx, rx).
% ----------------------------------------------------------------------------
% The settings below are important only for generating html and info *indices*
% ----------------------------------------------------------------------------
% Define this to be files containing header and tail for the html index. 
% Pointers to the files generated by lpdoc are placed in a document that 
% starts with HTMLINDEXHEADFILE and finishes with HTMLINDEXTAILFILE
% 
% HTMLINDEXHEADFILE = $(LIBDIR)/Head_generic.html
htmlindex_headfile := ~atom_concat( [ ~lpdoclib , '/Head_clip.html' ] ).
% HTMLINDEXTAILFILE = $(LIBDIR)/Tail_generic.html
htmlindex_tailfile := ~atom_concat( [ ~lpdoclib , '/Tail_clip.html' ] ).
% ----------------------------------------------------------------------------
% Define this to be files containing header and tail for the info "dir" index. 
% dir entries generated by lpdoc are placed in a "dir" file that 
% starts with INFODIRHEADFILE and finishes with INFODIRTAILFILE
%
% INFODIRHEADFILE = $(LIBDIR)/Head_generic.info
infodir_headfile := ~atom_concat( [ ~lpdoclib , '/Head_clip.info' ] ).
% INFODIRTAILFILE = $(LIBDIR)/Tail_generic.info
infodir_tailfile := ~atom_concat( [ ~lpdoclib , '/Tail_clip.info' ] ).
% ----------------------------------------------------------------------------
% end of SETTINGS
