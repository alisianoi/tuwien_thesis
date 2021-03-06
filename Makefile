BASENAME=thesis
DISTNAME=thesis_latex
DISTFOLDER?=$(shell pwd)

# OS detection
OS=$(shell uname)

# pdf viewer
ifeq ($(OS), Darwin)
	VIEWER=open
	VIEWER_OPTIONS=
else
	VIEWER=xdg-open
	VIEWER_OPTIONS=
endif


.PHONY: default
default: clean compile

compile:
	pdflatex -shell-escape $(BASENAME)
	makeglossaries $(BASENAME)
	pdflatex -shell-escape $(BASENAME)
	makeglossaries $(BASENAME)
	bibtex $(BASENAME)
	pdflatex -shell-escape $(BASENAME)
	pdflatex -shell-escape $(BASENAME)

view:
	$(VIEWER) $(VIEWER_OPTIONS) $(BASENAME).pdf

zip: clean compile
	zip -9 -r --exclude=*.svn* $(BASENAME).zip figures abbrev bibliography chapters styles $(BASENAME).tex INSOthesis.cls Makefile README.txt $(BASENAME).pdf

dist: zip
	cp $(BASENAME).zip $(DISTFOLDER)/$(DISTNAME).zip

.PHONY: clean
clean:
	find . -type f  -not \( -name "${BASENAME}.tex" -o -name "*.backup" -o -name "*svn-base" \) -name "${BASENAME}*" -delete -print
	find . -type f -name '*.aux' -delete -print
	find . -type f -name '*.log' -delete -print
