# Build, package and clean Fatiando
PY=python
PIP=pip
NOSE=nosetests

# To upload to PyPI run:
# python setup.py sdist --formats=zip,gztar upload

.PHONY: help
help:
	@echo "Commands:"
	@echo ""
	@echo "    build         build the extension modules inplace"
	@echo "    docs          build the html documentation"
	@echo "    docs-pdf      build the pdf documentation"
	@echo "    view-docs     show the html docs on firefox"
	@echo "    test          run the test suite (including doctests)"
	@echo "    deps          installs development requirements"
	@echo "    package       create source distributions"
	@echo "    clean         clean up"
	@echo ""

# BUILD EXTENSION MODULES
.PHONY: build
build:
	$(PY) setup.py build_ext --inplace

# BUILD THE DOCS
.PHONY: docs
docs: clean
	cd doc; make html

.PHONY: docs-pdf
docs-pdf: clean
	cd doc; make latexpdf

.PHONY: view-docs
view-docs:
	firefox doc/_build/html/index.html &

# RUN ALL TESTS
.PHONY: test
test:
	$(NOSE) fatiando
	$(NOSE) test

# INSTALL THE DEPENDENCIES
.PHONY: deps
deps: requires.txt
	$(PIP) install -r $<

# MAKE A SOURCE DISTRIBUTION
.PHONY: package
package: docs-pdf
	$(PY) setup.py sdist --formats=zip,gztar

# UPLOAD TO PYPI
.PHONY: upload
	python setup.py register sdist --formats=zip,gztar upload

# CLEAN THINGS UP
.PHONY: clean
clean:
	find . -name "*.so" -exec rm -v {} \;
	find "fatiando" -name "*.c" -exec rm -v {} \;
	find . -name "*.pyc" -exec rm -v {} \;
	rm -rvf build dist MANIFEST
	# Trash generated by the doctests
	rm -rvf mydata.txt mylogfile.log
	# The stuff fetched by the cookbook recipes
	rm -rvf logo.png cookbook/logo.png
	rm -rvf crust2.tar.gz cookbook/crust2.tar.gz

.PHONY: clean-docs
clean-docs:
	# Clean the docs as well
	cd doc; make clean
