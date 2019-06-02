#!/bin/bash

Directory="/Users/tongpingliu/picturebackup/"
#/Volumes/FreeAgent GoFlex Drive 2/picture/backup";
cd $Directory

for dirname in "$Directory"/*
{
 # dirarray=(`echo $dir | tr "/" " "`); 
  dir=`basename $dirname`;
  printf "$dir\n";

  # find files in this diectory
  rm ToBeAnalyzed;

  find $dir -iname "*.jpg" >> ToBeAnalyzed;
  find $dir -iname "*.MOV" >> ToBeAnalyzed;

  while read file; do
    # Fetch the first two directory to combine to a new directory.
    echo $file;
    filearray=(`echo $file | tr "/" " "`); 
    filename=`basename $file`;

    newdir=$(stat -f "%Sm" -t "%Y%m" $file); 
    #newdir="${filearray[0]}${filearray[1]}";

    olddir=$Directory"/"$dir;
    newdir=$Directory"/"$newdir;
    echo "newdir is $newdir";
  
    destfile=$newdir"/"$filename;

    if [ "$olddir" = "$newdir" ]; then
      continue;
    fi

    # Now let's copy the current file to the new directory
    mkdir -p "$newdir";

    if [ -f $destfile ]; then
      # Check the size of the file, if the current size is bigger, then copy
      oldfilesize=`stat -f "%z" "$file"`;
      newfilesize=`stat -f "%z" "$destfile"`;
      if [ $newfilesize -lt $oldfilesize ]; then
        # Copy the current file
        echo "Copying $file to $destfile";
        cp -f "$file" "$destfile"
      fi
    else
      echo "Copying $file to $destfile";
      cp -f "$file" "$destfile"
    fi

    rm -f $file
 
  done < ToBeAnalyzed;

}

#mytest;


