NON_PACKED_NOWRAP = script/nowrap.pl
PERLMOD_DEPS = lib/Text/CharWidth/PurePerl.pm

all: nowrap

# no need to explicitly list $(PERLMOD_DEPS) in the fatpack-simple command,
# "lib/" is picked up automatically
nowrap: $(NON_PACKED_NOWRAP) $(PERLMOD_DEPS)
	fatpack-simple -o $@ $<

check:
	cd tests && ./test.sh

clean:
	rm -f BOGUS tests/*.out

.PHONY: all clean
