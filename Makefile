
OUTPUT_MD=merged.md
OUTPUT_NAME=GettingStartedWithLedger
OUTPUT_PDF=$(OUTPUT_NAME).pdf
OUTPUT_HTML=$(OUTPUT_NAME).html
OUTPUT_TEX=$(OUTPUT_NAME).tex
OUTPUT_EPUB=$(OUTPUT_NAME).epub
PANDOC_EXEC=pandoc # run >= 1.15
PANDOC_LATEX_ARGS=-V geometry:"top=2cm, bottom=1.5cm, left=1cm, right=1cm" -V linkcolor=blue -V urlcolor=blue
# pandoc highlight style
# Options are `pygments` (the default), `kate`, `monochrome`, `espresso`, `zenburn`, `haddock`, and `tango`.
# zenburn, espresso, haddock
PANDOC_SYNTAX_HIGHLIGHT=--highlight-style=zenburn # --no-highlight
# Use ":=" instead of "=" to only execute once
GITSHA:=$(shell git rev-parse --short HEAD)
TODAY:=$(shell date "+%d %B %Y")
TMP_DIR=./tmp
TMP_BEFORE_TEX=$(TMP_DIR)/before.tex
TMP_EPUB_TITLE=$(TMP_DIR)/epub_title.txt
TMP_HTML_HEADER=$(TMP_DIR)/html_header.html
PANDOC_ARGS= --number-sections $(PANDOC_LATEX_ARGS) --toc $(PANDOC_SYNTAX_HIGHLIGHT) -V gitsha=$(GITSHA) #-V title="Getting Started With Ledger"
PANDOC_PDF_ARGS= --include-before $(TMP_BEFORE_TEX)
PANDOC_HTML_ARGS= --include-before $(TMP_HTML_HEADER) --metadata "title=Prise en main de Ledger - $(TODAY) $(GITSHA)" --standalone --css pandoc.css
PANDOC_EPUB_ARGS= $(TMP_EPUB_TITLE)

all: pdf epub slices html ## launch all generation target

pre: before.tex epub_title.txt html_header.html
	mkdir -p $(TMP_DIR)
	cp before.tex $(TMP_BEFORE_TEX)
	sed -i -e 's/\$$GITSHA\$$/$(GITSHA)/g' $(TMP_BEFORE_TEX)
	cp epub_title.txt $(TMP_EPUB_TITLE)
	sed -i -e 's/\$$TODAY\$$/$(TODAY)/g' $(TMP_EPUB_TITLE)
	sed -i -e 's/\$$GITSHA\$$/$(GITSHA)/g' $(TMP_EPUB_TITLE)
	cp html_header.html $(TMP_HTML_HEADER)
	sed -i -e 's/\$$TODAY\$$/$(TODAY)/g' $(TMP_HTML_HEADER)
	sed -i -e 's/\$$GITSHA\$$/$(GITSHA)/g' $(TMP_HTML_HEADER)

md: pre
	@find *-* -name '*.md' | xargs cat > $(OUTPUT_MD)
	@python preprocess.py $(OUTPUT_MD)

pdf: md ## use pandoc to generate LaTeX & PDF file
	$(PANDOC_EXEC) $(OUTPUT_MD) $(PANDOC_ARGS) $(PANDOC_PDF_ARGS) -o $(OUTPUT_PDF)

html: md ## use pandoc to generate LaTeX & HTML file
	$(PANDOC_EXEC) $(OUTPUT_MD) $(PANDOC_ARGS) $(PANDOC_HTML_ARGS) -o $(OUTPUT_HTML)

epub: md ## use pandoc to generate LaTeX & epub file
	$(PANDOC_EXEC) $(PANDOC_ARGS) $(PANDOC_EPUB_ARGS) $(OUTPUT_MD) -t epub3 -o $(OUTPUT_EPUB)

latex: md ## use pandoc to generate LaTeX file
	@$(PANDOC_EXEC) $(OUTPUT_MD) $(PANDOC_ARGS) -o $(OUTPUT_TEX)

slices: pdf
	@# csv conversion
	pdftk $(OUTPUT_PDF) cat 9 output $(OUTPUT_NAME)_preview_p9.pdf
	@# recurring reports
	pdftk $(OUTPUT_PDF) cat 13 output $(OUTPUT_NAME)_preview_p13.pdf
	@# investing
	pdftk $(OUTPUT_PDF) cat 18 output $(OUTPUT_NAME)_preview_p18.pdf

clean: ## remove generated and tmp files
	rm -rf $(OUTPUT_MD) $(OUTPUT_PDF) $(OUTPUT_EPUB) $(OUTPUT_HTML) $(TMP_DIR)

help: ## displays the description of each target (Default)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
.PHONY: help clean slices latex epub html pdf md pre all

