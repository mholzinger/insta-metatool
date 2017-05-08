#!/bin/bash

# What we are doing:
# sqlite3 4K\ Stogram/.stogram.sqlite < query.sql

if [ -z "$1" ]
  then
    echo "No metadata string argument supplied"
    exit
fi

tag_string="$1"

# Set sqlite3 storage path
IFS= storage_path=4K\ Stogram
SQLFILE=.stogram.sqlite

sql_file=$(mktemp  -t sql_query )

# Search for file string tags from sqlite3 (omitting thumbnails and html strings)
echo "SELECT * FROM photos WHERE title LIKE '%$tag_string%';" >> "$sql_file"

sqlite3 "$storage_path"/"$SQLFILE" < "$sql_file" |\
  tr '|' '\n'|\
  grep .jpg|\
  sed -e /.thumb.stogram/d -e /instagram/d -e /?/d

rm -f "$sql_file"
