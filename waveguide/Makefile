CXXFLAGS=-std=c++11 -Wall -Wextra -O2

SRCS=linalg/matrix.cpp linalg/vector.cpp calc_modes.cpp
OBJS=$(subst .cpp,.o,$(SRCS))

all: calc_modes

calc_modes: $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

depend: .depend

.depend: $(SRCS)
	rm -f .depend
	$(CXX) $(CXXFLAGS) -MM $^ >> .depend;

clean:
	$(RM) $(OBJS)

dist-clean: clean
	$(RM) *~ .depend

include .depend
