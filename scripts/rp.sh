#!/usr/bin/env bash
set -e
script_path="$0"
script_directory="$(dirname "$script_path")"
cd $script_directory/../rp
nohup go run rp.go 8182 notes-service.com &