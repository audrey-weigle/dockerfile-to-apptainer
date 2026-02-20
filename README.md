# Dockerfile to Apptainer

Build an apptainer `.sif` file from a Dockerfile.

## Requirements

Apptainer with `--fakeroot`, `make`. Runs on the cluster nodes at DBMI.

## Building and installing

Build: `make`

Install (under `~/.local/build_sif`:
```bash
make install
export PATH=~/.local/build_sif:"$PATH" # Add this line to ~/.bashrc, etc.
```

Uninstall: `make uninstall`

## Usage

Run this for usage information:

```bash
build_sif --help
```

Basically, you want to point it at a folder containing a Dockerfile, and tell it the name of a `.sif` file.

```bash
build_sif my_repo ./my_app.sif
```

Now you can run the sif file like a Docker container!

```bash
apptainer exec --compat ./my_app.sif my_command 
```

See the [Apptainer documentation](https://apptainer.org/docs/user/main/cli/apptainer_run.html) for more info.

## Limitations

This was made to work in the DBMI cluster nodes. Here we assume `--fakeroot`.

If you can't use fakeroot, then you can get rid of `--compat` and `--fakeroot` in the `build_sif` script.
This will make it less secure.
