build:
	@go build -o bin/podkrepizza cmd/api/main.go

run: build
	@./bin/podkrepizza

test:
	@go test -v ./...

clear:
	@rm -rf ./bin
