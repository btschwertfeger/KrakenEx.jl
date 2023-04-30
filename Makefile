#!make
# -*- coding: utf-8 -*-
# Copyright (C) 2023 Benjamin Thomas Schwertfeger
# Github: https://github.com/btschwertfeger

## help	Print this help message
##
help:
	@grep "^##" Makefile | sed -e "s/##//"

## tests	Run the unit tests
##
tests:
	julia -e 'using Pkg; Pkg.activate("."); Pkg.test()'

## doc	Build the documentation
##
doc:
	julia -e 'using Pkg; Pkg.activate("."); using Documenter; include("docs/make.jl")'

## clean Remove temporary files
##
clean:
	rm *.zip
	rm -rf docs/build
