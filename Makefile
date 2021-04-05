PYTHON=python
LATEX=xelatex
OUTDIR=output
ifdef PDF_LINK
LINK=--pdf_link $(PDF_LINK)
else
LINK=
endif

ENV_NAME = resume

ifeq (,$(shell which conda))
HAS_CONDA=False
else
HAS_CONDA=True
CONDA := $(shell pyenv which conda || which conda)
ifeq ($(CONDA_DEFAULT_ENV),$(ENV_NAME))
ENV_IS_ACTIVE=True
else
ENV_IS_ACTIVE=False
endif
endif

all: html md pdf pdf_short

outdir:
	mkdir -p $(OUTDIR)

install_tex: outdir
	cp Awesome-CV/awesome-cv.cls $(OUTDIR)
	cp Awesome-CV/fontawesome.sty $(OUTDIR)
	cp -r Awesome-CV/fonts $(OUTDIR)

html: outdir
	$(PYTHON) build_cv.py --html_out_file $(OUTDIR)/cv.html $(LINK)

md: outdir
	$(PYTHON) build_cv.py --md_out_file $(OUTDIR)/cv.md $(LINK)

tex: outdir
	$(PYTHON) build_cv.py --tex_out_file $(OUTDIR)/cv.tex

tex_short: outdir
	$(PYTHON) build_cv.py --tex_short_out_file $(OUTDIR)/cv-short.tex

pdf: install_tex tex
	cd $(OUTDIR); $(LATEX) cv.tex; cd ..

pdf_short: install_tex tex_short
	cd $(OUTDIR); $(LATEX) cv-short.tex; cd ..

clean:
	rm -r $(OUTDIR)

## create conda environment
conda-create-env:
ifeq (True,$(HAS_CONDA))
	@printf ">>> Creating '$(ENV_NAME)' conda environment. This could take a few minutes ...\n\n"
	@$(CONDA) env create --name $(ENV_NAME) --file environment.yml
	@printf ">>> Adding the project to the environment...\n\n"
else
	@printf ">>> conda command not found. Check out that conda has been installed properly."
endif

## update conda environment
conda-update-env:
ifeq (True,$(HAS_CONDA))
	@printf ">>> Updating '$(ENV_NAME)' conda environment. This could take a few minutes ...\n\n"
	@$(CONDA) env update --name $(ENV_NAME) --file environment.yml --prune
	@printf ">>> Updated.\n\n"
else
	@printf ">>> conda command not found. Check out that conda has been installed properly."
endif
