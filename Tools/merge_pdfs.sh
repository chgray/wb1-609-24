#!/bin/bash

#set -e

function make_even {
  make_even_input_file=$1

  echo "make_even: $make_even_input_file"

  count=$(pdftk $make_even_input_file dump_data | grep NumberOfPages | gawk '{print $2}')

  echo "back"
  echo $count


  if [[ $(($count % 2)) -eq 0 ]]; then
    echo "$var is even";
  else echo "$var is odd";
      merge_pdf ../Participant_Notebook_Loose/WB1_609-24_Specific/Day0_Prep/PDFs/BlankNotePage.pdf $make_even_input_file
  fi
}

function make_header {
  make_header_day=$1
  make_header_input_file=$2
  make_header_dest_file=$3
  make_header_me=$(basename "$input_file")


  if [ -f ./header.md ]; then
    rm ./header.md
    exit 1
  fi


  echo "" > ./header.md
  echo "---" >> ./header.md
  echo "header-includes: \pagenumbering{gobble}" >> ./header.md
  echo "..." >> ./header.md



  echo "![](./FullSailLogo.png){width=20%}" >> ./header.md
  echo "" >> ./header.md
  echo "" >> ./header.md

  echo "## Single Document Change Form ($make_header_me:$make_header_day)" >> ./header.md
  echo "" >> ./header.md

  echo "## Purpose : this page is for Staff and Guides to provide changes to Scribe" >> ./header.md
  echo "" >> ./header.md
  echo "* it will not be included in the final course material" >> ./header.md
  echo "* it's intended as a way for Staff to track and organize necessary changes, during SD1/SD2/etc" >> ./header.md
  echo "* this page contains the original files/location of the printed content;  to make discovery/tracking easier" >> ./header.md

  echo "" >> ./header.md
  echo "" >> ./header.md

  echo "## Process to make a changes in the following sections" >> ./header.md

  echo "" >> ./header.md
  echo "### 1. Digital (Preferred) : Scan this on your Phone and fill out the form!" >> ./header.md
  echo "" >> ./header.md
  echo "![](./FeedbackFormChangeRequest.png){width=20%}" >> ./header.md
  echo "" >> ./header.md
  echo "### 2. Paper" >> ./header.md

  echo "" >> ./header.md
  echo "" >> ./header.md
  echo "1. Using a pen/pencil, on this page, describe the change you need" >> ./header.md
  echo "1. Remove this page, and the page that needs changes, from your notebook" >> ./header.md
  echo "1. Staple them together" >> ./header.md
  echo "1. Give to Scribe (Travis or Chris)" >> ./header.md
  echo  >> ./header.md

  echo "**Original File: **" >> ./header.md
  echo "$make_header_me" >> ./header.md
  echo  >> ./header.md
  echo  >> ./header.md
  echo "**Notes:** " >> ./header.md
  echo >> ./header.md

  make_header_myDir=$(pwd)
  podman run --rm -v "$make_header_myDir:/data" docker.io/chgray123/pandoc-arm:extra ./header.md -o ./Header.pdf -V geometry:margin=0.5in
  # merge_pdf ../Participant_Notebook_Loose/WB1_609-24_Specific/Day0_Prep/PDFs/BlankNotePage.pdf ./Header.pdf

  make_even ./Header.pdf
  rm ./header.md
}


function merge_pdf {
  merge_pdf_input_file=$1
  merge_pdf_dest_file=$2

  if [ ! -f "$merge_pdf_input_file" ]; then
    echo "Missing File - stopping: $merge_pdf_input_file"
    exit 1
  fi

  if [ ! -f "$merge_pdf_dest_file" ]; then
    echo "Output doesnt exist, copying"
    cp $merge_pdf_input_file $merge_pdf_dest_file
    return 0
  fi


  echo "Adding $merge_pdf_input_file to $merge_pdf_dest_file"

  merge_pdf_me=$(basename "$merge_pdf_input_file")


  pdfunite "$merge_pdf_dest_file" "$merge_pdf_input_file" temp.pdf
  echo $?
  mv ./temp.pdf "$merge_pdf_dest_file"

  make_even $merge_pdf_dest_file
  #exit 1
  echo "DONE"
}

