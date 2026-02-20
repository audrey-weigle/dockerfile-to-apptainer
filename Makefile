all:
	apptainer build dockerfile_to_sqfs src/ch.def
	ln -s ./src/config ./config

install:
	mkdir -p ~/.local/build_sif/config
	cp ./dockerfile_to_sqfs ~/.local/build_sif/dockerfile_to_sqfs
	cp ./build_sif          ~/.local/build_sif/build_sif
	cp -r ./config/* ~/.local/build_sif/config
	@echo "Now add ~/.local/build_sif to your PATH: https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path"

clean:
	rm dockerfile_to_sqfs
	unlink ./config

uninstall:
	rm -r ~/.local/build_sif/*
	rmdir ~/.local/build_sif
