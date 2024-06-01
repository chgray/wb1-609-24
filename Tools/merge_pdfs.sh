#!/bin/bash

#set -e

function merge_pdf {
  if [ ! -f "$1" ]; then
    echo "Missing File - stopping: $1"
    exit 1
  fi
  
  #echo "Adding $1 to $2"
  me=$(basename "$1")
  
  echo "# NEW DOCUMENT MARKER" > ./header.md
  echo "------------" >> ./header.md
  echo . >> ./header.md
  echo "   *Original File: $me*" >> ./header.md
  echo . >> ./header.md
  echo "   *Notes:* " >> ./header.md
  echo . >> ./header.md
  myDir=$(pwd)
  podman run --rm -v "$myDir:/data" docker.io/chgray123/pandoc-arm:extra ./header.md -o ./Header.pdf
  ls -l ./Header.pdf
  pdfunite "$2" ./Header.pdf "$1" temp.pdf 
  echo $?
  mv ./temp.pdf "$2"  
  
  echo "DONE"
}


# Start
cp ../Participant_Notebook_Loose/PDFs/FirstPage_Binder_Owner.pdf ./WB1-69-24_ParticipantGuide.pdf

cat Course_PDFS.txt | while read line 
do
  merge_pdf "${line}" ./WB1-69-24_ParticipantGuide.pdf
done
