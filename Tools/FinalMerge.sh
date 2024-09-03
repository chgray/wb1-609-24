#!/bin/bash


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

 rm ./WB1-609-24_Patrol_Leader.pdf
 rm ./WB1-609-24_Participant_Guide.pdf
 
 merge_pdf Day1_PLN-WB1-609-24.pdf WB1-609-24_Patrol_Leader.pdf
 merge_pdf Day2_PLN-WB1-609-24.pdf WB1-609-24_Patrol_Leader.pdf
 merge_pdf Day3_PLN-WB1-609-24.pdf WB1-609-24_Patrol_Leader.pdf
 merge_pdf Day4_PLN-WB1-609-24.pdf WB1-609-24_Patrol_Leader.pdf
 merge_pdf Day5_PLN-WB1-609-24.pdf WB1-609-24_Patrol_Leader.pdf
 ./number_pages.sh ./WB1-609-24_Patrol_Leader.pdf


merge_pdf Day0-WB1-609-24.pdf WB1-609-24_Participant_Guide.pdf
merge_pdf Day1-WB1-609-24.pdf WB1-609-24_Participant_Guide.pdf
merge_pdf Day2-WB1-609-24.pdf WB1-609-24_Participant_Guide.pdf
merge_pdf Day3-WB1-609-24.pdf WB1-609-24_Participant_Guide.pdf
merge_pdf Day4-WB1-609-24.pdf WB1-609-24_Participant_Guide.pdf
merge_pdf Day5-WB1-609-24.pdf WB1-609-24_Participant_Guide.pdf
merge_pdf Day6-WB1-609-24.pdf WB1-609-24_Participant_Guide.pdf

./number_pages.sh ./WB1-609-24_Participant_Guide.pdf
