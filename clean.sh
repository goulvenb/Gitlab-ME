#!/bin/sh

rm -rf ./volumes/*
mkdir ./volumes/{config,logs,data}
touch ./volumes/{config,logs,data}/.gitkeep

rm -rf ./restore/*
mkdir ./restore/{.in_progress,archive}
touch ./restore/{.in_progress,archive}/.gitkeep

find ./backups/ -mindepth 1 -regextype posix-extended -not -regex '^\./backups/[0-9]{14}_v[0-9]+\.[0-9]+\.[0-9]+_gitlab_backup\.tar$' -print
touch ./backups/.gitkeep