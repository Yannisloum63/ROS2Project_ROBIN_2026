
\RequirePackage{silence}
\WarningFilter{latex}{You have requested package `../sty/imta'}
\WarningFilter{latex}{You have requested package `../sty/awasomebox'}

\def\imta@CLASSNAME{imta}
\def\imta@VERSION{3.5}
\def\imta@DATE{2018/11/27}
\def\imta@DATE@fr{27/11/2018}
\def\imta@AUTHOR{Charles DUCHÊNE, Guillaume ANSEL, Thierry LE GALL (SC), Thomas GUILMENT}
\NeedsTeXFormat{LaTeX2e}
\LoadClass[]{article}

\ProvidesClass{\imta@CLASSNAME}[\imta@DATE]

\RequirePackage{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{awesomebox}
\RequirePackage{newtxtext} % Police pour texte
\RequirePackage{newtxmath} % Police pour formules
\RequirePackage{textcomp}
\RequirePackage{graphicx}
\RequirePackage{amsmath}
\RequirePackage{microtype}
\RequirePackage{listings}

\RequirePackage{framed}	% Permet de surligner les résultats importants

\RequirePackage[colorlinks=true,linkcolor=black,urlcolor=blue,citecolor=IMTAbleu]{hyperref}
\RequirePackage[svgnames]{xcolor}
\RequirePackage[page,toc]{appendix}
\RequirePackage[compact,pagestyles]{titlesec}
\RequirePackage[dotinlabels]{titletoc}
\RequirePackage{setspace}
\RequirePackage{eso-pic}
\RequirePackage[overlay,absolute]{textpos}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage{newtxmath}
\RequirePackage{caption}
\RequirePackage{multicol}
\RequirePackage{tcolorbox} % Permet d'inclure des blocs de style "beamer" dans un document de classe "article"
\RequirePackage{booktabs}
% \RequirePackage[calc, useregional]{datetime2} % Définition de formats de dates personalisés
\tcbuselibrary{skins,breakable}

%----------------- Déclaration des options du package ----------------

\DeclareOption{version}{\PackageWarning{imta}{L'option "version" est obsolète. Le numéro de version est affiche automatiquement si la commande \protect \version{} est utilisée}}

% Option copyright
% Affichage de la mention « © IMT Atlantique ... » sur la dernière de couverture
\newif\if@IMTAcopyright \@IMTAcopyrightfalse
\DeclareOption{copyright}{\@IMTAcopyrighttrue}

\ProcessOptions

%--------------- Fin déclaration des options du package --------------


%------------------------- BUGFIX_21092017_1 -------------------------
\usepackage{etoolbox}
\patchcmd{\ttlh@hang}{\parindent\z@}{\parindent\z@\leavevmode}{}{}
\patchcmd{\ttlh@hang}{\noindent}{}{}{}
%---------------------------------------------------------------------


\addto\captionsfrench{
	\renewcommand{\contentsname}{Sommaire}
	\renewcommand{\listfigurename}{Liste des figures}
	\renewcommand{\listtablename}{Liste des tableaux}
	\renewcommand{\refname}{Références}
	\renewcommand{\appendixtocname}{Annexes}
	\renewcommand{\appendixpagename}{Annexes}
}

% Définition des couleurs selon la charte IMTA
\definecolor{IMTAbleu}{RGB}{0,184,222}
\definecolor{IMTAbleumarine}{RGB}{12,35,64}
\definecolor{IMTAvert}{RGB}{164,210,51}
\definecolor{IMTAcaption}{RGB}{50,184,222}
% Anciennes couleurs TB
\definecolor{TBvert}{RGB}{168,181,10}
\definecolor{TBbrun}{RGB}{109,80,71}

% Application des paramètres de police et de couleur pour les légendes
\DeclareCaptionFont{TBcaption}{\color{IMTAcaption}}
\captionsetup{labelfont={TBcaption},textfont={TBcaption}}

% Format des titres dans le corps du document (cf. package titlesec)
\titleformat{\section}{\Large\bfseries}{\thesection.}{1em}{}
\titleformat{\subsection}{\large\bfseries\color{IMTAbleu}}{\hspace{1em}\thesubsection.}{1em}{}
\titleformat{\subsubsection}{\bfseries\color{IMTAbleumarine}}{\hspace{2em}\thesubsubsection.}{1em}{}
\titleformat{\paragraph}{\itshape\bfseries}{}{}{}

% Définition de niveaux de titres supplémentaires pour les annexes
\newcommand{\IMTAsubsubsubsection}{}

% Déclaration de commande de section IMTAsubsubsubsection (utilisée pour les sous-sous-sections (subsubsection) dans les annexes)
\titleclass{\IMTAsubsubsubsection}{straight}[\subsubsection]
\newcounter{IMTAsubsubsubsection}[subsubsection]
\renewcommand{\theIMTAsubsubsubsection}{\thesubsubsection.\arabic{IMTAsubsubsubsection}}
\titlespacing{\IMTAsubsubsubsection}{0pt}{*1}{*1}


% Ajustement des niveaux de section des différents types de sections créés et des paragraphes
\def\toclevel@IMTAsubsubsubsection{4}
\def\toclevel@paragraph{5}
\def\toclevel@subparagraph{6}
\def\l@IMTAsubsubsubsection{\@dottedtocline{4}{7em}{4em}}
\def\l@paragraph{\@dottedtocline{5}{10em}{5em}}
\def\l@subparagraph{\@dottedtocline{6}{14em}{6em}}

% Modification du niveau jusqu'au quel on affiche les numéros dans les titres (eg. 2.1.1.)
% On veut pouvoir voir les numéros des sous-sous sections dans les annexes (correspond au niveau 4)
\setcounter{secnumdepth}{4}

% Format des titres dans la table des matières (cf. package titletoc)
\titlecontents{section}[0em]{\vspace{0.8em}\bfseries\large}{\thecontentslabel. \hspace{0.5em}}{}{\normalfont\titlerule*[5pt]{.}\contentspage[\bfseries\thecontentspage]}
\titlecontents{subsection}[1.8em]{\large}{\thecontentslabel. \hspace{0.5em}}{}{\normalfont\titlerule*[5pt]{.}\contentspage[\thecontentspage]}
\titlecontents{subsubsection}[4.6em]{}{\thecontentslabel. \hspace{0.5em}}{}{\normalfont\titlerule*[5pt]{.}\contentspage}

% Marges
\geometry{paper=a4paper,
	headheight=0.5cm,
	headsep=0.6cm,
	foot=0.7cm,
	vmargin=2.8cm,
	hmargin=2.4cm
}

% Commande pour avoir l'année courante
\newcommand{\currentyear}{\@dtm@year}
% Commande pour avoir le mois et l'année courante
\newcommand{\currentmonthyear}{\DTMMonthname{\@dtm@month} \@dtm@year}

% Commande pour le site web IMT Atlantique
\newcommand{\urlimta}{www.imt-atlantique.fr}

% Commande pour le site web CreativeCommons
\newcommand{\urlcclicence}{https://creativecommons.org/choose/}

% Commandes pour les adresses d'IMT Atlantique sur les réseaux sociaux
\newcommand{\urllinkedin}{https://www.linkedin.com/school/imt-atlantique/}
\newcommand{\urlinstagram}{https://www.instagram.com/imt_atlantique/}
\newcommand{\urlfacebook}{https://www.facebook.com/IMTAtlantique}
\newcommand{\urlyoutube}{https://www.youtube.com/channel/UCHFJUaLfnNx1jXlnXcEUtcw}

% Commandes pour l'affichage des URLs
\newcommand{\URLimta}{\textbf{\href{\urlimta}{\urlimta}}}
\newcommand{\URLcclicence}{\href{\urlcclicence}{\textcolor{blue}{\urlcclicence}}}

\newcommand{\URLlinkedin}{\href{\urllinkedin}{\includegraphics[height=1.0cm]{ico/linkedin.png}}}
\newcommand{\URLinstagram}{\href{\urlinstagram}{\includegraphics[height=1.0cm]{ico/instagram.png}}}
\newcommand{\URLfacebook}{\href{\urlfacebook}{\includegraphics[height=1.0cm]{ico/facebook.png}}}
\newcommand{\URLyoutube}{\href{\urlyoutube}{\includegraphics[height=1.0cm]{ico/youtube.png}}}

% Commande pour l'adresse email générique de la DRI
\newcommand{\emailDRI}{science-ouverte@imt-atlantique.fr}

% Commande pour l'affichage de l'adresse email générique de la DRI
\newcommand{\EMAILDRI}{\href{mailto:\emailDRI}{\emph{\textcolor{blue}{\underline{\emailDRI}}}}}

% définition de nouvelles macros pour le document
% Bloc "Entité" en haut à gauche de la couverture
\def\@entity{}
\newcommand{\entity}[1]{\gdef\@entity{#1}}

% Version du document sur la couverture
\newif\if@Version \@Versionfalse
\def\@version{}
\newcommand{\version}[1]{\@Versiontrue\gdef\@version{#1}}

% Description du document, sous le titre
\def\@description{}
\newcommand{\docdescription}[1]{\gdef\@description{#1}}

% Année de copyright, sur la mention copyright sur la 4eme de couverture
\def\@IMTAanneecopyright{\currentyear}
\newcommand{\IMTAanneecopyright}[1]{\gdef\@IMTAanneecopyright{#1}}

% Mois et année de dépot légal, sur la mention copyright de la 4eme de couverture
\def\@IMTAdepotlegal{\currentmonthyear}
\newcommand{\IMTAdepotlegal}[1]{\gdef\@IMTAdepotlegal{#1}}

% Numéro de ISSN, sur la mention copyright de la 4eme de couverture
\def\@IMTAissn{n° ISSN}
\newcommand{\IMTAissn}[1]{\gdef\@IMTAissn{#1}}

% Type de document
\def\@documentType{}
\newcommand{\DocumentType}[1]{\gdef\@documentType{#1}}

% Liste de contributeurs
\def\@contributors{}
\newcommand{\contributors}[1]{\gdef\@contributors{\\[0.8\baselineskip]#1}}

% Numéro de rapport de recherche, sous le type de document sur la couverture
\def\thereportnumber{}
\newcommand{\ReportNumber}[1]{\gdef\thereportnumber{#1}}

% Mention support
\def\mentionsupport{}
\newcommand{\MentionSupport}[1]{\gdef\mentionsupport{#1}}

% Mention spéciale
\def\mentionspeciale{}
\newcommand{\MentionSpeciale}[1]{\gdef\mentionspeciale{#1}}

% Copyright
\def\imtcopyright{}
\newcommand{\IMTCopyright}[1]{\gdef\imtcopyright{#1}}

%Macro pour le contenu du pied de page
\def\@IMTAfooter{\@title}
\newcommand{\IMTAfooter}[1]{\gdef\@IMTAfooter{#1}}

% Définition du style des en-têtes et des pieds de page
\newpagestyle{IMTAfancy}{%
	\headrule % Affichage ligne de séparation de l'en-tête
	\footrule % Affichage ligne de séparation du pied de page

	% Définition en-tête
	\sethead{\bottitlemarks\textit{\ifthesection{\thesection.~}{}\sectiontitle}} % Titre et numéro de section en haut à gauche en italique
	{} % Rien au milieu
	%{\bottitlemarks\textit{\ifthesubsection{\thesubsection.~}{}\subsectiontitle}} % Titre et numéro de sous-section en haut à droite en italique (mise à jour 2.6)
	{\mentionspeciale} % mention en haut à droite
	% Définition pied de page
	\setfoot{\textit{\@IMTAfooter}} % Description fournie par l'utilisateur
	{} % Rien au milieu
	{\thepage/\pageref{LastPage}} % Numéro de page en bas à droite et nombre total de pages
}

% Définition de la command \and pour séparer plusieurs auteurs : saut de ligne
\renewcommand\and{\\[0.3\baselineskip]}

% Définition de la page de couverture : redéfinition de maketitle
\renewcommand{\maketitle}{
	% Numéro de page alphabétique sur la première page pour éviter un warning de numéro de page dupliqué
	\pagenumbering{gobble}
	% Imprime le logo IMTA sur la première de couverture
	\AddToShipoutPicture*{\unitlength=1cm
		\put(2,2){\includegraphics[width=5cm]{ico/imta_logo}}}
	% Imprime les triangles sur la première de couverture
	\AddToShipoutPicture*{\unitlength=1cm
		\put(11,19.7){\includegraphics[width=9cm]{ico/imta_triangles}}}

	% Affichage auteurs
	%\begin{textblock*}{13cm}[0, 0.6](2cm, 10.5cm)
	\begin{textblock*}{13cm}[0, 0.6](2cm, 16.5cm) % liste des auteurs et contributeurs sous le titre
		\noindent
		\begin{minipage}[b]{13cm}
			\large
			\@author
			\@contributors
		\end{minipage}
	\end{textblock*}

	% Affichage nom et adresse établisemment
	\begin{textblock*}{7cm}(2cm, 1cm)
		\noindent
		\begin{minipage}[t]{8 cm}
			\noindent\@entity
		\end{minipage}
	\end{textblock*}

	% Marges
	%\newgeometry{top=14cm,left=2cm,right=2cm,bottom=6cm}
	\newgeometry{top=8cm,left=2cm,right=2cm,bottom=6cm}
	\thispagestyle{empty}

	% Titre, description, date d'édition et version document
	\begin{titlepage}

	  	\noindent
		\textbf{\@documentType} % imprime le type de document

		\noindent
		\thereportnumber % imprime le numéro du rapport

		\vspace{0.5cm}
		\noindent
		\mentionsupport % imprime la mention support

		\vspace{0.5cm}
		\noindent
%		\underline{Niveau de classification}: \mentionspeciale % imprime la mention speciale
		\mentionspeciale % imprime la mention speciale

		\bigskip
	  	\bigskip
		\begin{flushleft}
			{\huge \bfseries \textcolor{IMTAvert}{\@title}\bigskip}
		\end{flushleft}

		\bigskip
		\noindent
		\@description

		\vfill

		\bigskip
		\noindent Date d'édition :~\@date % imprime la date courante
		\if@Version	% n'imprime la version que si l'option « version » est spécifiée
		\\\noindent Version :~\@version
		\fi

	\end{titlepage}
	\restoregeometry
	\ClearShipoutPicture
	\clearpage
	\pagenumbering{arabic}

	% RAZ du compteur de page (la première ne compte pas)
	\setcounter{page}{1}

	% item, fait maintenant uniquement car babel redéfinit les étiquettes
	\renewcommand{\labelitemi}{\raisebox{.3ex}{\tiny $\blacksquare$}}
}
% alias \IMTAfrontcover pour maketitle
\newcommand{\IMTAfrontcover}{\maketitle}

% Dernière de couverture
\newcommand{\IMTAcoverpage}{
	\label{LastPage}
	\clearpage

	% Saut de page optionnel pour s'assurer que l'on soit bien sur la 4eme de couverture (page paire)
	\ifodd\value{page}\else\null\thispagestyle{empty}\clearpage\fi

	\thispagestyle{empty}

	% imprime la carte des implantations, les réseaux sociaux et le logo IMT sur la dernière de couverture
	\AddToShipoutPicture*{\unitlength=1cm
		\put(2, 17.0){\includegraphics[width=17cm]{ico/imta_map.png}}
		\put(2, 6.0){\URLlinkedin}
		\put(3.25, 6.0){\URLinstagram}
		\put(4.5, 6.0){\URLfacebook}
		\put(5.75, 6.0){\URLyoutube}
		\put(2, 2.0){\includegraphics[width=5cm]{ico/imta_logo}}
	}

	% Imprime les informations de copyright si l'option "copyright" est présente
	\if@IMTAcopyright
	\begin{textblock*}{6cm}[1,1](19cm, 27.7cm)
		\noindent
		\small
		\begin{minipage}[b]{6 cm}
			\flushright
%			\copyright~IMT Atlantique, \@IMTAanneecopyright\\
%			Imprimé à IMT Atlantique\\
%			Dépôt légal : \@IMTAdepotlegal\\
%			ISSN : \@IMTAissn
			\imtcopyright
		\end{minipage}
	\end{textblock*}
	\fi

	% marges
	\newgeometry{top=13cm, left=2cm, right=1cm, bottom=4cm}

	% imprime les adresses et les numéros de tel. des campus et des sites
	\begin{center}
		\footnotesize
		IMT Atlantique Bretagne--Pays de la Loire -- \textbf{\href{http://www.imt-atlantique.fr/}{http://www.imt-atlantique.fr/}}

		\begin{multicols*}{3}

		\begin{flushleft}
		\textbf{Campus de Brest}\\
		Technopôle Brest-Iroise\\
		CS 83818\\
		29238 Brest Cedex 3\\
		France\\
		T +33 (0)2 29 00 11 11\\
		F +33 (0)2 29 00 10 00
		\end{flushleft}
		\columnbreak

		\begin{flushleft}
		\textbf{Campus de Nantes}\\
		4, rue Alfred Kastler\\
		CS 20722\\
		44307 Nantes Cedex 3\\
		France\\
		T +33 (0)2 51 85 81 00\\
		F +33 (0)2 99 12 70 08
		\end{flushleft}
		\columnbreak

		\begin{flushleft}
		\textbf{Campus de Rennes}\\
		2, rue de la Châtaigneraie\\
		CS 17607\\
		35576 Cesson Sévigné Cedex\\
		France\\
		T +33 (0)2 99 12 70 00\\
		F +33 (0)2 51 85 81 99
		\end{flushleft}
		\columnbreak

		\end{multicols*}
	\end{center}
}

% Commandes pour générer sommaire, liste des figures et des tableaux
\newcommand{\IMTAsommaire}{%
	% Formattage du titre "Sommaire", cf http://tex.stackexchange.com/questions/83378/babel-and-contentsname-how-to-add-extra-customization
	\renewcommand{\tableofcontents}{%
		\noindent{\bfseries\centering\Large\color{IMTAbleu}\contentsname\par}%
		\sectionmark{\contentsname}
		\@starttoc{toc}
	}
	\tableofcontents
}
\newcommand{\IMTAlistefigures}{
	\renewcommand{\listoffigures}{%
		\noindent{\bfseries\centering\Large\color{IMTAbleu}\listfigurename\par}%
		\sectionmark{\listfigurename}
		\vspace{5mm}%
		\@starttoc{lof}
		\vspace{5mm}%
	}
	\listoffigures
}
\newcommand{\IMTAlistetableaux}{
	\renewcommand{\listoftables}{%
		\noindent{\bfseries\centering\Large\color{IMTAbleu}\listtablename\par}%
		\sectionmark{\listtablename}
		\vspace{5mm}%
		\@starttoc{lot}
	}
	\listoftables
}

% ---------- Début déclaration commandes pour Bibliographie ----------
\newcommand{\IMTAbiblioname}{Références}
% ----------- Fin déclaration commandes pour Bibliographie -----------

% ------------- Début déclaration commandes pour Annexes -------------

\newcommand{\IMTAdebutannexes}{
	\addtocontents{toc}{\protect\setcounter{tocdepth}{3}}
	\clearpage

	\let\appendixpagenameorig\appendixpagename
	\renewcommand{\appendixpagename}{\centering\textcolor{IMTAbleu}{\Large\textbf{\appendixpagenameorig}}}

	% "Bricolage" : on définit une nouvelle commande IMTAannexe pour commencer chaque annexe, en réalité une section
	% On décale les autres niveaux de section pour que la commande \section (en réalité \subsection) ait le même style que dans le reste du document
	% De même pour \subsection, etc.
	\let\@oldsection\section
	\let\@oldsubsection\subsection
	\let\@oldsubsubsection\subsubsection
	\let\TBannexe\section
	\let\IMTAannexe\TBannexe
	\let\section\subsection
	\let\subsection\subsubsection
	\let\subsubsection\IMTAsubsubsubsection
	\titleformat{\section}{\Large\bfseries\color{IMTAbleumarine}\centering}{\appendixname~\thesection\enskip--}{0.5em}{\vspace{0.5em}}
	\titleformat{\subsection}{\Large\bfseries}{\thesubsection.}{1em}{}
	\titleformat{\subsubsection}{\large\bfseries\color{IMTAbleu}}{\hspace{1em}\thesubsubsection.}{1em}{}
	\titleformat{\IMTAsubsubsubsection}{\bfseries\color{IMTAbleumarine}}{\hspace{2em}\theIMTAsubsubsubsection.}{1em}{}
	\titlecontents{section}[0em]{\vspace{0.8em}\bfseries\large}{Annexe \thecontentslabel~--~}{}{\normalfont\titlerule*[5pt]{.}\contentspage[\bfseries\thecontentspage]}
}

\newcommand{\IMTAfinannexes}{
	% On restore le comportement d'origine des commandes \section, ...
	\let\section\@oldsection
	\let\subsection\@oldsubsection
	\let\subsubsection\@oldsubsubsection
	\titleformat{\section}{\Large\bfseries}{\thesection.}{1em}{}
	\titleformat{\subsection}{\large\bfseries\color{IMTAbleu}}{\hspace{1em}\thesubsection.}{1em}{}
	\titleformat{\subsubsection}{\bfseries\color{IMTAbleumarine}}{\hspace{2em}\thesubsubsection.}{1em}{}
	\titlecontents{section}[0em]{\vspace{0.8em}\bfseries\large}{\thecontentslabel. \hspace{0.5em}}{}{\normalfont\titlerule*[5pt]{.}\contentspage[\bfseries\thecontentspage]}
}

% Définition de l'environnement des annexes
\newenvironment{IMTAannexes}{
	\IMTAdebutannexes
	\begin{appendices}
		% Utilisation de nombres pour numéroter les annexes (BUGFIX_21092017_2)
		\renewcommand{\theHsection}{\theH@pps.\arabic{section}}
		\renewcommand\thesection{\arabic{section}}
	}
	{
	\end{appendices}
	\IMTAfinannexes
}

% -------------- Fin déclaration commandes pour Annexes --------------

% ------------ Déclaration d'environnement pour les blocs ------------

\newenvironment{beamerblock}[1]{%
	\tcolorbox[beamer,%
	noparskip,breakable,
	colback=White, colframe=IMTAbleu,%
	colbacklower=LightBlue!10!LightBlue,%
	title=#1]}%
{\endtcolorbox}

% ------------------------- Dossier des images ----------------------

\graphicspath{{img/}{../img/}}

\AtBeginDocument{
\IMTAfrontcover
\pagestyle{IMTAfancy} % Changement du style de page pour avoir en-tête et pied de page

%% Affichage des listes et tables.
\IMTAsommaire
\newpage
\IMTAlistefigures
\IMTAlistetableaux
\newpage
}

\AtEndDocument{
\IMTAcoverpage
}



\BeforeBeginEnvironment{document}{
\makeatletter
\hypersetup{
   pdfauthor   = {\@author},
   pdfcreator   = {\@author},
   pdftitle    = {\@title},
}
\makeatother
}

\entity{\textbf{\large{IMT Atlantique}}\\
	Dépt. Automatique productique et informatique\\
	4, rue Alfred Kastler\\
	CS 20722\\
	44307 Nantes Cedex 3\\
	Téléphone: +33 (0)2 51 85 81 00\\
	Télécopie: +33 (0)2 99 12 70 08\\
URL: \URLimta
}


\RequirePackage{verbatim}
\RequirePackage{fancyvrb}

\RequirePackage[framemethod=tikz]{mdframed}
\definecolor{MyDarkGreen}{rgb}{0.0,0.4,0.0}

\lstnewenvironment{bash}{
  \lstset{language=bash,                        % Use MATLAB
        basicstyle=\small\ttfamily,             % Use small true type font
        keywordstyle=[1]\color{Blue}\bfseries,  % MATLAB functions bold and blue
        keywordstyle=[2]\color{Purple},         % MATLAB function arguments purple
        keywordstyle=[3]\color{Blue}\underbar,  % User functions underlined and blue
        identifierstyle=,                       % Nothing special about identifiers
                                                % Comments small dark green courier
        commentstyle=\usefont{T1}{pcr}{m}{sl}\color{MyDarkGreen}\small,
        stringstyle=\color{Purple},             % Strings are purple
        showstringspaces=false,                 % Don't put marks in string spaces
        tabsize=4,                              % 5 spaces per tab
        %
        %%% Put standard MATLAB functions not included in the default
        %%% language here
        morekeywords={xlim,ylim,var,alpha,factorial,poissrnd,normpdf,normcdf,colon,switch,case,otherwise},
        %
        %%% Put MATLAB function parameters here
        morekeywords=[2]{on, off, interp},
        %
        %%% Put user defined functions here
        morekeywords=[3]{},
        %
        morecomment=[l][\color{Blue}]{...},     % Line continuation (...) like blue comment
        % numbers=left,                           % Line numbers on left
        % firstnumber=1,                          % Line numbers start with line 1
        % numberstyle=\tiny\color{Blue},          % Line numbers are blue
        % stepnumber=5                            % Line numbers go in steps of 5
        }
}{}
\lstnewenvironment{python}{
  \lstset{language=Python,                        % Use MATLAB
        basicstyle=\small\ttfamily,             % Use small true type font
        keywordstyle=[1]\color{Blue}\bfseries,  % MATLAB functions bold and blue
        keywordstyle=[2]\color{Purple},         % MATLAB function arguments purple
        keywordstyle=[3]\color{Blue}\underbar,  % User functions underlined and blue
        identifierstyle=,                       % Nothing special about identifiers
                                                % Comments small dark green courier
        commentstyle=\usefont{T1}{pcr}{m}{sl}\color{MyDarkGreen}\small,
        stringstyle=\color{Purple},             % Strings are purple
        showstringspaces=false,                 % Don't put marks in string spaces
        tabsize=4,                              % 5 spaces per tab
        %
        %%% Put standard MATLAB functions not included in the default
        %%% language here
        morekeywords={xlim,ylim,var,alpha,factorial,poissrnd,normpdf,normcdf,colon,switch,case,otherwise},
        %
        %%% Put MATLAB function parameters here
        morekeywords=[2]{on, off, interp},
        %
        %%% Put user defined functions here
        morekeywords=[3]{},
        %
        morecomment=[l][\color{Blue}]{...},     % Line continuation (...) like blue comment
        % numbers=left,                           % Line numbers on left
        % firstnumber=1,                          % Line numbers start with line 1
        % numberstyle=\tiny\color{Blue},          % Line numbers are blue
        % stepnumber=5                            % Line numbers go in steps of 5
        }
}{}

  \lstset{language=C++,                        % Use MATLAB
        basicstyle=\small\ttfamily,             % Use small true type font
        keywordstyle=[1]\color{Blue}\bfseries,  % MATLAB functions bold and blue
        keywordstyle=[2]\color{Purple},         % MATLAB function arguments purple
        keywordstyle=[3]\color{Blue}\underbar,  % User functions underlined and blue
        identifierstyle=,                       % Nothing special about identifiers
                                                % Comments small dark green courier
        commentstyle=\usefont{T1}{pcr}{m}{sl}\color{MyDarkGreen}\small,
        stringstyle=\color{Purple},             % Strings are purple
        showstringspaces=false,                 % Don't put marks in string spaces
        tabsize=4,                              % 5 spaces per tab
        %
        %%% Put standard MATLAB functions not included in the default
        %%% language here
        morekeywords={xlim,ylim,var,alpha,factorial,poissrnd,normpdf,normcdf,colon,switch,case,otherwise},
        %
        %%% Put MATLAB function parameters here
        morekeywords=[2]{on, off, interp},
        %
        %%% Put user defined functions here
        morekeywords=[3]{},
        %
        morecomment=[l][\color{Blue}]{...},     % Line continuation (...) like blue comment
        % numbers=left,                           % Line numbers on left
        % firstnumber=1,                          % Line numbers start with line 1
        % numberstyle=\tiny\color{Blue},          % Line numbers are blue
        % stepnumber=5                            % Line numbers go in steps of 5
        }
\lstnewenvironment{matlab}{
  \lstset{language=Matlab,                        % Use MATLAB
        basicstyle=\small\ttfamily,             % Use small true type font
        keywordstyle=[1]\color{Blue}\bfseries,  % MATLAB functions bold and blue
        keywordstyle=[2]\color{Purple},         % MATLAB function arguments purple
        keywordstyle=[3]\color{Blue}\underbar,  % User functions underlined and blue
        identifierstyle=,                       % Nothing special about identifiers
                                                % Comments small dark green courier
        commentstyle=\usefont{T1}{pcr}{m}{sl}\color{MyDarkGreen}\small,
        stringstyle=\color{Purple},             % Strings are purple
        showstringspaces=false,                 % Don't put marks in string spaces
        tabsize=4,                              % 5 spaces per tab
        %
        %%% Put standard MATLAB functions not included in the default
        %%% language here
        morekeywords={xlim,ylim,var,alpha,factorial,poissrnd,normpdf,normcdf,colon,switch,case,otherwise},
        %
        %%% Put MATLAB function parameters here
        morekeywords=[2]{on, off, interp},
        %
        %%% Put user defined functions here
        morekeywords=[3]{},
        %
        morecomment=[l][\color{Blue}]{...},     % Line continuation (...) like blue comment
        % numbers=left,                           % Line numbers on left
        % firstnumber=1,                          % Line numbers start with line 1
        % numberstyle=\tiny\color{Blue},          % Line numbers are blue
        % stepnumber=5                            % Line numbers go in steps of 5
        }
}{}
\RequirePackage{color}                     
                                           
\definecolor{output}{gray}{0.4}            

\newenvironment{result}{%
  \Verbatim[xleftmargin=1.25em, formatcom=\color{output}]%
}{\endVerbatim}
\newenvironment{resultError}{%
  \Verbatim[xleftmargin=1.25em, formatcom=\color{red}]%
}{\endVerbatim}



\mdfdefinestyle{sourcecode}{%
  outerlinewidth=.5pt,
  linecolor=gray!20!white,
  roundcorner=2pt,
  innertopmargin=.25\baselineskip,
  innerbottommargin=0,
  innerleftmargin=1em,
  backgroundcolor=gray!10!white
}
\mdfdefinestyle{terminal}{%
  outerlinewidth=.5pt,
  linecolor=gray!20!white,
  roundcorner=2pt,
  innertopmargin=.25\baselineskip,
  innerbottommargin=0,
  innerleftmargin=1em,
  backgroundcolor=gray!50!white
}

\newenvironment{sourcecode}{}{}
\surroundwithmdframed[style=terminal]{bash}
\surroundwithmdframed[style=sourcecode]{matlab}
\surroundwithmdframed[style=sourcecode]{python}
\surroundwithmdframed[style=sourcecode]{sourcecode}

\endinput
