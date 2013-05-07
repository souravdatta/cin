.PHONY : clean build dist publish

all : build
	@echo "Cinister updated"

clean : 
	@rm -fr lib *gz

build : cin.coffee
	coffee -c -o lib cin.coffee

dist : build package.json
	npm pack

publish : build package.json
	npm publish

