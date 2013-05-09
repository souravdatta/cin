.PHONY : clean build dist publish

all : build
	@echo "Cinister updated"

clean : 
	@rm -fr lib *gz

build : cinister.coffee ciniutils.coffee
	coffee -c -o lib cinister.coffee ciniutils.coffee

dist : build package.json
	make -s build
	npm pack

publish : build package.json
	npm publish

