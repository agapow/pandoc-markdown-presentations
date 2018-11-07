### CONSTANTS & DEFINES

## Executables
PANDOC_EXE=pandoc

## File paths

# input presentation
SRC_FORMAT=md
PREZ_ROOT=presentation
SRC_PREZ=$(PREZ_ROOT).$(SRC_FORMAT)

# output dir
OUTPUT=output
mkdir -p $(OUTPUT)

## Commandline options

# this is how you pass a custom beamer directives including theme
# don't leave spaces in arg values
BEAMER_OPTS=-V colortheme:Imperial -M classoption:aspectratio=169


### TARGETS

## Powerpoint
# - pandoc says that most standard powerpoint templates should work but in reality only about half do. The others complain "Could not find shape for Powerpoint content"
# - Saving a potx that works as a pptx or potm in LibreOffice breaks it

DST_PPTX=$(OUTPUT)/$(PREZ_ROOT).pptx

pptx: $(DST_PPTX)

$(DST_PPTX): $(SRC_PREZ)
	$(PANDOC_EXE) -t pptx -s $(SRC_PREZ) -o $(DST_PPTX) --reference-doc icl-mock.potx


## PDF via beamer
# - doesn't seem to be any way to explicitly pass email address
# - if you pass email as part of name in angled brackets <>, they are removed
# - but round braces work
# - but marking it up as a link doesn't
# - columns seem to disregard margins and take all of page
# - if you don't explicitly set column width, it splits them evenly and takes all of page
# - you used to have to hack notes into beamer but pandoc now handles them in the standard way for presentations

DST_PDF=$(OUTPUT)/$(PREZ_ROOT).slides.pdf

pdf: $(DST_PDF)

$(DST_PDF): $(SRC_PREZ)
	$(PANDOC_EXE) -t beamer -s $(SRC_PREZ) -o $(DST_PDF) $(BEAMER_OPTS)


## PDF notes via beamer
# - for every page with notes, produces page with notes and inset slide
DST_NOTES=$(OUTPUT)/$(PREZ_ROOT).notes.pdf

notes: $(DST_NOTES)

$(DST_NOTES): $(SRC_PREZ)
	$(PANDOC_EXE) -t beamer -s $(SRC_PREZ) -o $(DST_NOTES) -M classoption:notes=only


## Raw tex via beamer
# - mainly for debugging
DST_TEX=$(OUTPUT)/$(PREZ_ROOT).tex

tex: $(DST_TEX)

$(DST_TEX): $(SRC_PREZ)
	$(PANDOC_EXE) -t beamer -s $(SRC_PREZ) -o $(DST_TEX) $(BEAMER_OPTS)


## Admin

clean:
	rm -f $(OUTPUT)/*


### END ###
