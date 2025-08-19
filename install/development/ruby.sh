#!/bin/bash

set -euo pipefail

mise settings set ruby.ruby_build_opts "CC=gcc-14 CXX=g++-14"
mise settings add idiomatic_version_file_enable_tools ruby
mise use --global ruby@3.4.2
mise use ruby@latest
mise settings add idiomatic_version_file_enable_tools ruby
