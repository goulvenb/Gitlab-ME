#!/bin/sh

rm -rf ./volumes/{config,logs,data}
mkdir ./volumes/{config,logs,data}
touch ./volumes/{config,logs,data}/.gitkeep

rm -rf ./restore/{.in_progress,archive}
mkdir ./restore/{.in_progress,archive}
touch ./restore/{.in_progress,archive}/.gitkeep