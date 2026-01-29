#!/bin/bash

mkdir -p dir1/dir2
touch dir1/dir2/file
ln -s dir1/dir2/file dir1/file_softlink
ls -l dir1
