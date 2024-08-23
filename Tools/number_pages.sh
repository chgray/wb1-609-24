#!/bin/bash

#set -e
echo "Numbering Pages"
echo $1


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
  
  #exit 1
  echo "DONE"
}



input_file=$1
echo $input_file 


if [ ! -f "$input_file" ]; then
    echo "Missing File - stopping: $input_file"
    exit 1
fi

mkdir ./temp_page_number

rm ./temp_page_number/*.pdf
cp $input_file ./temp_page_number/input.pdf

cd ./temp_page_number



echo "\documentclass[12pt,a4paper]{article}" > pageNumbers.lex
echo "\usepackage{multido}"  >> pageNumbers.lex
echo "\usepackage[hmargin=.8cm,vmargin=1.25cm,nohead,nofoot]{geometry}" >> pageNumbers.lex
echo "\begin{document}" >> pageNumbers.lex
echo "\multido{}{400}{\vphantom{x}\newpage}" >> pageNumbers.lex
echo "\end{document}">> pageNumbers.lex

pdflatex pageNumbers.lex

# exploder the input file
pdftk input.pdf burst output file_%03d.pdf
pdftk pageNumbers.pdf burst output number_%03d.pdf

count=$(find file_* -maxdepth 1 -type f|wc -l)
echo "NUM $count"

# explode the page numbers
pdftk $input_file burst output file_%03d.pdf
pdftk pageNumbers.pdf burst output number_%03d.pdf

# Combine the files
time for i in $(seq -f %03g 1 400) ; do pdftk file_$i.pdf background number_$i.pdf output new-$i.pdf ; done

pdftk new-???.pdf output new.pdf


if [[ $(($count % 2)) -eq 0 ]]; then
    echo "$var is even"; 
else echo "$var is odd"; 
    merge_pdf ../../Participant_Notebook_Loose/WB1_609-24_Specific/Day0_Prep/PDFs/BlankNotePage.pdf new.pdf
fi

cd ..
cp ./temp_page_number/new.pdf $input_file