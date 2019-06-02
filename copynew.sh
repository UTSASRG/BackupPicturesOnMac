#!/bin/bash

srcDirectory="/Users/tongpingliu/Pictures/iPhoto Library_2.photolibrary/Masters/2019/"
#20180615-183907"
#/Users/tongpingliu/Pictures/iPhoto Library_2.photolibrary/Masters";
destDirectory="/Volumes/FreeAgent GoFlex Drive/picture/backup";
subDirectories=("05");
#subDirectories=("2014" "2015" "2016");
printf "$srcDirectory\n";



# Delete the file that will be analyzed
cd "$srcDirectory";
rm -f ToBeAnalyzed;
mkdir -p "$destDirectory";
#echo "test" > ToBeAnalyzed;

# Check each subdirectory one by one.
for dir in "${subDirectories[@]}"
{
  # Finding out the file in this directory.
#  $srcDir = $srcDirectory"./"$dir
#  $srcDir = "$srcDirectory/$dir";
  printf "source directory is $dir\n";

  find $dir -iname "*.jpg" >> ToBeAnalyzed;
  find $dir -iname "*.MOV" >> ToBeAnalyzed; 
}

# Now the files are found out.
# array=(`echo $dir | tr "/" " "`);
# for i in "${!array[@]}"
# do
#    echo "$i=>${array[i]}"
# done


while read file; do
  # Fetch the first two directory to combine to a new directory.
  echo $file;
  filearray=(`echo $file | tr "/" " "`); 
  filename=`basename $file`;

  newdir=$(stat -f "%Sm" -t "%Y%m" $file); 
  #newdir="${filearray[0]}${filearray[1]}";

  destdir=$destDirectory"/"$newdir;
  echo "destdir is $destdir";
  
  destfile=$destdir"/"$filename;

  mkdir -p "$destdir";


  # find out all files with the same name and output to a file.
  filesize=`stat -f "%z" "$file"`;
  find "$destdir" -name $filename > samenamefiles;
  
  # Check every file in the list
  toCopyFile="true";
  hasSameNameFile="false";

  while read samenamefile; do 
    echo "samefile "$samenamefile"";
    newsize=`stat -f "%z" "$samenamefile"`;
   
    # check whether this file is existing or not
    # It is impossible for two different files that have the same name and have the same size
    if [ $newsize -lt $filesize ]; then
      toCopyFile="true";
      break;
    elif [ "$destfile" == "$samenamefile" ]; then
      hasSameNameFile="true";
      toCopyFile="false";
    fi
  done < samenamefiles;

  # if we are trying to copy the file  
  if [ $toCopyFile == "true" ]
  then
    echo "copying $destfile";
    echo "$destfile" >> copfile;
    cp -f "$file" "$destfile" 
  else
    echo "no need to copy $destfile"
  fi  

  
  # First, let's check whether this file exists or not: the same name and size
#  if[ -f 
 
  # Otherwise, copy to the new directory. 

done < ToBeAnalyzed;
#mytest;


