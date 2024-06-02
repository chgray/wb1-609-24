#!/bin/bash

#set -e

function make_header {
  make_header_day=$1
  make_header_input_file=$2
  make_header_dest_file=$3
  make_header_me=$(basename "$input_file")
  
  
  if [ -f ./header.md ]; then
    rm ./header.md
    exit 1
  fi
  
  echo "# $make_header_day" > ./header.md
  echo  >> ./header.md
  echo "**WB1-609-24 -- DRAFT**"  >> ./header.md
  echo  >> ./header.md
  echo "------------" >> ./header.md
  echo  >> ./header.md
  echo "**Original File: **" >> ./header.md
  echo "$make_header_me" >> ./header.md
  echo  >> ./header.md
  echo  >> ./header.md
  echo "**Notes:** " >> ./header.md
  echo >> ./header.md
    
  make_header_myDir=$(pwd)
  podman run --rm -v "$make_header_myDir:/data" docker.io/chgray123/pandoc-arm:extra ./header.md -o ./Header.pdf
  
  rm ./header.md
}


function merge_pdf {
  merge_pdf_input_file=$1
  merge_pdf_dest_file=$2  

  if [ ! -f "$merge_pdf_input_file" ]; then
    echo "Missing File - stopping: $merge_pdf_input_file"
    exit 1
  fi
  
  echo "Adding $merge_pdf_input_file to $merge_pdf_dest_file"

  merge_pdf_me=$(basename "$merge_pdf_input_file")  


  pdfunite "$merge_pdf_dest_file" "$merge_pdf_input_file" temp.pdf 
  echo $?
  mv ./temp.pdf "$merge_pdf_dest_file"  
  
  #exit 1
  echo "DONE"
}


# Start
rm ./*.pdf
cp ../Participant_Notebook_Loose/PDFs/FirstPage_Binder_Owner.pdf Day1-WB1-69-24_ParticipantGuide.pdf

cat Course_PDFS.txt | while read line 
do

  IFS=';' tokens=( $line )
  input_file=${tokens[1]}
  day=${tokens[0]}
  dest_file="$day-WB1-69-24_ParticipantGuide.pdf"
  
  if [ ! -f "$input_file" ]; then
    echo "Missing File - stopping: $input_file"
    exit 1
  fi

  echo "InputFile : $input_file"
  make_header $day $input_file $dest_file
  echo "Merging Header"
  merge_pdf Header.pdf $dest_file
  
  echo "Merging real file: $input_file"
  merge_pdf $input_file $dest_file
done
