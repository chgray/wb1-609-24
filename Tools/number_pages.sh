#!/bin/bash

#set -e
echo "Numbering Pages"
echo $1

input_file=$1
echo $input_file 


if [ ! -f "$input_file" ]; then
    echo "Missing File - stopping: $input_file"
    exit 1
fi

mkdir ./temp_page_number
cp $input_file ./temp_page_number

cd ./temp_page_number

echo "\documentclass[12pt,a4paper]{article}" > pageNumbers.lex
echo "\usepackage{multido}"  >> pageNumbers.lex
echo "\usepackage[hmargin=.8cm,vmargin=1.5cm,nohead,nofoot]{geometry}" >> pageNumbers.lex
echo "\begin{document}" >> pageNumbers.lex
echo "\multido{}{164}{\vphantom{x}\newpage}" >> pageNumbers.lex
echo "\end{document}">> pageNumbers.lex

pdflatex pageNumbers.lex

# explode the page numbers
pdftk $input_file burst output file_%03d.pdf
pdftk pageNumbers.pdf burst output number_%03d.pdf


# exploder the input file
pdftk $input_file burst output file_%03d.pdf
pdftk pageNumbers.pdf burst output number_%03d.pdf

# Combine the files
time for i in $(seq -f %03g 1 164) ; do pdftk file_$i.pdf background number_$i.pdf output new-$i.pdf ; done
x
pdftk new-???.pdf output new.pdf