#!/bin/bash

if [ -z "$1" ]
  then
    echo "No metadata string argument supplied"
    exit
fi

# Set output path for copying files
copy_path="/tmp/instagram"

# Set sqlite3 storage path
IFS= storage_path=4K\ Stogram
SQLFILE=.stogram.sqlite

# Copy files with tagged instagram metadata to a path
qlist=$(mktemp  -t qlist )
sql_file=$(mktemp  -t sql_file )

tag_string="$1"
mkdir -p "$copy_path"/"$tag_string"

# Search for file string tags from sqlite3 (omitting thumbnails and html strings)
echo "SELECT * FROM photos WHERE title LIKE '%$tag_string%';" >> "$sql_file"
sqlite3 "$storage_path"/"$SQLFILE" < "$sql_file" |\
  tr '|' '\n'|\
  grep .jpg |\
  sed -e /.thumb.stogram/d -e /instagram/d -e /?/d >> "$qlist"

echo "Found " `wc -l "$qlist"|awk '{print $1}'` "file entries for" "$tag_string"

# Copy loop for files
cat "$qlist"|\
while IFS= read -r imgz
  do
    if [ -e "$storage_path"/"$imgz" ];
      then
      cp "$storage_path"/"$imgz" "$copy_path"/"$tag_string"
    fi
done

# 
echo "Copied" `ls "$copy_path"/"$tag_string"/|wc -l|awk '{print $1}'` "files to path" "$copy_path"/"$tag_string"

rm -f "$sql_file"
rm -f "$qlist"
