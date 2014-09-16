DC=dmd
DFLAGS=-O -release
SOURCES=main.d matrix.d

all:
	$(DC) $(DFLAGS) $(SOURCES)

debug:
	$(DC) -unittest -g $(SOURCES)