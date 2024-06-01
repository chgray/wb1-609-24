#!/bin/bash

set -e

function merge_pdf {
  if [ ! -f "$1" ]; then
    echo "Missing File - stopping: $1"
    exit 1
  fi
  
  # echo "Adding $1 to $2"
  pdfunite "$2" "$1" temp.pdf 
  echo $?
  
  mv ./temp.pdf "$2"  
}


# Start
cp ../Participant_Notebook_Loose/PDFs/FirstPage_Binder_Owner.pdf ./WB1-69-24_ParticipantGuide.pdf


cat Course_PDFS.txt | while read line 
do
  merge_pdf "${line}" ./WB1-69-24_ParticipantGuide.pdf
done
