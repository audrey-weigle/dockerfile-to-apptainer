#!/bin/bash
# Build an sqfs file from the source folder using Charliecloud.
# 
# Arguments:
#  - source_folder: base folder of code.
#  - [--dockerfile=<path>]: optional path to a Dockerfile.
#  - dest_folder: where to save the image.
#  - [--sqfs-filename=image.sif]: filename for the image.
# Exit codes:
#  - 0: Success.
#  - 1: Failure.


# Source config files
source /config/utils.sh
source /config/config.sh
set -euo pipefail


# ===================
# Parse the arguments
# ===================

sqfs_filename=image.sqfs
parse_args "source_folder [--dockerfile=<path>] dest_folder [--sqfs-filename=image.sqfs] " "$@"

# ====
# MAIN
# ====

[[ -d "$source_folder" ]] ||
  { err "Source folder $source_folder not a directory!"
    exit 1 
  }

[[ -d "$dest_folder" ]] ||
  { warn "Creating $dest_folder"
    mkdir -v "$dest_folder"
  }

dest_file="$dest_folder"/image.sqfs
if [[ -f "$dest_file" ]]; then
  warn "$dest_file exists already! Overwrite?"
  read -p "[y/N] " yesno 
  if [[ "${yesno,,}" == "y" ]]; then 
    msg "Removing $dest_file."
    rm "$dest_file"
  fi
fi

if [[ "$dockerfile" != EMPTY ]]; then
  msg "Copying $dockerfile to $source_folder"
  cp "$dockerfile" "$source_folder"
fi

export USER="$(whoami)"
TEMPDIR="$(mktemp -d -p /tmp)"
echo "Temp folder at $TEMPDIR"

# Automatically remove temp directory
function cleanup {
  echo "Cleaning up temp folder." >&2
  rm -rf "$TEMPDIR"
}
trap cleanup EXIT

export CH_IMAGE_STORAGE="$TEMPDIR"/charlie
ch-image build \
    --force \
    --no-cache \
    -t "image:tag" "$source_folder"
ch-convert --tmp "$TEMPDIR" "image:tag" "$dest_file" 2>&1
msg "Sqfs file is ready at $dest_file."
