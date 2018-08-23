version := "v1.0.0"

build: dist/sso-auth dist/sso-proxy

dist/sso-auth: 
	mkdir -p dist
	go build -o dist/sso-auth ./cmd/sso-auth

dist/sso-proxy: 
	mkdir -p dist
	go build -o dist/sso-proxy ./cmd/sso-proxy

test: 
	./scripts/test

clean:
	rm -r dist

image:
	mkdir -p /tmp/sso-docker
	cp Dockerfile /tmp/sso-docker
	GOOS=linux GOARCH=amd64 go build -o /tmp/sso-docker/sso-auth ./cmd/sso-auth
	GOOS=linux GOARCH=amd64 go build -o /tmp/sso-docker/sso-proxy ./cmd/sso-proxy
	docker build -t buzzfeed/sso:$(version) /tmp/sso-docker

imagepush: image
	docker push buzzfeed/sso:$(version)