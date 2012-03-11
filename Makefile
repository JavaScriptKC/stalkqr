TESTS = $(shell find test -name "*.spec.coffee")
REPORTER = spec

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--require should \
		--reporter $(REPORTER) \
		--globals i \
		$(TESTS)

.PHONY: test