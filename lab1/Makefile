DC=dmd
DFLAGS=-O -release
SOURCES=$(shell ls *.d)

all:
	$(DC) $(DFLAGS) $(SOURCES)

debug:
	$(DC) -unittest -g $(SOURCES)