# Start
rm ./*.pdf
rm ./*.md

#cp ../Participant_Notebook_Loose/PDFs/FirstPage_Binder_Owner.pdf Day1-WB1-69-24.pdf

#
#  Build up a header for the section
#
cat Course_PDFS.txt | while read line
do
  IFS=';' tokens=( $line )
  input_file=${tokens[1]}
  day=${tokens[0]}
  dest_file="$day-WB1-69-24.pdf"
  header_name="$day-Header.md"

  echo "HeaderName $header_name"

  if [ ! -f "$header_name" ]; then
    echo "Missing File - stopping: $input_file"

    echo ""  >> $header_name
    echo "---" >> $header_name
    echo "header-includes: \pagenumbering{gobble}" >> $header_name
    echo "..." >> $header_name


    echo "![](./FullSailLogo.png){width=20%}" >> $header_name
    echo "" >> $header_name

    echo "# **WB1-609-24 Scribe Notes** ($day) Summary" >> $header_name
    echo "" >> $header_name

    echo "## Document Purpose:" >> $header_name
    echo "" >> $header_name
    echo "* for Staff to make changes in the following document content" >> $header_name
    echo "* this particular page, will not be included in the final course material" >> $header_name
    echo "* this page is only intended as a way for Staff to track and organize necessary changes, during SD1/SD2/etc" >> $header_name
    echo "* this page contains the original files/location of the printed content;  to make discovery/tracking easier" >> $header_name

    echo "" >> $header_name
    echo "" >> $header_name

    echo "------------" >> $header_name
    echo "" >> $header_name
    echo "## Process to make a changes in the following sections" >> $header_name

    echo "" >> $header_name
    echo "### 1. Digital change submission (Preferred) : Scan this on your Phone and fill out the form!" >> $header_name
    echo "" >> $header_name
    echo "![](./FeedbackFormChangeRequest.png){width=20%}" >> $header_name
    echo "" >> $header_name
    echo "### 2. Paper" >> $header_name

    echo "" >> $header_name
    echo "1. Using a pen/pencil, on this page, describe the change you need" >> $header_name
    echo "1. Remove this page, and the page that needs changes, from your notebook" >> $header_name
    echo "1. Staple them together" >> $header_name
    echo "1. Give to Scribe (Travis or Chris)" >> $header_name
    echo  >> $header_name
    echo  >> $header_name

    echo "------------" >> $header_name
    echo  >> $header_name
    echo "## Order of files:" >> $header_name
    echo  >> $header_name
    echo "This '$day' the ORIGINAL content from National is in contained, by this section, in the following order" >> $header_name
    echo   >> $header_name
    echo " | Section | File | " >> $header_name
    echo  " | --| -- | " >> $header_name
  fi

  echo $input_file | gawk '{split($0, bits, "/"); print("|" bits[5] "|" bits[6] "|");}' >>  $header_name

  if [ ! -f "$input_file" ]; then
    echo "Missing File - stopping: $input_file"
    exit 1
  fi

  echo $day
  echo $input_file
  echo "----"
done

#
# Start each file with just the header
#
cat Course_PDFS.txt | while read line
do
  IFS=';' tokens=( $line )
  input_file=${tokens[1]}
  day=${tokens[0]}
  dest_file="$day-Header.pdf"
  header_name="$day-Header.md"

  if [ ! -f "$input_file" ]; then
    echo "Missing File - stopping: $input_file"
    exit 1
  fi

  if [ ! -f "$dest_file" ]; then
    echo "Header : $header_name"
    echo "Dest : $dest_file"

    make_header_myDir=$(pwd)
    echo podman run --rm -v "$make_header_myDir:/data" docker.io/chgray123/pandoc-arm:extra $header_name -o $dest_file -V geometry:margin=0.5in
    podman run --rm -v "$make_header_myDir:/data" docker.io/chgray123/pandoc-arm:extra $header_name -o $dest_file -V geometry:margin=0.5in

    make_even $dest_file
  fi
done




cat Course_PDFS.txt | while read line
do
  IFS=';' tokens=( $line )
  input_file=${tokens[1]}
  day=${tokens[0]}
  dest_file="$day-WB1-609-24.pdf"
  main_header="$day-Header.pdf"

  if [ ! -f "$input_file" ]; then
    echo "Missing File - stopping: $input_file"
    exit 1
  fi


  if [ ! -f "$dest_file" ]; then
    cp $main_header $dest_file
  fi

  echo "InputFile : $input_file"
  make_header $day $input_file $dest_file
  echo "Merging Header"
  merge_pdf Header.pdf $dest_file

  echo "Merging real file: $input_file"
  merge_pdf $input_file $dest_file
done


echo "Glueing all together"

