#!/bin/bash

myDir=$(pwd)

echo $myDir
echo --

echo "winget install TobyAllen.DocTo"

docto -WD -f FirstPage_Binder_Owner.docx -o .\PDFs\FirstPage_Binder_Owner.pdf -t wdFormatPDF
