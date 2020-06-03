SHELL := /bin/bash
RM := rm -f
LATEXMK_FLAGS = --pdf --cd

doc := slides

all: $(doc).pdf

$(doc).pdf: $(doc).tex references.bib
	latexmk $(LATEXMK_FLAGS) --jobname="$(basename $@)" $<

clean: clean_latex
clean_latex:
	@(\
		shopt -s globstar;\
		$(RM) **/*.pdf;\
		$(RM) **/*.aux **/*.log **/*.fls **/*.out;\
		$(RM) **/*.fdb_latexmk;\
		$(RM) **/*.bbl **/*.bcf **/*.blg **/*.run.xml;\
		$(RM) **/*.nav **/*.snm **/*.toc;\
	)

.PHONY: all submit clean clean_latex

###############
#Spellchecking.
###############

aspell_personal_dict := ./.aspell.en.personal
aspell_check_files := $(doc).tex

spellcheck:
	@for file in $(aspell_check_files); do \
		aspell check --mode=tex --tex-check-comments --dont-backup --personal=$(aspell_personal_dict) $$file;\
	done

##########
#Submodule
##########

subdir := biol375-report
submake := make -C $(subdir)

$(subdir)/Makefile:
	git submodule update --init --recursive

$(subdir)/figures/%: $(subdir)/Makefile
	$(submake)
