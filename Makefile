.PHONY : clean build dist publish

all : build
	@echo "Cinister updated"

clean : 
	@rm -fr lib *gz

build : cinister.coffee 
	coffee -c -o lib cinister.coffee 

dist : build package.json
	make -s build
	npm pack

publish : build package.json
	npm publish

