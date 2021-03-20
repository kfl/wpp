.PHONY: all
all:
	$(MAKE) -C lib/github.com/kfl/wpp all

.PHONY: test
test:
	$(MAKE) -C lib/github.com/kfl/wpp test

.PHONY: clean
clean:
	$(MAKE) -C lib/github.com/kfl/wpp clean
	rm -rf MLB *~ .*~
