#!/bin/bash

mise use --global ruby@3.4.2
mise use ruby@latest
mise settings add idiomatic_version_file_enable_tools ruby
mise x ruby -- gem install rails --no-document
mise use --global python@latest
mise use --global node@lts
mise use --global go@latest