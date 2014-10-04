DC=gdmd
RELEASE_FLAGS=-O -release -noboundscheck -inline
DEBUG_FLAGS=-unittest -g
SOURCES=main.d matrix.d integral.d polynomials.d

all:
	$(DC) $(RELEASE_FLAGS) $(SOURCES)

debug:
	$(DC) $(DEBUG_FLAGS) $(SOURCES)
