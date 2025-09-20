all::
	docker build . -t wcc-unstrip:latest

run::
	docker run -it --user 0 wcc-unstrip:latest
	
test::
	docker run -it --user 0 wcc-unstrip:latest bash -c "make test"

