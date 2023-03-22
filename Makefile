.PHONY: build anime manga

build:
	docker build --tag anidiff:latest .

anime:
	docker run --rm --env MAL_USERNAME=$(MAL_USERNAME) --env SHIKI_USERNAME=$(SHIKI_USERNAME) anidiff mix diff anime

manga:
	docker run --rm --env MAL_USERNAME=$(MAL_USERNAME) --env SHIKI_USERNAME=$(SHIKI_USERNAME) anidiff mix diff manga
