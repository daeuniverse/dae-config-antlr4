.PHONY: all clean dir g4 go cpp readme

all: clean dir readme g4 go cpp

clean:
	rm -rf build/

dir: clean
	mkdir build/

g4: dir
	cp *.g4 build/

go: g4
	cd build && \
		antlr4 -Dlanguage=Go -o go/dae_config/ -package "dae_config" dae_config.g4 && \
		cd go/dae_config/ && \
		go mod init github.com/daeuniverse/dae-config-dist/go/dae_config && \
		echo 'require github.com/antlr/antlr4/runtime/Go/antlr/v4 v4.0.0-20230305170008-8188dc5388df' >> go.mod && \
		go mod tidy

cpp: g4
	cd build && \
		antlr4 -Dlanguage=Cpp -o cpp/dae_config/ -package "dae_config" dae_config.g4

readme: dir
	cd build && \
		echo "Dist of [dae-config-antlr4](https://github.com/daeuniverse/dae-config-antlr4)" > README.md
