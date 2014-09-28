DC=dmd
DFLAGS=-O -release
SOURCES=main.d matrix.d integral.d polynomials.d

all:
	$(DC) $(DFLAGS) $(SOURCES)

debug:
	$(DC) -unittest -g $(SOURCES)