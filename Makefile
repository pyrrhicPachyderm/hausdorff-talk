SHELL := /bin/bash
RM := rm -f
LATEXMK_FLAGS = --pdf --cd

doc := slides

all: $(doc).pdf

###########
#Submodule.
###########

subdir := biol375-report
submake := make -C $(subdir)

$(subdir)/Makefile:
	git submodule update --init --recursive

$(subdir)/figures/%: $(subdir)/Makefile
	$(submake)

##########
#Document.
##########

images := $(patsubst %.svg,%.png,$(wildcard images/*.svg)) $(subdir)/figures/site-ordination.pdf

$(doc).pdf: $(doc).tex references.bib $(images)
	latexmk $(LATEXMK_FLAGS) --jobname="$(basename $@)" $<

clean: clean_latex clean_images
clean_latex:
	@(\
		shopt -s globstar;\
		$(RM) **/*.pdf;\
		$(RM) **/*.aux **/*.log **/*.fls **/*.out;\
		$(RM) **/*.fdb_latexmk;\
		$(RM) **/*.bbl **/*.bcf **/*.blg **/*.run.xml;\
		$(RM) **/*.nav **/*.snm **/*.toc;\
	)
clean_images:
	@(\
		shopt -s globstar;\
		$(RM) **/*.png;\
	)

.PHONY: all clean clean_latex clean_images

%.png: %.svg
	inkscape -z $< -e $@ -w 1024 -h 1024

###############
#Spellchecking.
###############

aspell_personal_dict := ./.aspell.en.personal
aspell_check_files := $(doc).tex

spellcheck:
	@for file in $(aspell_check_files); do \
		aspell check --mode=tex --tex-check-comments --dont-backup --personal=$(aspell_personal_dict) $$file;\
	done
