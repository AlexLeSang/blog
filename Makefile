build:
	hugo --destination ../AlexLeSang.github.io/

server: build
	hugo server -D
