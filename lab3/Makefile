LDFLAGS=-lm -g

all: hyperbolic parabolic elliptic

parabolic: common.o parabolic.o
	gcc $(LDFLAGS) common.o parabolic.o -o parabolic

hyperbolic: common.o hyperbolic.o
	gcc $(LDFLAGS) common.o hyperbolic.o -o hyperbolic

%.o: %.c %.h
	gcc -c -o $@ $<
