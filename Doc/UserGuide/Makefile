

all: UserGuide.pdf

FIGURES = ICTP_logo.eps
TEXFILES = Appendices.tex Install.tex ObtainCode.tex ObtainData.tex \
					 ReleaseNotes.tex TestRun.tex AdvancedConfig.tex \
					 ReportProblem.tex PostProcess.tex
BIBFILES = references.bib

UserGuide.pdf: UserGuide.tex $(TEXFILES) $(BIBFILES) $(FIGURES)
	pdflatex UserGuide
	bibtex UserGuide
	pdflatex UserGuide
	pdflatex UserGuide

clean:
	  rm -f *.aux *.dvi *.pdf *.log *.toc *.lof *.lot *.bbl *.blg
