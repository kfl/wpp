MLCOMP ?= mlkit

.PHONY: all
all:
	$(MLCOMP) -output wpp.exe wpp.mlb

.PHONY: test
test:
	$(MAKE) -C test test

.PHONY: clean
clean:
	$(MAKE) -C test clean
	rm -rf MLB *~ wpp.exe
