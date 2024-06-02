#!/bin/bash

#set -e

function merge_pdf {
  
  IFS=';' tokens=( $1 )
  input_file=${tokens[1]}
  day=${tokens[0]}
  dest_file="$day-$2"
  
  echo "Day : $day"
  echo "Dest : $dest_file"

  if [ ! -f "$input_file" ]; then
    echo "Missing File - stopping: $input_file"
    exit 1
  fi
  
  #echo "Adding $1 to $2"
  me=$(basename "$input_file")
  
  
  echo "# $day" > ./header.md
  echo  >> ./header.md
  echo "**WB1-609-24 -- DRAFT**"  >> ./header.md
  echo  >> ./header.md
  echo "------------" >> ./header.md
  echo  >> ./header.md
  echo "**Original File: **" >> ./header.md
  echo "$me" >> ./header.md
  echo  >> ./header.md
  echo  >> ./header.md
  echo "**Notes:** " >> ./header.md
  echo >> ./header.md
  
  
  myDir=$(pwd)
  podman run --rm -v "$myDir:/data" docker.io/chgray123/pandoc-arm:extra ./header.md -o ./Header.pdf
  ls -l ./Header.pdf
  
  if [ ! -f "$dest_file" ]; then
    echo "No Dest; just copy"
    pdfunite ./Header.pdf "$input_file" temp.pdf 
  else
    pdfunite "$dest_file" ./Header.pdf "$input_file" temp.pdf 
  fi
 
  
  
  echo $?
  mv ./temp.pdf "$dest_file"  
  
  #exit 1
  echo "DONE"
}


# Start
rm ./*.pdf
cp ../Participant_Notebook_Loose/PDFs/FirstPage_Binder_Owner.pdf Day1-WB1-69-24_ParticipantGuide.pdf

cat Course_PDFS.txt | while read line 
do
  merge_pdf "${line}" WB1-69-24_ParticipantGuide.pdf
done
